import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

import '../models/music_model.dart';
import '../models/download_task_model.dart';



class DownloadManagerService extends GetxService {
  static const _storageKey = 'download_tasks';

  final box = GetStorage();
  final RxMap<String, DownloadTaskModel> tasks = <String, DownloadTaskModel>{}.obs;

  final Map<String, StreamSubscription<List<int>>> _activeSubscriptions = {};

  @override
  void onInit() {
    super.onInit();
    _restoreTasks();
  }

  DownloadTaskModel? taskFor(String songId) => tasks[songId];

  String? localPathFor(String songId) {
    final path = tasks[songId]?.localPath;
    if (path == null || path.isEmpty) return null;
    return File(path).existsSync() ? path : null;
  }

  Future<void> downloadSong(MusicModel music) async {
    final current = tasks[music.id];
    if (current?.status == 'downloading') return;

    final source = music.url.trim();
    _updateTask(
      DownloadTaskModel(
        songId: music.id,
        url: source,
        status: 'queued',
        progress: current?.progress ?? 0,
        localPath: current?.localPath,
      ),
    );

    if (source.startsWith('asset://')) {
      await _downloadFromAsset(music.id, source.replaceFirst('asset://', ''));
      return;
    }

    if (source.startsWith('http://') || source.startsWith('https://')) {
      await _downloadFromHttp(music.id, source);
      return;
    }

    _updateTask(
      DownloadTaskModel(
        songId: music.id,
        url: source,
        status: 'failed',
        progress: 0,
        error: 'URL không hỗ trợ tải: $source',
      ),
    );
  }

  Future<void> cancelDownload(String songId) async {
    await _activeSubscriptions.remove(songId)?.cancel();
    final current = tasks[songId];
    if (current?.localPath != null) {
      final file = File(current!.localPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }

    if (current != null) {
      _updateTask(current.copyWith(status: 'canceled', progress: 0, localPath: null));
    }
  }

  Future<void> _downloadFromAsset(String songId, String assetPath) async {
    try {
      _updateTask(tasks[songId]!.copyWith(status: 'downloading', progress: 5));

      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();

      final outFile = await _targetFile(songId, assetPath.split('/').last);
      await outFile.parent.create(recursive: true);
      await outFile.writeAsBytes(bytes, flush: true);

      _updateTask(
        tasks[songId]!.copyWith(
          status: 'completed',
          progress: 100,
          localPath: outFile.path,
          error: null,
        ),
      );
    } catch (e) {
      _updateTask(tasks[songId]!.copyWith(status: 'failed', error: e.toString()));
    }
  }

  Future<void> _downloadFromHttp(String songId, String url) async {
    HttpClient? client;
    IOSink? sink;

    try {
      _updateTask(tasks[songId]!.copyWith(status: 'downloading', progress: 0));

      client = HttpClient();
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final outFile = await _targetFile(songId, _extractFileName(url));
      await outFile.parent.create(recursive: true);
      sink = outFile.openWrite();

      final total = response.contentLength;
      var received = 0;

      final completer = Completer<void>();
      final subscription = response.listen(
            (chunk) {
          received += chunk.length;
          sink!.add(chunk);

          if (total > 0) {
            final progress = ((received / total) * 100).clamp(0, 100).toInt();
            _updateTask(tasks[songId]!.copyWith(progress: progress, localPath: outFile.path));
          }
        },
        onDone: () async {
          await sink!.flush();
          await sink.close();
          _activeSubscriptions.remove(songId);
          _updateTask(
            tasks[songId]!.copyWith(
              status: 'completed',
              progress: 100,
              localPath: outFile.path,
              error: null,
            ),
          );
          completer.complete();
        },
        onError: (e) async {
          await sink?.close();
          _activeSubscriptions.remove(songId);
          _updateTask(tasks[songId]!.copyWith(status: 'failed', error: e.toString()));
          completer.completeError(e);
        },
        cancelOnError: true,
      );

      _activeSubscriptions[songId] = subscription;
      await completer.future;
    } catch (e) {
      await sink?.close();
      _activeSubscriptions.remove(songId);
      _updateTask(tasks[songId]!.copyWith(status: 'failed', error: e.toString()));
    } finally {
      client?.close(force: true);
    }
  }

  Future<File> _targetFile(String songId, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    return File('${dir.path}/downloads/${songId}_$safeName');
  }

  String _extractFileName(String url) {
    final uri = Uri.parse(url);
    final name = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'audio.mp3';
    return name.isEmpty ? 'audio.mp3' : name;
  }

  void _updateTask(DownloadTaskModel task) {
    tasks[task.songId] = task;
    _persistTasks();
  }

  void _restoreTasks() {
    final raw = box.read(_storageKey);
    if (raw is Map) {
      for (final entry in raw.entries) {
        final value = entry.value;
        if (value is Map) {
          tasks[entry.key.toString()] = DownloadTaskModel.fromJson(
            Map<String, dynamic>.from(value),
          );
        }
      }
    }
  }

  void _persistTasks() {
    final data = <String, dynamic>{};
    tasks.forEach((key, value) {
      data[key] = value.toJson();
    });
    box.write(_storageKey, data);
  }
}
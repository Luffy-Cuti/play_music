import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import 'package:just_audio_background/just_audio_background.dart';
import '../../data/models/music_model.dart';
import '../download/download_manager_service.dart';
import '../download/download_task_model.dart';

class MusicDetailController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final DownloadManagerService downloadManager =
      Get.find<DownloadManagerService>();

  RxBool isPlaying = false.obs;
  RxBool isLoading = true.obs;
  RxString playbackMessage = ''.obs;
  Rx<Duration> position = Duration.zero.obs;
  Rx<Duration> duration = Duration.zero.obs;
  Rxn<DownloadTaskModel> downloadTask = Rxn<DownloadTaskModel>();

  late MusicModel music;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    music = Get.arguments as MusicModel;
    downloadTask.value = downloadManager.taskFor(music.id);

    ever<Map<String, DownloadTaskModel>>(downloadManager.tasks, (_) {
      downloadTask.value = downloadManager.taskFor(music.id);
    });

    saveToHistory();

    loadMusic();

    player.positionStream.listen((pos) {
      position.value = pos;
    });

    player.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
      }
    });

    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
    });
  }

  Future<void> loadMusic() async {
    isLoading.value = true;
    playbackMessage.value = '';
    try {
      final downloadedPath = downloadManager.localPathFor(music.id);
      if (downloadedPath != null && File(downloadedPath).existsSync()) {
        await player.setAudioSource(
          AudioSource.uri(Uri.file(downloadedPath), tag: _mediaItem),
        );
        playbackMessage.value = 'Đang phát từ bản tải offline';
        return;
      }
      final source = music.url.trim();

      if (source.startsWith('asset://')) {
        final assetPath = source.replaceFirst('asset://', '');
        await _setAssetWithFallback(assetPath);
      } else if (source.startsWith('file://')) {
        await player.setAudioSource(
          AudioSource.uri(
            Uri.file(source.replaceFirst('file://', '')),
            tag: _mediaItem,
          ),
        );
      } else if (source.startsWith('http://') ||
          source.startsWith('https://')) {
        await player.setAudioSource(
          AudioSource.uri(Uri.parse(source), tag: _mediaItem),
        );
      } else {
        await _setAssetWithFallback('assets/audio/Shape of you.mp3');
      }
    } catch (e) {
      debugPrint('LOAD ERROR for "${music.title}" (${music.url}): $e');
      playbackMessage.value =
          'Không phát được bài đã chọn. Đã chuyển sang bản dự phòng.';
      await _setAssetWithFallback('assets/audio/Shape of you.mp3');
    } finally {
      isLoading.value = false;
    }
  }

  MediaItem get _mediaItem => MediaItem(
    id: music.id,
    album: 'Play Music',
    title: music.title,
    artist: music.artist,
  );

  bool get isDownloading => downloadTask.value?.status == 'downloading';

  bool get isDownloaded => downloadTask.value?.status == 'completed';

  Future<void> startDownload() async {
    await downloadManager.downloadSong(music);
    if (downloadTask.value?.status == 'completed') {
      playbackMessage.value =
          'Tải xong, lần phát tiếp theo sẽ ưu tiên bản offline';
      await loadMusic();
    }
  }

  Future<void> cancelDownload() async {
    await downloadManager.cancelDownload(music.id);
  }

  Future<void> _setAssetWithFallback(String primaryAsset) async {
    final candidates = <String>[
      primaryAsset,
      'assets/audio/Shape of you.mp3',
      'assets/audio/See you again.mp3',
      'assets/audio/demo.mp3',
    ].toSet().toList();

    Object? lastError;

    for (final asset in candidates) {
      try {
        await player.setAudioSource(AudioSource.asset(asset, tag: _mediaItem));
        if (asset != primaryAsset) {
          playbackMessage.value = 'File gốc gặp lỗi, đang phát bản thay thế';
        }
        return;
      } catch (error) {
        lastError = error;
        debugPrint('ASSET LOAD FAIL: $asset -> $error');
      }
    }

    throw Exception('Không thể load bất kỳ file  $lastError');
  }

  void togglePlay() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  void seekTo(Duration newPosition) async {
    await player.seek(newPosition);
  }

  void saveToHistory() {
    final List<dynamic> history = box.read('history') ?? [];

    if (!history.contains(music.title)) {
      history.add(music.title);
      box.write('history', history);
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}

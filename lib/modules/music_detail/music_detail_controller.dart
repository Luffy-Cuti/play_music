import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import 'package:just_audio_background/just_audio_background.dart';
import '../../data/models/music_model.dart';
import '../../data/services/download_manager_service.dart';
import '../../data/models/download_task_model.dart';

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
  RxInt currentIndex = 0.obs;

  late MusicModel music;
  late List<MusicModel> queue;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    _setupQueueFromArguments();
    _syncDownloadTask();

    ever<Map<String, DownloadTaskModel>>(downloadManager.tasks, (_) {
      _syncDownloadTask();
    });

    saveToHistory();

    loadMusic();

    player.positionStream.listen((pos) {
      position.value = pos;
    });

    player.durationStream.listen((dur) {
      duration.value = dur ?? Duration.zero;
    });

    player.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  void _setupQueueFromArguments() {
    final args = Get.arguments;
    if (args is Map<String, dynamic> && args['music'] is MusicModel) {
      final queueArg = args['queue'];
      final indexArg = args['index'];
      queue = (queueArg is List<MusicModel> && queueArg.isNotEmpty)
          ? queueArg
          : <MusicModel>[args['music'] as MusicModel];

      if (indexArg is int && indexArg >= 0 && indexArg < queue.length) {
        currentIndex.value = indexArg;
      }

      music = queue[currentIndex.value];
      return;
    }

    music = args as MusicModel;
    queue = <MusicModel>[music];
  }

  void _syncDownloadTask() {
    downloadTask.value = downloadManager.taskFor(music.id);
  }

  Future<void> loadMusic() async {
    isLoading.value = true;
    playbackMessage.value = '';
    position.value = Duration.zero;
    duration.value = Duration.zero;
    try {
      final downloadedPath = downloadManager.localPathFor(music.id);
      if (downloadedPath != null && File(downloadedPath).existsSync()) {
        await player.setAudioSource(
          AudioSource.uri(Uri.file(downloadedPath), tag: _mediaItem),
        );
        playbackMessage.value = 'Đang phát từ bản tải offline';
      } else {
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
      }
      await player.play();
    } catch (e) {
      debugPrint('LOAD ERROR for "${music.title}" (${music.url}): $e');
      playbackMessage.value =
          'Không phát được bài đã chọn. Đã chuyển sang bản dự phòng.';
      await _setAssetWithFallback('assets/audio/Shape of you.mp3');
      await player.play();
    } finally {
      isLoading.value = false;
      _syncDownloadTask();
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

  bool get hasPrevious => currentIndex.value > 0;

  bool get hasNext => currentIndex.value < queue.length - 1;

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

  Future<void> togglePlay() async {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  Future<void> seekTo(Duration newPosition) async {
    await player.seek(newPosition);
  }
  Future<void> seekRelative(int seconds) async {
    final total = duration.value;
    final target = position.value + Duration(seconds: seconds);
    final min = Duration.zero;
    final max = total > Duration.zero ? total : target;
    if (target < min) {
      await seekTo(min);
      return;
    }
    if (target > max) {
      await seekTo(max);
      return;
    }
    await seekTo(target);
  }

  Future<void> playNext() async {
    if (!hasNext) {
      await player.seek(Duration.zero);
      await player.pause();
      return;
    }
    currentIndex.value += 1;
    music = queue[currentIndex.value];
    saveToHistory();
    await loadMusic();
  }

  Future<void> playPrevious() async {
    if (!hasPrevious) {
      await seekTo(Duration.zero);
      return;
    }
    currentIndex.value -= 1;
    music = queue[currentIndex.value];
    saveToHistory();
    await loadMusic();
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

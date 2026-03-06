import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/music_model.dart';

class MusicDetailController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  RxBool isPlaying = false.obs;
  Rx<Duration> position = Duration.zero.obs;
  Rx<Duration> duration = Duration.zero.obs;

  late MusicModel music;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    music = Get.arguments as MusicModel;
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
    try {
      final source = music.url.trim();

      if (source.startsWith('asset://')) {
        final assetPath = source.replaceFirst('asset://', '');
        await player.setAsset(assetPath);
      } else if (source.startsWith('file://')) {
        await player.setFilePath(source.replaceFirst('file://', ''));
      } else if (source.startsWith('http://') ||
          source.startsWith('https://')) {
        await player.setUrl(source);
      } else {
        await _loadDefaultTrack();
      }
    } catch (e) {
      debugPrint('LOAD ERROR for "${music.title}" (${music.url}): $e');
      await _loadDefaultTrack();
    }
  }
  Future<void> _loadDefaultTrack() async {
    await player.setAsset('assets/audio/demo.mp3');
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

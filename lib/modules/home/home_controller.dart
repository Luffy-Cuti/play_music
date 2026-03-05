import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/music_model.dart';

class HomeController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final isPreparingLocal = false.obs;
  final isLocalPlaying = false.obs;
  final localPlayError = RxnString();
  String? _localFilePath;

  var musicList = <MusicModel>[
    MusicModel(
      id: "1",
      title: "Shape of You",
      artist: "Ed Sheeran",
      image: "https://i.scdn.co/image/ab67616d0000b273...",
      url: "",
    ),
    MusicModel(
      id: "2",
      title: "See You Again",
      artist: "Wiz Khalifa",
      image:
          "https://cdn-media.sforum.vn/storage/app/media/thunguyen/hinh-nen-vui-ve-2.jpg",
      url: "",
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    player.playerStateStream.listen((state) {
      isLocalPlaying.value = state.playing;
    });
    _prepareLocalTrack();
  }

  Future<void> _prepareLocalTrack() async {
    isPreparingLocal.value = true;
    localPlayError.value = null;
    try {
      _localFilePath ??= await _cacheLocalAudioAsset();
      await player.setFilePath(_localFilePath!);
    } on PlayerException catch (e) {
      localPlayError.value = 'Không tải được nhạc local (${e.code})';
    } on PlayerInterruptedException {
      localPlayError.value = 'Quá trình tải nhạc local bị gián đoạn';
    } catch (_) {
      localPlayError.value = 'Có lỗi khi tải nhạc local';
    } finally {
      isPreparingLocal.value = false;
    }
  }

  Future<String> _cacheLocalAudioAsset() async {
    const assetPath = 'assets/audio/demo.mp3';
    final tempDir = await getTemporaryDirectory();
    final localFile = File('${tempDir.path}/demo_local.mp3');

    if (!await localFile.exists()) {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      if (bytes.isEmpty) {
        throw const FormatException('Asset audio rỗng');
      }
      await localFile.writeAsBytes(bytes, flush: true);
    }

    return localFile.path;
  }

  Future<void> playLocal() async {
    if (isPreparingLocal.value) return;

    if (localPlayError.value != null) {
      await _prepareLocalTrack();
      if (localPlayError.value != null) return;
    }

    try {
      if (player.playing) {
        await player.pause();
        return;
      }

      if (player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }

      await player.play();
    } on PlayerException catch (e) {
      localPlayError.value = 'Không phát được nhạc local (${e.code})';
    } on PlayerInterruptedException {
      localPlayError.value = 'Phát nhạc local bị gián đoạn';
    } catch (_) {
      localPlayError.value = 'Có lỗi khi phát nhạc local';
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
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

    music = Get.arguments;
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
      await player.setAsset('assets/audio/demo.mp3');
    } catch (e) {
      print("LOAD ERROR: $e");
    }
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
    List history = box.read("history") ?? [];

    if (!history.contains(music.title)) {
      history.add(music.title);
      box.write("history", history);
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/music_model.dart';

class MusicDetailController extends GetxController {

  late MusicModel music;

  var isPlaying = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    music = Get.arguments;
    saveToHistory();
    super.onInit();
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;
  }

  void saveToHistory() {
    List history = box.read("history") ?? [];

    if (!history.contains(music.title)) {
      history.add(music.title);
      box.write("history", history);
    }
  }
}
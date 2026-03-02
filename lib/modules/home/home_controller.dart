import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/music_model.dart';

class HomeController extends GetxController {
  final AudioPlayer player = AudioPlayer();

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
      image: "https://cdn-media.sforum.vn/storage/app/media/thunguyen/hinh-nen-vui-ve-2.jpg",
      url: "",
    ),
  ].obs;

  Future<void> playLocal() async {
    await player.setAsset('assets/audio/demo.mp3');
    await player.play();
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
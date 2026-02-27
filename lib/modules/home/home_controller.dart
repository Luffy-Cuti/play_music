import 'package:get/get.dart';
import '../../data/models/music_model.dart';

class HomeController extends GetxController {
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
      image: "",
      url: "",
    ),
  ].obs;
}

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/music_model.dart';

class HomeController extends GetxController {
  var musicList = <MusicModel>[
    MusicModel(
      id: "local_1",
      title: "Local Demo",
      artist: "On-device",
      image: "",
      url: "asset://assets/audio/demo.mp3",
    ),
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
}

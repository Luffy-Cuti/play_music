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
      id: 'local_2',
      title: 'Shape of You',
      artist: 'Ed Sheeran',
      image: '',
      url: 'asset://assets/audio/Shape of you.mp3',
    ),
    MusicModel(
      id: 'local_3',
      title: 'See You Again',
      artist: 'Wiz Khalifa',
      image: '',
      url: 'asset://assets/audio/See you again.mp3',
    ),
  ].obs;
}

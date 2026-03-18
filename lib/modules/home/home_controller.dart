import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/models/music_model.dart';
import '../../data/services/notification_service.dart';

class HomeController extends GetxController {
  final searchQuery = ''.obs;
  final fcmToken = ''.obs;
  final isFcmReady = false.obs;
  final musicList = <MusicModel>[
    MusicModel(
      id: 'local_1',
      title: 'Local Demo',
      artist: 'On-device',
      image: '',
      url: 'asset://assets/audio/demo.mp3',
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

  @override
  void onInit() {
    super.onInit();
    syncNotificationState();
  }

  List<MusicModel> get filteredMusicList {
    final keyword = searchQuery.value.trim().toLowerCase();
    if (keyword.isEmpty) {
      return musicList;
    }

    return musicList.where((music) {
      return music.title.toLowerCase().contains(keyword) ||
          music.artist.toLowerCase().contains(keyword);
    }).toList();
  }

  Future<void> syncNotificationState() async {
    final token =
        NotificationService.fcmToken ??
        await NotificationService.refreshFcmToken();
    fcmToken.value = token ?? '';
    isFcmReady.value = fcmToken.value.isNotEmpty;
  }

  Future<void> refreshFcmToken() async {
    await syncNotificationState();
    Get.snackbar(
      'Firebase Push',
      isFcmReady.value
          ? 'Đã cập nhật FCM token mới.'
          : 'Chưa lấy được token, kiểm tra quyền thông báo/Firebase config.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> sendNewSongTestNotification() async {
    final latestSong = musicList.first;
    await NotificationService.showNewSongTestNotification(
      songTitle: latestSong.title,
      artistName: latestSong.artist,
    );
    Get.snackbar(
      'Đã gửi notification test',
      'Mẫu thông báo bài hát mới đã được hiển thị trên máy.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'music_detail_controller.dart';

class MusicDetailPage extends StatelessWidget {
  final controller = Get.put(MusicDetailController());

  MusicDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.music.title)),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(controller.music.artist),
              SizedBox(height: 30),
              IconButton(
                iconSize: 80,
                icon: Icon(
                  controller.isPlaying.value
                      ? Icons.pause_circle
                      : Icons.play_circle,
                ),
                onPressed: controller.togglePlay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'music_detail_controller.dart';

class MusicDetailPage extends StatelessWidget {
  final controller = Get.put(MusicDetailController());

  MusicDetailPage({super.key});

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(controller.music.title),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  controller.music.image ??
                      "https://cdn-media.sforum.vn/storage/app/media/thunguyen/hinh-nen-vui-ve-2.jpg",
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              controller.music.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              controller.music.artist,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

            Slider(
              value: controller.position.value.inSeconds.toDouble(),
              max: controller.duration.value.inSeconds.toDouble() == 0
                  ? 1
                  : controller.duration.value.inSeconds.toDouble(),
              onChanged: (value) {
                controller.seekTo(Duration(seconds: value.toInt()));
              },
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDuration(controller.position.value),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    formatDuration(controller.duration.value),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            IconButton(
              iconSize: 90,
              color: Colors.green,
              icon: Icon(
                controller.isPlaying.value
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
              ),
              onPressed: controller.togglePlay,
            ),
          ],
        ),
      ),
    );
  }
}

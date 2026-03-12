import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'music_detail_controller.dart';
import '../../core/routes/app_pages.dart';

class MusicDetailPage extends GetView<MusicDetailController> {
  const MusicDetailPage({super.key});

  String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildArtwork() {
    final image = controller.music.image?.trim() ?? '';

    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        height: 250,
        width: 250,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackArtwork(),
      );
    }
    if (image.isNotEmpty) {
      return Image.asset(
        image,
        height: 250,
        width: 250,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackArtwork(),
      );
    }

    return _fallbackArtwork();
  }

  Widget _fallbackArtwork() {
    return Container(
      height: 250,
      width: 250,
      color: Colors.grey.shade900,
      alignment: Alignment.center,
      child: const Icon(Icons.music_note, color: Colors.green, size: 72),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Obx(() => Text(controller.music.title)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _buildArtwork(),
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
                const SizedBox(height: 16),

                OutlinedButton.icon(
                  onPressed: () {
                    final query = Uri.encodeComponent(
                      '${controller.music.title} ${controller.music.artist} lyrics',
                    );

                    Get.toNamed(
                      AppRoutes.WEBVIEW,
                      arguments: {
                        'title': 'Lyrics & Info',
                        'url': 'https://www.google.com/search?q=' + query,
                      },
                    );
                  },
                  icon: const Icon(Icons.library_music),
                  label: const Text('Lyrics & Info'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),

                if (controller.downloadTask.value != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: (controller.downloadTask.value!.progress / 100)
                              .clamp(0.0, 1.0),
                          color: Colors.green,
                          backgroundColor: Colors.white24,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Download: ${controller.downloadTask.value!.status} (${controller.downloadTask.value!.progress}%)',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: controller.isDownloading
                      ? null
                      : controller.isDownloading
                      ? controller.cancelDownload
                      : controller.startDownload,
                  icon: Icon(
                    controller.isDownloading
                        ? Icons.cancel
                        : controller.isDownloaded
                        ? Icons.check_circle
                        : Icons.download,
                  ),
                  label: Text(
                    controller.isDownloading
                        ? 'Hủy tải'
                        : controller.isDownloaded
                        ? 'Đã tải offline'
                        : 'Tải xuống offline',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
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

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: controller.hasPrevious
                          ? controller.playPrevious
                          : null,
                      icon: const Icon(Icons.skip_previous_rounded),
                      color: Colors.white,
                      iconSize: 40,
                    ),
                    IconButton(
                      onPressed: () => controller.seekRelative(-10),
                      icon: const Icon(Icons.replay_10_rounded),
                      color: Colors.white,
                      iconSize: 36,
                    ),
                    controller.isLoading.value
                        ? const SizedBox(
                            width: 90,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            ),
                          )
                        : IconButton(
                            iconSize: 90,
                            color: Colors.green,
                            icon: Icon(
                              controller.isPlaying.value
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                            ),
                            onPressed: controller.togglePlay,
                          ),
                    IconButton(
                      onPressed: () => controller.seekRelative(10),
                      icon: const Icon(Icons.forward_10_rounded),
                      color: Colors.white,
                      iconSize: 36,
                    ),
                    IconButton(
                      onPressed: controller.hasNext
                          ? controller.playNext
                          : null,
                      icon: const Icon(Icons.skip_next_rounded),
                      color: Colors.white,
                      iconSize: 40,
                    ),
                  ],
                ),

                if (controller.playbackMessage.value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      controller.playbackMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 13,
                      ),
                    ),
                  ),
                if (controller.playbackMessage.value.isNotEmpty)
                  const SizedBox(height: 12),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const Text(
                        'Tốc độ phát',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Slider(
                          value: controller.playbackSpeed.value,
                          min: 0.5,
                          max: 2.0,
                          divisions: 6,
                          label:
                              '${controller.playbackSpeed.value.toStringAsFixed(2)}x',
                          onChanged: (value) =>
                              controller.setPlaybackSpeed(value),
                          activeColor: Colors.green,
                          inactiveColor: Colors.grey,
                        ),
                      ),
                      Text(
                        '${controller.playbackSpeed.value.toStringAsFixed(2)}x',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

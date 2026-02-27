import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../core/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.SETTING),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.musicList.length,
          itemBuilder: (context, index) {
            final music = controller.musicList[index];
            return ListTile(
              title: Text(music.title),
              subtitle: Text(music.artist),
              onTap: () {
                Get.toNamed(AppRoutes.DETAIL, arguments: music);
              },
            );
          },
        ),
      ),
    );
  }
}

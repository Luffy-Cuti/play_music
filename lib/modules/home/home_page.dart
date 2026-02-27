import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../core/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                FirebaseAuth.instance.currentUser?.email ?? "",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
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

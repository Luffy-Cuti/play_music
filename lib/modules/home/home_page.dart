import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/notification_service.dart';
import 'home_controller.dart';
import '../../core/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());
  final user = FirebaseAuth.instance.currentUser;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,

        leadingWidth: 40,
        leading: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 22,
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Get.offAllNamed(AppRoutes.LOGIN);
          },
        ),

        title: Text('home'.tr, style: TextStyle(fontWeight: FontWeight.bold)),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.SETTING);
              },
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        user?.displayName ?? "",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(user?.email ?? "", style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null ? Icon(Icons.person) : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      FirebaseCrashlytics.instance.crash();
                    },
                    child: Text("Test Crash"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      NotificationService.showNotification();
                    },
                    child: Text("Test Notification"),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.musicList.length,
                  itemBuilder: (context, index) {
                    final music = controller.musicList[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.deepPurple.shade100,
                            child: Icon(
                              Icons.music_note,
                              color: Colors.deepPurple,
                            ),
                          ),
                          title: Text(
                            music.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(music.artist),
                          trailing: Icon(
                            Icons.play_circle_fill,
                            color: Colors.deepPurple,
                            size: 30,
                          ),
                          onTap: () {
                            Get.toNamed(AppRoutes.DETAIL, arguments: music);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

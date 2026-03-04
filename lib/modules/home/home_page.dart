import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/services/auth_controller.dart';
import '../../data/services/notification_service.dart';
import 'home_controller.dart';
import '../../core/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());
  final auth = Get.find<AuthController>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Discover",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Search music...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "New Album",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Happy Than Ever",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.music_note, color: Colors.white, size: 40),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Dev Tools",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        FirebaseCrashlytics.instance.crash();
                      },
                      child: const Text("Crash"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        NotificationService.showNotification();
                      },
                      child: const Text("Notify"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () async {
                  await controller.playLocal();
                },
                child: const Text("Play Local MP3"),
              ),

              const SizedBox(height: 25),

              const Text(
                "News",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),

              const SizedBox(height: 15),

              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.musicList.length,
                  itemBuilder: (context, index) {
                    final music = controller.musicList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.green,
                          ),
                        ),
                        title: Text(
                          music.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(music.artist),
                        trailing: const Icon(
                          Icons.play_arrow,
                          color: Colors.green,
                        ),
                        onTap: () {
                          Get.toNamed(AppRoutes.DETAIL, arguments: music);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Obx(() {
        final user = auth.user.value;

        return BottomNavigationBar(
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 2) {

              Get.toNamed(AppRoutes.SETTING);
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 14,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? const Icon(Icons.person, size: 16)
                    : null,
              ),
              label: "Profile",
            ),
          ],
        );
      }),
    );
  }
}

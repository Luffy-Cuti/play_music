import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_pages.dart';
import '../../data/services/auth_controller.dart';
import 'setting_controller.dart';
import 'package:get_storage/get_storage.dart';

class SettingPage extends StatelessWidget {
  final controller = Get.put(SettingController());
  final box = GetStorage();
  final auth = Get.find<AuthController>();

  SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> history = box.read("history") ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),

                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) async {
                            if (value == "logout") {
                              await auth.signOut();
                              Get.offAllNamed(AppRoutes.LOGIN);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "logout",
                              child: Row(
                                children: [
                                  Icon(Icons.logout, size: 20),
                                  SizedBox(width: 10),
                                  Text("Logout"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  CircleAvatar(
                    radius: 45,
                    backgroundImage: auth.user.value?.photoURL != null
                        ? NetworkImage(auth.user.value!.photoURL!)
                        : null,
                    child: auth.user.value?.photoURL == null
                        ? Icon(Icons.person)
                        : null,
                  ),

                  const SizedBox(height: 10),

                  Obx(() {
                    final user = auth.user.value;

                    return Column(
                      children: [
                        Text(
                          user?.displayName ?? "No Name",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user?.email ?? "",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Column(
                        children: [
                          Text(
                            "778",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Followers",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "243",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Following",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "HISTORY PLAYLISTS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "https://picsum.photos/200?random=$index",
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      history[index].toString(),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text("5:33"),
                    trailing: const Icon(Icons.more_horiz),
                  );
                },
              ),
            ),

            Obx(
              () => SwitchListTile(
                title: const Text("Vietnamese"),
                value: controller.isVietnamese.value,
                onChanged: (v) => controller.changeLanguage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

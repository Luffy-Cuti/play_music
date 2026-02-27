import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../core/routes/app_pages.dart';

class HomePage extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Play Music"),
            Text(
              user?.email ?? "",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.toNamed(AppRoutes.SETTING);
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          ListTile(
            title: Text("Bài hát 1"),
            onTap: () => Get.toNamed(AppRoutes.DETAIL),
          ),
          ListTile(
            title: Text("Bài hát 2"),
            onTap: () => Get.toNamed(AppRoutes.DETAIL),
          ),
        ],
      ),
    );
  }
}
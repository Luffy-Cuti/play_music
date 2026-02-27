import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return CircularProgressIndicator();
          }

          return ElevatedButton(
            onPressed: controller.signInWithGoogle,
            child: Text("Login with Google"),
          );
        }),
      ),
    );
  }
}
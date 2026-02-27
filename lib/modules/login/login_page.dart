import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_pages.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.offAllNamed(AppRoutes.HOME);
          },
          child: Text("Login with Google"),
        ),
      ),
    );
  }
}

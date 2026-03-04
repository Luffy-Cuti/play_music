import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_controller.dart';
import '../../modules/home/home_page.dart';
import '../../modules/login/login_page.dart';


class RootPage extends StatelessWidget {
  RootPage({super.key});

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {


      return authController.user.value == null
          ? LoginPage()
          : HomePage();
    });
  }
}
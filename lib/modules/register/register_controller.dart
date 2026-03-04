import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_pages.dart';

class RegisterController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  Future<void> register() async {
    try {
      isLoading.value = true;

      final credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );


      await credential.user!
          .updateDisplayName(fullNameController.text.trim());

      await credential.user!.reload();

      Get.snackbar("Success", "Account created successfully 🎉");

      Get.offAllNamed(AppRoutes.HOME);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } finally {
      isLoading.value = false;
    }
  }
}
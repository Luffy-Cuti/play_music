import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_msuci/core/routes/app_pages.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        const Icon(
                          Icons.music_note,
                          color: Colors.green,
                          size: 70,
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 40),

                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter Username or Email",
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Recovery Password",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Text("Or", style: TextStyle(color: Colors.grey)),

                        const SizedBox(height: 25),


                        //GG
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: Image.asset(
                              'assets/icon/google.png',
                              height: 15,
                            ),
                            label: const Text(
                              "Continue with Google",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: controller.signInWithGoogle,
                          ),
                        ),

                        const SizedBox(height: 15),
                        //Apple
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            icon: const Icon(Icons.apple, color: Colors.white),
                            label: const Text(
                              "Continue with Apple",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        ),

                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Not a Member?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.REGISTER);
                              },
                              child: const Text(
                                "Register Now",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

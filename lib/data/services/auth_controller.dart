import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:play_msuci/core/routes/app_pages.dart';

class AuthController extends GetxController {
  final user = Rxn<User>();

  @override
  void onInit() {
    user.bindStream(FirebaseAuth.instance.authStateChanges());
    super.onInit();
  }

  Future<void> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed(AppRoutes.HOME);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Lỗi", e.message ?? "Đăng nhập thất bại");
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

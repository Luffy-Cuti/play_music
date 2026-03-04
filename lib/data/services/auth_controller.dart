import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:play_msuci/data/services/root_page.dart';

class AuthController extends GetxController {
  var user = Rxn<User>();

  @override
  void onInit() {
    user.bindStream(FirebaseAuth.instance.authStateChanges());
    super.onInit();
  }

  Future<void> signIn(String email, String password) async {
    try {
      final credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => RootPage());



    } on FirebaseAuthException catch (e) {
      print("LOGIN ERROR: ${e.message}");
      Get.snackbar("Lỗi", e.message ?? "Đăng nhập thất bại");
    }
  }
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

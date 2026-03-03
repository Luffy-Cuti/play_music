import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController extends GetxController {
  var user = Rxn<User>();

  @override
  void onInit() {
    user.value = FirebaseAuth.instance.currentUser;
    super.onInit();
  }
}
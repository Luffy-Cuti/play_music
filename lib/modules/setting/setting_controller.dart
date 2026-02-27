import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingController extends GetxController {
  var isVietnamese = true.obs;

  void changeLanguage() {
    if (Get.locale?.languageCode == 'vi') {
      Get.updateLocale(Locale('en', 'US'));
    } else {
      Get.updateLocale(Locale('vi', 'VN'));
    }
  }
}

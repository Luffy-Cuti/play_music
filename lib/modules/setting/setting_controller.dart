import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingController extends GetxController {
  var isVietnamese = true.obs;

  void changeLanguage() {
    if (Get.locale?.languageCode == 'vi') {
      isVietnamese.value = false;
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      isVietnamese.value = true;
      Get.updateLocale(const Locale('vi', 'VN'));
    }
  }
}

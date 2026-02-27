import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'vi': {
      'home': 'Trang chủ',
      'setting': 'Cài đặt',
      'change_language': 'Đổi ngôn ngữ',
      'history' : 'lịch sử',
    },
    'en': {
      'home': 'Home',
      'setting': 'Setting',
      'change_language': 'Change language',
      'history' : 'history',
    },
  };
}
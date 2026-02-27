import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'vi_VN': {
      'home': 'Trang chủ',
      'setting': 'Cài đặt',
      'history': 'Lịch sử nghe',
    },
    'en_US': {'home': 'Home', 'setting': 'Setting', 'history': 'History'},
  };
}

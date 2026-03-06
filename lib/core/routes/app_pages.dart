import 'package:get/get.dart';
import 'package:play_msuci/modules/register/register_page.dart';
import '../../modules/login/login_page.dart';
import '../../modules/home/home_page.dart';
import '../../modules/music_detail/music_detail_controller.dart';
import '../../modules/music_detail/music_detail_page.dart';
import '../../modules/setting/setting_page.dart';

class AppRoutes {
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const DETAIL = '/detail';
  static const SETTING = '/setting';
  static const REGISTER = '/register';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.LOGIN, page: () => LoginPage()),
    GetPage(name: AppRoutes.HOME, page: () => HomePage()),
    GetPage(
      name: AppRoutes.DETAIL,
      page: () => MusicDetailPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<MusicDetailController>(() => MusicDetailController());
      }),
    ),
    GetPage(name: AppRoutes.SETTING, page: () => SettingPage()),
    GetPage(name: AppRoutes.REGISTER, page: () => RegisterPage()),
  ];
}

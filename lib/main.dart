import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/localization/app_translation.dart';
import 'core/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.LOGIN,
      getPages: AppPages.pages,
      translations: AppTranslation(),
      locale: Locale('vi', 'VN'),
      fallbackLocale: Locale('en', 'US'),
    );
  }
}

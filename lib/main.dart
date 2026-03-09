import 'dart:ui';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:play_msuci/data/services/root_page.dart';
import 'core/localization/app_translation.dart';
import 'core/routes/app_pages.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'data/services/auth_controller.dart';
import 'data/services/notification_service.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.play_music.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await NotificationService.init();
  Get.put(AuthController());
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(),
      getPages: AppPages.pages,
      translations: AppTranslation(),
      locale: const Locale('vi'),
      fallbackLocale: const Locale('en'),

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(centerTitle: true, elevation: 0),
      ),
    );
  }
}

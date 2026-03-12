import 'dart:ui';
import 'package:flutter/rendering.dart';
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

import 'data/services/download_manager_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? startupError;
  debugPaintSizeEnabled = false;

  try {
    await Firebase.initializeApp();
    await GetStorage.init();
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.example.play_music.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
    await NotificationService.init();
    Get.put(AuthController());
    Get.put(DownloadManagerService(), permanent: true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (e) {
    startupError = e;
  }

  runApp(MyApp(startupError: startupError));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.startupError});

  final Object? startupError;

  @override
  Widget build(BuildContext context) {
    if (startupError != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: const Text('Startup error')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              'Ứng dụng không khởi động được.\n\nChi tiết lỗi:\n$startupError',
            ),
          ),
        ),
      );
    }
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
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
    );
  }
}

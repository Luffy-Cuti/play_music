import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:play_msuci/data/services/root_page.dart';
import 'package:provider/provider.dart';
import 'core/localization/app_translation.dart';
import 'core/routes/app_pages.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'data/services/auth_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'data/services/notification_service.dart';
import 'data/services/remote_config_service.dart';

import 'package:just_audio_background/just_audio_background.dart';
import 'core/state/app_state.dart';
import 'data/services/download_manager_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? startupError;
  debugPaintSizeEnabled = false;

  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await GetStorage.init();
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.example.play_music.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
    await NotificationService.init();
    await RemoteConfigService.init();
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

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MyApp(startupError: startupError),
    ),
  );
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
    return Consumer<AppState>(
      builder: (context, appState, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NotificationService.flushPendingNavigation();
        });
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: RootPage(),
          getPages: AppPages.pages,
          translations: AppTranslation(),
          locale: const Locale('vi'),
          fallbackLocale: const Locale('en'),
          themeMode: appState.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
          ),
        );
      },
    );
  }
}

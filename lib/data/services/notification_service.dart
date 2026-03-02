import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    print("🔥 Notification init START");

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
    );

    await _notifications.initialize(settings);

    if (Platform.isAndroid) {
      var status = await Permission.notification.request();
      print("Notification permission status: $status");
    }

    print(" Notification init DONE");
  }

  static Future<void> showNotification() async {
    print(" showNotification() CALLED");

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'music_channel',
            'Music Notification',
            importance: Importance.max,
            priority: Priority.high,
          );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
      );

      await _notifications.show(
        0,
        '🎵 Music App',
        'Bạn vừa mở bài hát!',
        details,
      );

      print(" Notification shown successfully");
    } catch (e) {
      print(" ERROR showing notification: $e");
    }
  }
}

import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService._();

  static const String musicChannelId = 'music_channel';
  static const String newMusicTopic = 'new_music_updates';

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        musicChannelId,
        'Music Notification',
        description: 'Thông báo bài hát mới và cập nhật từ ứng dụng nhạc',
        importance: Importance.max,
      );

  static String? _fcmToken;

  static String? get fcmToken => _fcmToken;

  static Future<void> init() async {
    await _initLocalNotifications();
    await _requestPermissions();
    await initializeFirebaseMessaging();
  }

  static Future<void> _initLocalNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _notifications.initialize(settings);
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  static Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await Permission.notification.request();
    }

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  static Future<void> initializeFirebaseMessaging() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    await _refreshToken();
    await _messaging.subscribeToTopic(newMusicTopic);

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);
    _messaging.onTokenRefresh.listen((token) {
      _fcmToken = token;
      debugPrint('FCM token refreshed: $token');
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpen(initialMessage);
    }
  }

  static Future<String?> refreshFcmToken() async {
    await _refreshToken(forceRefresh: true);
    return _fcmToken;
  }

  static Future<void> _refreshToken({bool forceRefresh = false}) async {
    _fcmToken = forceRefresh
        ? await _messaging.getToken()
        : (_fcmToken ?? await _messaging.getToken());
    debugPrint('FCM token: $_fcmToken');
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final data = message.data;
    final title =
        message.notification?.title ?? data['title'] ?? '🎵 Có bài hát mới';
    final body =
        message.notification?.body ??
        data['body'] ??
        'Mở app để nghe bản phát hành mới nhất.';

    await _showLocalNotification(title: '$title', body: '$body');
  }

  static void _handleNotificationOpen(RemoteMessage message) {
    debugPrint('Notification tapped with payload: ${message.data}');
  }

  static Future<void> showNowPlayingNotification() async {
    await _showLocalNotification(
      title: '🎵 Music App',
      body: 'Bạn vừa mở bài hát!',
    );
  }

  static Future<void> showNewSongTestNotification({
    String songTitle = 'Shape of You',
    String artistName = 'Ed Sheeran',
  }) async {
    await _showLocalNotification(
      title: '🎧 Có bài hát mới',
      body: '$songTitle - $artistName vừa được thêm vào thư viện.',
      payload: 'type=new_song&song=$songTitle&artist=$artistName',
    );
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      musicChannelId,
      'Music Notification',
      channelDescription: 'Thông báo bài hát mới và cập nhật từ ứng dụng nhạc',
      importance: Importance.max,
      priority: Priority.high,
    );
    const darwinDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}

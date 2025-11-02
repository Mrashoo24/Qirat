import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _fcm = FirebaseMessaging.instance;
  static final _local = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (kIsWeb) {
      await _fcm.requestPermission();
      await _fcm.getToken(vapidKey: null);
    } else {
      await _fcm.requestPermission();
      await _local.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ));
    }

    FirebaseMessaging.onMessage.listen((msg) async {
      final title = msg.notification?.title ?? 'Qirat';
      final body = msg.notification?.body ?? '';
      await _local.show(
        0,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails('qirat', 'Qirat',
              importance: Importance.high, priority: Priority.high),
          iOS: DarwinNotificationDetails(
              presentAlert: true, presentBadge: true, presentSound: true),
        ),
      );
    });
  }
}

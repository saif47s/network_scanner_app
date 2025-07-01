import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings);
  }

  static Future<void> showNewDeviceNotification(String deviceNameOrIp) async {
    const androidDetails = AndroidNotificationDetails(
      'new_device_channel',
      'New Device Alerts',
      channelDescription: 'Notifications when a new device is found',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notifications.show(
      0,
      'New Device Found',
      deviceNameOrIp,
      details,
    );
  }
}

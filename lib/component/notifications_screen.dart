// NotificationService class (add permission request for iOS if necessary)

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({required String title, required String body}) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'your_channel_id', // replace with a valid channel id
        'your_channel_name',
        channelDescription: 'Your channel description',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}

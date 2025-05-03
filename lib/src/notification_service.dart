import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_10y.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  // initialize notification
  static void init() async {
    initializeTimeZones();

    AndroidInitializationSettings androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");

    DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    bool? initialized = await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        log(response.payload.toString());
      },
    );

    log("Notifications: $initialized");
  }

  //     DateTime scheduleDate = DateTime.now().add(Duration(seconds: 5));

  static AndroidNotificationDetails androidDetails = AndroidNotificationDetails("notifications-youtube", "YouTube Notifications", priority: Priority.max, importance: Importance.max);

  static DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static NotificationDetails notiDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

  static void showNotification({
    required int id,
    required DateTime scheduleDate,
    required String title,
    required String body,
    String payload = "default-payload",
  }) async {
    if (scheduleDate.isBefore(DateTime.now())) {
      log("Cannot schedule notification in the past.");
      return;
    }

    try {
      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        notiDetails,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      log("Notification scheduled: $title at $scheduleDate");
    } catch (e) {
      log("Failed to schedule notification: $e");
    }
  }

  void checkForNotification() async {
    NotificationAppLaunchDetails? details = await notificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? response = details.notificationResponse;

        if (response != null) {
          String? payload = response.payload;
          log("Notification Payload: $payload");
        }
      }
    }
  }
}

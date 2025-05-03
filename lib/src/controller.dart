import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'model.dart';
import 'notification_db_halper.dart';

class NotificationController extends GetxController {
  // Observable list of notifications
  var notifications = <NotificationModel>[].obs;

  // Initialize the notifications plugin (in case you need to later)
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    loadNotifications(); // Load notifications from DB when controller initializes
  }

  // Load notifications from DB and set them in the observable list
  Future<void> loadNotifications() async {
    List<NotificationModel> storedNotifications = await NotificationDB.getNotifications();
    notifications.assignAll(storedNotifications); // Update the observable list
  }

  // Add new notification to DB and show it
  Future<void> addNotification(String title, String body, DateTime scheduleDate) async {
    NotificationModel newNotification = NotificationModel(
      title: title,
      body: body,
      scheduleDate: scheduleDate,
    );

    // Insert into DB
    await NotificationDB.insertNotification(newNotification);

    // Add to the observable list
    notifications.add(newNotification);

    // Show the notification
    await _scheduleNotification(newNotification);
  }

  // Reschedule a notification (update the schedule date)
  Future<void> rescheduleNotification(int id, String title, String body, DateTime newScheduleDate) async {
    // Find the notification and update it
    NotificationModel updatedNotification = NotificationModel(
      id: id,
      title: title,
      body: body,
      scheduleDate: newScheduleDate,
    );

    // Update in DB
    await NotificationDB.updateNotification(updatedNotification);

    // Update in observable list
    var index = notifications.indexWhere((element) => element.id == id);
    if (index != -1) {
      notifications[index] = updatedNotification;
    }

    // Reschedule the notification
    await _scheduleNotification(updatedNotification);
  }

  // Remove notification from DB and cancel it
  Future<void> removeNotification(int id) async {
    // Delete from DB
    await NotificationDB.deleteNotification(id);

    // Remove from observable list
    notifications.removeWhere((element) => element.id == id);

    // Cancel the notification
    await notificationsPlugin.cancel(id);
  }

  static AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    "notifications-youtube",
    "YouTube Notifications",
    priority: Priority.max,
    importance: Importance.max,
  );

  static DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // Helper function to schedule a notification
  Future<void> _scheduleNotification(NotificationModel notification) async {
    await notificationsPlugin.zonedSchedule(
      notification.id ?? 0,
      notification.title,
      notification.body,
      tz.TZDateTime.from(notification.scheduleDate, tz.local),
      NotificationDetails(android: androidDetails),
      payload: "notification-payload",
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}

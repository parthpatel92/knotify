import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scheduled Notifications"),
      ),
      body: Obx(
        () {
          if (controller.notifications.isEmpty) {
            return Center(child: Text("No notifications scheduled."));
          }

          return ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              var notification = controller.notifications[index];

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                  trailing: Text(
                    "${notification.scheduleDate.hour}:${notification.scheduleDate.minute}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => _showRescheduleDialog(context, notification),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNotificationDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  // Show dialog to add a new notification
  Future<void> _showAddNotificationDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController bodyController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(Duration(minutes: 30));

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Notification"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: "Body"),
              ),
              // Date picker
              ListTile(
                title: Text("Schedule Date: ${selectedDate.hour}:${selectedDate.minute}"),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2101),
                  ).then((date) {
                    if (date != null) {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      ).then((time) {
                        if (time != null) {
                          selectedDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        }
                      });
                    }
                    return null;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Add the new notification
                controller.addNotification(
                  titleController.text,
                  bodyController.text,
                  selectedDate,
                );
                Get.back();
              },
              child: Text("Add Notification"),
            ),
          ],
        );
      },
    );
  }

  // Show dialog to reschedule a notification
  Future<void> _showRescheduleDialog(BuildContext context, NotificationModel notification) async {
    TextEditingController titleController = TextEditingController(text: notification.title);
    TextEditingController bodyController = TextEditingController(text: notification.body);
    DateTime selectedDate = notification.scheduleDate;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reschedule Notification"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: "Body"),
              ),
              // Date picker
              ListTile(
                title: Text("Schedule Date: ${selectedDate.hour}:${selectedDate.minute}"),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2101),
                  ).then((date) {
                    if (date != null) {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      ).then((time) {
                        if (time != null) {
                          selectedDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        }
                      });
                    }
                    return null;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Reschedule the notification
                controller.rescheduleNotification(
                  notification.id!,
                  titleController.text,
                  bodyController.text,
                  selectedDate,
                );
                Get.back();
              },
              child: Text("Reschedule"),
            ),
          ],
        );
      },
    );
  }
}

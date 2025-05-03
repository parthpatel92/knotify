import 'package:flutter/material.dart';
import 'package:knotify/src/notification_service.dart';
import 'package:knotify/src/permission_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    NotificationService().checkForNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            FlutterLogo(),
            SizedBox(width: 8),
            Text('knotify'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          )
        ],
      ),
      body: Column(),
      bottomSheet: ValueListenableBuilder<bool>(
          valueListenable: PermissionManager.instance.isGranted,
          builder: (context, value, child) {
            if (value) {
              return SizedBox.shrink();
            }
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Permission Not Allowed Yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 8),
                  TextButton(
                    onPressed: () async {
                      await PermissionManager.instance.requestNotificationPermission();
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Allow',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

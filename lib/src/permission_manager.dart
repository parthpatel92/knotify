import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static final PermissionManager _instance = PermissionManager._internal();
  PermissionManager._internal() {
    checkNotificationPermission();
  }
  static PermissionManager get instance => _instance;

  ValueNotifier<bool> isGranted = ValueNotifier(false);

  Future<bool> checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    isGranted.value = status.isGranted;
    return status.isGranted;
  }

  Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    isGranted.value = status.isGranted;

    if (!status.isGranted) {
      status = await Permission.notification.request();
      isGranted.value = status.isGranted;
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isDenied) {
        isGranted.value = false;
      }
    }
  }
}

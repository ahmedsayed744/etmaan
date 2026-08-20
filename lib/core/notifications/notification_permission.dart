import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification_service.dart';

class NotificationPermission {
  NotificationPermission._();

  static Future<bool> isGranted() async {
    try {
      final plugin = NotificationService.instance.plugin;

      final androidPlugin = plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final granted =
            await androidPlugin.areNotificationsEnabled();
        return granted ?? false;
      }

      final iosPlugin = plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        final granted = await iosPlugin.checkPermissions();
        return granted?.isEnabled ?? false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> request() async {
    try {
      if (await isGranted()) {
        return true;
      }

      final plugin = NotificationService.instance.plugin;

      final androidPlugin = plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final granted =
            await androidPlugin.requestNotificationsPermission();
        return granted ?? false;
      }

      final iosPlugin = plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        final granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}

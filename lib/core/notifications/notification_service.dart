import 'dart:async';

import 'package:etmaan/features/prayer/data/models/prayer_time_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_channels.dart';
import 'notification_defaults.dart';
import 'notification_ids.dart';
import 'notification_payload.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  final StreamController<NotificationResponse> _tapController =
      StreamController<NotificationResponse>.broadcast();

  bool _initialized = false;
  bool _channelsCreated = false;

  FlutterLocalNotificationsPlugin get plugin => _plugin;

  Stream<NotificationResponse> get onNotificationTap => _tapController.stream;

  Future<bool> initialize() async {
    if (_initialized) {
      return true;
    }

    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/launcher_icon',
      );

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final initialized = await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            _onBackgroundNotificationResponse,
      );

      if (initialized != true) {
        return false;
      }

      await _createChannels();

      _initialized = true;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _createChannels() async {
    if (_channelsCreated) {
      return;
    }

    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin == null) {
        return;
      }

      for (final channel in NotificationChannels.androidChannels) {
        await androidPlugin.createNotificationChannel(channel);
      }

      _channelsCreated = true;
    } catch (_) {
      // Keep app functional if channel creation fails.
    }
  }

  Future<void> _requestExactAlarmsIfNeeded() async {
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.requestExactAlarmsPermission();
    } catch (_) {
      // Prayer notifications can still be scheduled inexactly.
    }
  }

  void _onNotificationResponse(NotificationResponse response) {
    _tapController.add(response);
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationResponse(NotificationResponse response) {
    // Navigation is handled when the app resumes.
  }

  Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    String? payload,
  }) async {
    try {
      await _createChannels();

      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _detailsForChannel(channelId),
        payload: payload,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String channelId,
    String? payload,
  }) async {
    try {
      await _createChannels();

      final scheduledDate = _nextInstanceOfTime(hour, minute);

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _detailsForChannel(channelId),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> scheduleWeeklyFridayNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    required String channelId,
    String? payload,
  }) async {
    try {
      await _createChannels();

      final scheduledDate = _nextInstanceOfFriday(hour, minute);

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _detailsForChannel(channelId),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: payload,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> scheduleMotivationalNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) {
    return scheduleDailyNotification(
      id: NotificationIds.motivational,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
      channelId: NotificationChannels.motivationalId,
      payload: NotificationPayload.motivational,
    );
  }

  Future<bool> scheduleNotificationAt({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required String channelId,
    String? payload,
  }) async {
    try {
      await _createChannels();

      if (!scheduledTime.isAfter(DateTime.now())) {
        return false;
      }

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails: _detailsForChannel(channelId),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cancelDailyContentNotifications() async {
    try {
      await cancelNotification(NotificationIds.motivational);

      final ids = NotificationIds.dailyContentIdsFor(
        NotificationDefaults.dailyContentSlots.length,
      );
      for (final id in ids) {
        await cancelNotification(id);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> showMotivationalNotification({
    required String title,
    required String body,
  }) {
    return showNotification(
      id: NotificationIds.motivational,
      title: title,
      body: body,
      channelId: NotificationChannels.motivationalId,
      payload: NotificationPayload.motivational,
    );
  }

  // Schedule prayer notification with Adhan sound
  Future<bool> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    try {
      await _createChannels();
      await _requestExactAlarmsIfNeeded();

      var targetTime = scheduledTime;

      if (targetTime.isBefore(DateTime.now())) {
        targetTime = targetTime.add(const Duration(days: 1));
      }

      final tzScheduledTime = tz.TZDateTime.from(targetTime, tz.local);
      final details = _detailsForChannel(NotificationChannels.prayerAdhanId);

      // Schedule prayer notification with Adhan sound
      try {
        await _plugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzScheduledTime,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
      } catch (_) {
        await _plugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzScheduledTime,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
        );
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> schedulePrayerNotifications(
    List<PrayerTimeModel> prayerTimes,
  ) async {
    try {
      var success = true;

      for (final prayer in prayerTimes) {
        if (prayer.type == PrayerType.sunrise) {
          continue;
        }

        final id = _idForPrayerType(prayer.type);
        if (id == null) {
          continue;
        }

        final scheduled = await schedulePrayerNotification(
          id: id,
          title: 'حان وقت ${prayer.name}',
          body: 'حان الآن موعد صلاة ${prayer.name}',
          scheduledTime: prayer.time,
          payload: NotificationPayload.forPrayer(prayer.name),
        );

        success = success && scheduled;
      }

      return success;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id: id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cancelPrayerNotifications() async {
    try {
      await cancelNotification(NotificationIds.fajr);
      await cancelNotification(NotificationIds.dhuhr);
      await cancelNotification(NotificationIds.asr);
      await cancelNotification(NotificationIds.maghrib);
      await cancelNotification(NotificationIds.isha);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
      return true;
    } catch (_) {
      return false;
    }
  }

  NotificationDetails _detailsForChannel(String channelId) {
    final isPrayerAdhan = channelId == NotificationChannels.prayerAdhanId;

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        _channelNameForId(channelId),
        channelDescription: _channelDescriptionForId(channelId),
        importance: channelId == NotificationChannels.motivationalId
            ? Importance.defaultImportance
            : isPrayerAdhan
            ? Importance.max
            : Importance.high,
        priority: channelId == NotificationChannels.motivationalId
            ? Priority.defaultPriority
            : isPrayerAdhan
            ? Priority.max
            : Priority.high,
        playSound: channelId != NotificationChannels.generalId,
        sound: isPrayerAdhan
            ? const RawResourceAndroidNotificationSound('adhan')
            : null,
        category: isPrayerAdhan ? AndroidNotificationCategory.alarm : null,
        audioAttributesUsage: isPrayerAdhan
            ? AudioAttributesUsage.alarm
            : AudioAttributesUsage.notification,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  String _channelNameForId(String channelId) {
    switch (channelId) {
      case NotificationChannels.prayerId:
        return NotificationChannels.prayerName;
      case NotificationChannels.prayerAdhanId:
        return NotificationChannels.prayerAdhanName;
      case NotificationChannels.azkarId:
        return NotificationChannels.azkarName;
      case NotificationChannels.quranId:
        return NotificationChannels.quranName;
      case NotificationChannels.motivationalId:
        return NotificationChannels.motivationalName;
      default:
        return NotificationChannels.generalName;
    }
  }

  String _channelDescriptionForId(String channelId) {
    switch (channelId) {
      case NotificationChannels.prayerId:
        return NotificationChannels.prayerDescription;
      case NotificationChannels.prayerAdhanId:
        return NotificationChannels.prayerAdhanDescription;
      case NotificationChannels.azkarId:
        return NotificationChannels.azkarDescription;
      case NotificationChannels.quranId:
        return NotificationChannels.quranDescription;
      case NotificationChannels.motivationalId:
        return NotificationChannels.motivationalDescription;
      default:
        return NotificationChannels.generalDescription;
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfFriday(int hour, int minute) {
    var scheduledDate = _nextInstanceOfTime(hour, minute);

    while (scheduledDate.weekday != DateTime.friday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  int? _idForPrayerType(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return NotificationIds.fajr;
      case PrayerType.dhuhr:
        return NotificationIds.dhuhr;
      case PrayerType.asr:
        return NotificationIds.asr;
      case PrayerType.maghrib:
        return NotificationIds.maghrib;
      case PrayerType.isha:
        return NotificationIds.isha;
      case PrayerType.sunrise:
        return null;
    }
  }
}

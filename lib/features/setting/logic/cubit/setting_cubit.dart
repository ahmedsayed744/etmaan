import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'package:etmaan/core/notifications/daily_notification_scheduler.dart';
import 'package:etmaan/core/notifications/notification_channels.dart';
import 'package:etmaan/core/notifications/notification_defaults.dart';
import 'package:etmaan/core/notifications/notification_ids.dart';
import 'package:etmaan/core/notifications/notification_payload.dart';
import 'package:etmaan/core/notifications/notification_permission.dart';
import 'package:etmaan/core/notifications/notification_service.dart';
import 'package:etmaan/features/prayer/data/models/prayer_time_model.dart';
import 'package:etmaan/features/prayer/data/repo/prayer_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  final NotificationService _notificationService;
  final PrayerRepo? _prayerRepo;

  SettingCubit({
    NotificationService? notificationService,
    PrayerRepo? prayerRepo,
  })  : _notificationService =
            notificationService ?? NotificationService.instance,
        _prayerRepo = prayerRepo,
        super(const SettingState()) {
    _loadSettings();
  }

  void _loadSettings() {
    final cache = CacheHelper();

    emit(
      SettingState(
        quranReminderEnabled:
            _readBool(cache, CacheKeys.quranReminderEnabled),
        morningAzkarEnabled:
            _readBool(cache, CacheKeys.morningAzkarEnabled),
        eveningAzkarEnabled:
            _readBool(cache, CacheKeys.eveningAzkarEnabled),
        fridayReminderEnabled:
            _readBool(cache, CacheKeys.fridayReminderEnabled),
        motivationalEnabled:
            _readBool(cache, CacheKeys.motivationalEnabled),
        prayerNotificationsEnabled:
            _readBool(cache, CacheKeys.prayerNotificationsEnabled),
      ),
    );

    _rescheduleEnabledNotifications();
  }

  Future<void> setQuranReminder(bool enabled) async {
    if (!enabled) {
      await _disable(
        cacheKey: CacheKeys.quranReminderEnabled,
        notificationId: NotificationIds.quranReminder,
        updateState: (state) =>
            state.copyWith(quranReminderEnabled: false),
      );
      return;
    }

    final granted = await NotificationPermission.request();
    if (!granted) {
      emit(state.copyWith(quranReminderEnabled: false));
      return;
    }

    await CacheHelper().saveData(
      key: CacheKeys.quranReminderEnabled,
      value: true,
    );
    emit(state.copyWith(quranReminderEnabled: true));
    await _scheduleQuranReminder();
  }

  Future<void> setMorningAzkar(bool enabled) async {
    if (!enabled) {
      await _disable(
        cacheKey: CacheKeys.morningAzkarEnabled,
        notificationId: NotificationIds.morningAzkar,
        updateState: (state) =>
            state.copyWith(morningAzkarEnabled: false),
      );
      return;
    }

    final granted = await NotificationPermission.request();
    if (!granted) {
      emit(state.copyWith(morningAzkarEnabled: false));
      return;
    }

    await CacheHelper().saveData(
      key: CacheKeys.morningAzkarEnabled,
      value: true,
    );
    emit(state.copyWith(morningAzkarEnabled: true));
    await _scheduleMorningAzkar();
  }

  Future<void> setEveningAzkar(bool enabled) async {
    if (!enabled) {
      await _disable(
        cacheKey: CacheKeys.eveningAzkarEnabled,
        notificationId: NotificationIds.eveningAzkar,
        updateState: (state) =>
            state.copyWith(eveningAzkarEnabled: false),
      );
      return;
    }

    final granted = await NotificationPermission.request();
    if (!granted) {
      emit(state.copyWith(eveningAzkarEnabled: false));
      return;
    }

    await CacheHelper().saveData(
      key: CacheKeys.eveningAzkarEnabled,
      value: true,
    );
    emit(state.copyWith(eveningAzkarEnabled: true));
    await _scheduleEveningAzkar();
  }

  Future<void> setFridayReminder(bool enabled) async {
    if (!enabled) {
      await _disable(
        cacheKey: CacheKeys.fridayReminderEnabled,
        notificationId: NotificationIds.fridayReminder,
        updateState: (state) =>
            state.copyWith(fridayReminderEnabled: false),
      );
      return;
    }

    final granted = await NotificationPermission.request();
    if (!granted) {
      emit(state.copyWith(fridayReminderEnabled: false));
      return;
    }

    await CacheHelper().saveData(
      key: CacheKeys.fridayReminderEnabled,
      value: true,
    );
    emit(state.copyWith(fridayReminderEnabled: true));
    await _scheduleFridayReminder();
  }

  Future<void> setMotivational(bool enabled) async {
    if (!enabled) {
      await DailyNotificationScheduler.instance.cancel();
      await CacheHelper().saveData(
        key: CacheKeys.motivationalEnabled,
        value: false,
      );
      emit(state.copyWith(motivationalEnabled: false));
      return;
    }

    final granted = await NotificationPermission.request();
    if (!granted) {
      emit(state.copyWith(motivationalEnabled: false));
      return;
    }

    await CacheHelper().saveData(
      key: CacheKeys.motivationalEnabled,
      value: true,
    );
    emit(state.copyWith(motivationalEnabled: true));
    await _scheduleMotivational();
  }

  Future<void> setPrayerNotifications(bool enabled) async {
    if (!enabled) {
      await _notificationService.cancelPrayerNotifications();
      await CacheHelper().saveData(
        key: CacheKeys.prayerNotificationsEnabled,
        value: false,
      );
      emit(state.copyWith(prayerNotificationsEnabled: false));
      return;
    }

    final granted = await NotificationPermission.request();
    if (!granted) {
      emit(state.copyWith(prayerNotificationsEnabled: false));
      return;
    }

    await CacheHelper().saveData(
      key: CacheKeys.prayerNotificationsEnabled,
      value: true,
    );
    emit(state.copyWith(prayerNotificationsEnabled: true));
    await schedulePrayerNotificationsFromRepo();
  }

  Future<void> schedulePrayerNotificationsFromRepo() async {
    if (!state.prayerNotificationsEnabled) {
      return;
    }

    final repo = _prayerRepo;
    if (repo == null) {
      return;
    }

    try {
      final location = await repo.getLocation();
      final todayTimes = repo.getPrayerTimes(location);
      await _notificationService.schedulePrayerNotifications(
        todayTimes,
      );

      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowTimes = repo.getPrayerTimesForDate(
        location,
        tomorrow,
      );

      for (final prayer in todayTimes) {
        if (prayer.type == PrayerType.sunrise) {
          continue;
        }

        if (!prayer.time.isBefore(DateTime.now())) {
          continue;
        }

        final tomorrowPrayer = tomorrowTimes.firstWhere(
          (item) => item.type == prayer.type,
        );

        final id = _idForPrayerType(prayer.type);
        if (id == null) {
          continue;
        }

        await _notificationService.schedulePrayerNotification(
          id: id,
          title: 'حان وقت ${tomorrowPrayer.name}',
          body: 'حان الآن موعد صلاة ${tomorrowPrayer.name}',
          scheduledTime: tomorrowPrayer.time,
          payload: NotificationPayload.forPrayer(
            tomorrowPrayer.name,
          ),
        );
      }
    } catch (_) {
      // Keep settings UI functional if location/prayer scheduling fails.
    }
  }

  Future<void> reschedulePrayerNotifications(
    List<PrayerTimeModel> prayerTimes,
  ) async {
    if (!state.prayerNotificationsEnabled) {
      return;
    }

    await _notificationService.cancelPrayerNotifications();
    await _notificationService.schedulePrayerNotifications(
      prayerTimes,
    );
  }

  Future<void> _rescheduleEnabledNotifications() async {
    if (state.quranReminderEnabled) {
      await _scheduleQuranReminder();
    }

    if (state.morningAzkarEnabled) {
      await _scheduleMorningAzkar();
    }

    if (state.eveningAzkarEnabled) {
      await _scheduleEveningAzkar();
    }

    if (state.fridayReminderEnabled) {
      await _scheduleFridayReminder();
    }

    if (state.motivationalEnabled) {
      await _scheduleMotivational();
    }
  }

  Future<void> _scheduleQuranReminder() async {
    final hour = _readHour(
      CacheKeys.quranReminderHour,
      NotificationDefaults.quranHour,
    );
    final minute = _readMinute(
      CacheKeys.quranReminderMinute,
      NotificationDefaults.quranMinute,
    );

    await _notificationService.scheduleDailyNotification(
      id: NotificationIds.quranReminder,
      title: 'وقت القرآن',
      body: 'اجعل لك وردًا من كتاب الله اليوم 🤍',
      hour: hour,
      minute: minute,
      channelId: NotificationChannels.quranId,
      payload: NotificationPayload.quran,
    );
  }

  Future<void> _scheduleMorningAzkar() async {
    final hour = _readHour(
      CacheKeys.morningAzkarHour,
      NotificationDefaults.morningAzkarHour,
    );
    final minute = _readMinute(
      CacheKeys.morningAzkarMinute,
      NotificationDefaults.morningAzkarMinute,
    );

    await _notificationService.scheduleDailyNotification(
      id: NotificationIds.morningAzkar,
      title: 'أذكار الصباح',
      body: 'ابدأ يومك بذكر الله 🤍',
      hour: hour,
      minute: minute,
      channelId: NotificationChannels.azkarId,
      payload: NotificationPayload.morningAzkar,
    );
  }

  Future<void> _scheduleEveningAzkar() async {
    final hour = _readHour(
      CacheKeys.eveningAzkarHour,
      NotificationDefaults.eveningAzkarHour,
    );
    final minute = _readMinute(
      CacheKeys.eveningAzkarMinute,
      NotificationDefaults.eveningAzkarMinute,
    );

    await _notificationService.scheduleDailyNotification(
      id: NotificationIds.eveningAzkar,
      title: 'أذكار المساء',
      body: 'اختم يومك بذكر الله 🤍',
      hour: hour,
      minute: minute,
      channelId: NotificationChannels.azkarId,
      payload: NotificationPayload.eveningAzkar,
    );
  }

  Future<void> _scheduleFridayReminder() async {
    final hour = _readHour(
      CacheKeys.fridayReminderHour,
      NotificationDefaults.fridayHour,
    );
    final minute = _readMinute(
      CacheKeys.fridayReminderMinute,
      NotificationDefaults.fridayMinute,
    );

    await _notificationService.scheduleWeeklyFridayNotification(
      id: NotificationIds.fridayReminder,
      title: 'جمعة مباركة 🤍',
      body: 'لا تنسَ الصلاة على النبي ﷺ وقراءة سورة الكهف.',
      hour: hour,
      minute: minute,
      channelId: NotificationChannels.generalId,
      payload: NotificationPayload.friday,
    );
  }

  Future<void> _scheduleMotivational() async {
    await DailyNotificationScheduler.instance.scheduleToday();
  }

  Future<void> _disable({
    required String cacheKey,
    required int notificationId,
    required SettingState Function(SettingState state) updateState,
  }) async {
    await _notificationService.cancelNotification(notificationId);
    await CacheHelper().saveData(key: cacheKey, value: false);
    emit(updateState(state));
  }

  bool _readBool(CacheHelper cache, String key) {
    return cache.getData(key: key) == true;
  }

  int _readHour(String key, int defaultValue) {
    final value = CacheHelper().getData(key: key);
    return value is int ? value : defaultValue;
  }

  int _readMinute(String key, int defaultValue) {
    final value = CacheHelper().getData(key: key);
    return value is int ? value : defaultValue;
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

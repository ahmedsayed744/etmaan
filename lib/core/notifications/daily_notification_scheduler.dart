import 'package:etmaan/core/notifications/content/notification_content_repository.dart';
import 'package:etmaan/core/notifications/content/notification_content_repository_imp.dart';
import 'package:etmaan/core/notifications/notification_channels.dart';
import 'package:etmaan/core/notifications/notification_defaults.dart';
import 'package:etmaan/core/notifications/notification_ids.dart';
import 'package:etmaan/core/notifications/notification_payload.dart';
import 'package:etmaan/core/notifications/notification_service.dart';
import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';
import 'package:flutter/foundation.dart';

class DailyNotificationScheduler {
  DailyNotificationScheduler._({
    NotificationService? notificationService,
    NotificationContentRepository? contentRepository,
  }) : _notificationService =
           notificationService ?? NotificationService.instance,
       _contentRepository =
           contentRepository ?? NotificationContentRepositoryImp();

  static final DailyNotificationScheduler instance =
      DailyNotificationScheduler._();

  final NotificationService _notificationService;
  final NotificationContentRepository _contentRepository;

  Future<void> cancel() {
    return _notificationService.cancelDailyContentNotifications();
  }

  Future<bool> scheduleToday() async {
    await cancel();

    final slots = NotificationDefaults.dailyContentSlots;
    if (slots.isEmpty) {
      return false;
    }

    final verseSlotCount = slots
        .where((slot) => slot.kind == DailyContentKind.verse)
        .length;
    final hadithSlotCount = slots
        .where((slot) => slot.kind == DailyContentKind.hadith)
        .length;

    final todayVerses = await _contentRepository.getRandomVerses(
      verseSlotCount,
    );
    final todayHadiths = await _contentRepository.getRandomHadiths(
      hadithSlotCount,
    );

    if (todayVerses.isEmpty && todayHadiths.isEmpty) {
      if (kDebugMode) {
        debugPrint(
          'Daily content notifications skipped: no verse or hadith content available',
        );
      }
      return false;
    }

    final tomorrowVerses = await _contentRepository.getRandomVerses(
      verseSlotCount,
      excludeIds: todayVerses.map((item) => item.id).toSet(),
    );
    final tomorrowHadiths = await _contentRepository.getRandomHadiths(
      hadithSlotCount,
      excludeIds: todayHadiths.map((item) => item.id).toSet(),
    );

    final now = DateTime.now();
    var scheduledCount = 0;

    scheduledCount += await _scheduleDay(
      day: DateTime(now.year, now.month, now.day),
      idBase: NotificationIds.dailyContentBase,
      verses: todayVerses,
      hadiths: todayHadiths,
    );

    final tomorrow = now.add(const Duration(days: 1));
    scheduledCount += await _scheduleDay(
      day: DateTime(tomorrow.year, tomorrow.month, tomorrow.day),
      idBase: NotificationIds.dailyContentTomorrowBase,
      verses: tomorrowVerses,
      hadiths: tomorrowHadiths,
    );

    if (kDebugMode) {
      debugPrint(
        'Daily content notifications scheduled: $scheduledCount '
        '(verses=${todayVerses.length + tomorrowVerses.length}, '
        'hadiths=${todayHadiths.length + tomorrowHadiths.length})',
      );
    }

    return scheduledCount > 0;
  }

  Future<int> _scheduleDay({
    required DateTime day,
    required int idBase,
    required List<VerseModel> verses,
    required List<HadithModel> hadiths,
  }) async {
    var verseIndex = 0;
    var hadithIndex = 0;
    var scheduledCount = 0;

    for (var i = 0; i < NotificationDefaults.dailyContentSlots.length; i++) {
      final slot = NotificationDefaults.dailyContentSlots[i];
      final scheduledTime = DateTime(
        day.year,
        day.month,
        day.day,
        slot.hour,
        slot.minute,
      );

      if (!scheduledTime.isAfter(DateTime.now())) {
        continue;
      }

      final scheduled = switch (slot.kind) {
        DailyContentKind.verse => await _scheduleVerse(
          id: idBase + i,
          scheduledTime: scheduledTime,
          verses: verses,
          index: verseIndex,
        ),
        DailyContentKind.hadith => await _scheduleHadith(
          id: idBase + i,
          scheduledTime: scheduledTime,
          hadiths: hadiths,
          index: hadithIndex,
        ),
      };

      if (slot.kind == DailyContentKind.verse) {
        verseIndex++;
      } else {
        hadithIndex++;
      }

      if (scheduled) {
        scheduledCount++;
      }
    }

    return scheduledCount;
  }

  Future<bool> _scheduleVerse({
    required int id,
    required DateTime scheduledTime,
    required List<VerseModel> verses,
    required int index,
  }) {
    if (index >= verses.length) {
      return Future.value(false);
    }

    final verse = verses[index];
    return _notificationService.scheduleNotificationAt(
      id: id,
      title: NotificationDefaults.dailyVerseTitle,
      body: _notificationBody(verse.text),
      scheduledTime: scheduledTime,
      channelId: NotificationChannels.quranId,
      payload: NotificationPayload.forDailyVerse(verse.id),
    );
  }

  Future<bool> _scheduleHadith({
    required int id,
    required DateTime scheduledTime,
    required List<HadithModel> hadiths,
    required int index,
  }) {
    if (index >= hadiths.length) {
      return Future.value(false);
    }

    final hadith = hadiths[index];
    return _notificationService.scheduleNotificationAt(
      id: id,
      title: NotificationDefaults.dailyHadithTitle,
      body: _notificationBody(hadith.text),
      scheduledTime: scheduledTime,
      channelId: NotificationChannels.motivationalId,
      payload: NotificationPayload.forDailyHadith(hadith.id),
    );
  }

  String _notificationBody(String text) {
    final normalized = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    const maxLength = 280;
    if (normalized.length <= maxLength) {
      return normalized;
    }
    return '${normalized.substring(0, maxLength).trim()}…';
  }
}

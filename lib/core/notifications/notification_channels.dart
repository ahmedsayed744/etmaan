import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannels {
  NotificationChannels._();

  static const String generalId = 'etmaan_general';
  static const String prayerId = 'etmaan_prayer';
  static const String azkarId = 'etmaan_azkar';
  static const String quranId = 'etmaan_quran';
  static const String motivationalId = 'etmaan_motivational';

  // Adhan notification channel
  static const String prayerAdhanId = 'etmaan_prayer_adhan';

  static const String generalName = 'إشعارات عامة';
  static const String prayerName = 'تنبيهات الصلاة';
  static const String azkarName = 'أذكار';
  static const String quranName = 'تذكير القرآن';
  static const String motivationalName = 'رسائل تحفيزية';

  // Adhan notification channel
  static const String prayerAdhanName = 'أذان الصلاة';

  static const String generalDescription = 'إشعارات عامة للتطبيق';
  static const String prayerDescription = 'تنبيهات مواقيت الصلاة';
  static const String azkarDescription = 'تذكير أذكار الصباح والمساء';
  static const String quranDescription = 'تذكير قراءة القرآن اليومي';
  static const String motivationalDescription = 'رسائل تحفيزية يومية';

  // Adhan notification channel
  static const String prayerAdhanDescription =
      'تنبيهات مواقيت الصلاة بصوت الأذان';

  static List<AndroidNotificationChannel> get androidChannels => [
        const AndroidNotificationChannel(
          generalId,
          generalName,
          description: generalDescription,
          importance: Importance.defaultImportance,
        ),
        const AndroidNotificationChannel(
          prayerId,
          prayerName,
          description: prayerDescription,
          importance: Importance.high,
          playSound: true,
        ),
        const AndroidNotificationChannel(
          azkarId,
          azkarName,
          description: azkarDescription,
          importance: Importance.high,
          playSound: true,
        ),
        const AndroidNotificationChannel(
          quranId,
          quranName,
          description: quranDescription,
          importance: Importance.high,
          playSound: true,
        ),
        const AndroidNotificationChannel(
          motivationalId,
          motivationalName,
          description: motivationalDescription,
          importance: Importance.defaultImportance,
        ),
        // Adhan notification channel
        const AndroidNotificationChannel(
          prayerAdhanId,
          prayerAdhanName,
          description: prayerAdhanDescription,
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('adhan'),
          audioAttributesUsage: AudioAttributesUsage.alarm,
        ),
      ];
}

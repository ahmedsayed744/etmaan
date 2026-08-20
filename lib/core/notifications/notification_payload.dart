enum NotificationTarget {
  quran,
  morningAzkar,
  eveningAzkar,
  friday,
  motivational,
  prayer,
}

class NotificationPayload {
  static const String quran = 'quran';
  static const String morningAzkar = 'morning_azkar';
  static const String eveningAzkar = 'evening_azkar';
  static const String friday = 'friday';
  static const String motivational = 'motivational';
  static const String prayer = 'prayer';

  static String forPrayer(String prayerName) => 'prayer:$prayerName';

  static String forDailyVerse(int verseId) => 'quran:verse:$verseId';

  static String forDailyHadith(int hadithId) => 'motivational:hadith:$hadithId';

  static NotificationTarget? parse(String? payload) {
    if (payload == null || payload.isEmpty) {
      return null;
    }

    switch (payload) {
      case quran:
        return NotificationTarget.quran;
      case morningAzkar:
        return NotificationTarget.morningAzkar;
      case eveningAzkar:
        return NotificationTarget.eveningAzkar;
      case friday:
        return NotificationTarget.friday;
      case motivational:
        return NotificationTarget.motivational;
      default:
        if (payload.startsWith(quran)) {
          return NotificationTarget.quran;
        }
        if (payload.startsWith(motivational)) {
          return NotificationTarget.motivational;
        }
        if (payload.startsWith('prayer')) {
          return NotificationTarget.prayer;
        }
        return null;
    }
  }
}

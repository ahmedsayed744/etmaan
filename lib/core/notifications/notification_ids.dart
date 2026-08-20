class NotificationIds {
  static const int quranReminder = 100;
  static const int morningAzkar = 200;
  static const int eveningAzkar = 300;
  static const int fridayReminder = 400;

  static const int fajr = 500;
  static const int dhuhr = 501;
  static const int asr = 502;
  static const int maghrib = 503;
  static const int isha = 504;

  static const int motivational = 600;

  static const int dailyContentBase = 610;
  static const int dailyContentTomorrowBase = 620;

  static List<int> dailyContentIdsFor(int slotCount) {
    return [
      ...List<int>.generate(slotCount, (index) => dailyContentBase + index),
      ...List<int>.generate(
        slotCount,
        (index) => dailyContentTomorrowBase + index,
      ),
    ];
  }
}
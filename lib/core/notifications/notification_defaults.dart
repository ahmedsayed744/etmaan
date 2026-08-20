enum DailyContentKind { verse, hadith }

class DailyContentSlot {
  final int hour;
  final int minute;
  final DailyContentKind kind;

  const DailyContentSlot({
    required this.hour,
    required this.minute,
    required this.kind,
  });
}

class NotificationDefaults {
  static const int quranHour = 8;
  static const int quranMinute = 0;

  static const int morningAzkarHour = 6;
  static const int morningAzkarMinute = 30;

  static const int eveningAzkarHour = 18;
  static const int eveningAzkarMinute = 0;

  static const int fridayHour = 10;
  static const int fridayMinute = 0;

  static const int motivationalHour = 12;
  static const int motivationalMinute = 0;

  static const String motivationalTitle = 'رسالة تحفيزية';
  static const String motivationalBody =
      'استمر في طريقك، فكل خطوة تقربك من الله 🤍';

  static const String dailyVerseTitle = 'آية تذكير 🤍';
  static const String dailyHadithTitle = 'حديث اليوم 🤍';

  static const List<DailyContentSlot> dailyContentSlots = [
    DailyContentSlot(hour: 9, minute: 0, kind: DailyContentKind.verse),
    DailyContentSlot(hour: 11, minute: 30, kind: DailyContentKind.hadith),
    DailyContentSlot(hour: 14, minute: 30, kind: DailyContentKind.verse),
    DailyContentSlot(hour: 17, minute: 30, kind: DailyContentKind.hadith),
    DailyContentSlot(hour: 21, minute: 0, kind: DailyContentKind.verse),
  ];
}

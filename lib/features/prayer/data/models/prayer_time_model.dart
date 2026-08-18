enum PrayerType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
}

class PrayerTimeModel {
  final PrayerType type;
  final String name;
  final DateTime time;

  const PrayerTimeModel({
    required this.type,
    required this.name,
    required this.time,
  });
}
class SettingState {
  final bool quranReminderEnabled;
  final bool morningAzkarEnabled;
  final bool eveningAzkarEnabled;
  final bool fridayReminderEnabled;
  final bool motivationalEnabled;
  final bool prayerNotificationsEnabled;

  const SettingState({
    this.quranReminderEnabled = false,
    this.morningAzkarEnabled = false,
    this.eveningAzkarEnabled = false,
    this.fridayReminderEnabled = false,
    this.motivationalEnabled = false,
    this.prayerNotificationsEnabled = false,
  });

  SettingState copyWith({
    bool? quranReminderEnabled,
    bool? morningAzkarEnabled,
    bool? eveningAzkarEnabled,
    bool? fridayReminderEnabled,
    bool? motivationalEnabled,
    bool? prayerNotificationsEnabled,
  }) {
    return SettingState(
      quranReminderEnabled:
          quranReminderEnabled ?? this.quranReminderEnabled,
      morningAzkarEnabled:
          morningAzkarEnabled ?? this.morningAzkarEnabled,
      eveningAzkarEnabled:
          eveningAzkarEnabled ?? this.eveningAzkarEnabled,
      fridayReminderEnabled:
          fridayReminderEnabled ?? this.fridayReminderEnabled,
      motivationalEnabled:
          motivationalEnabled ?? this.motivationalEnabled,
      prayerNotificationsEnabled:
          prayerNotificationsEnabled ??
              this.prayerNotificationsEnabled,
    );
  }
}

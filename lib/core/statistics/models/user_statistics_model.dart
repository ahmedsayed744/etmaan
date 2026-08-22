class DailyStatistics {
  final String date;
  final int tasbeehCount;
  final int quranPages;
  final int quranHizb;
  final int sessionSeconds;

  DailyStatistics({
    required this.date,
    this.tasbeehCount = 0,
    this.quranPages = 0,
    this.quranHizb = 0,
    this.sessionSeconds = 0,
  });

  DailyStatistics copyWith({
    String? date,
    int? tasbeehCount,
    int? quranPages,
    int? quranHizb,
    int? sessionSeconds,
  }) {
    return DailyStatistics(
      date: date ?? this.date,
      tasbeehCount: tasbeehCount ?? this.tasbeehCount,
      quranPages: quranPages ?? this.quranPages,
      quranHizb: quranHizb ?? this.quranHizb,
      sessionSeconds: sessionSeconds ?? this.sessionSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'tasbeehCount': tasbeehCount,
      'quranPages': quranPages,
      'quranHizb': quranHizb,
      'sessionSeconds': sessionSeconds,
    };
  }

  factory DailyStatistics.fromJson(Map<String, dynamic> json) {
    return DailyStatistics(
      date: json['date'] as String? ?? '',
      tasbeehCount: json['tasbeehCount'] as int? ?? 0,
      quranPages: json['quranPages'] as int? ?? 0,
      quranHizb: json['quranHizb'] as int? ?? 0,
      sessionSeconds: json['sessionSeconds'] as int? ?? 0,
    );
  }
}

class LifetimeStatistics {
  final int totalTasbeeh;
  final int totalQuranPages;
  final int totalQuranHizb;
  final int activeDays;
  final int totalSessionSeconds;

  LifetimeStatistics({
    this.totalTasbeeh = 0,
    this.totalQuranPages = 0,
    this.totalQuranHizb = 0,
    this.activeDays = 0,
    this.totalSessionSeconds = 0,
  });

  LifetimeStatistics copyWith({
    int? totalTasbeeh,
    int? totalQuranPages,
    int? totalQuranHizb,
    int? activeDays,
    int? totalSessionSeconds,
  }) {
    return LifetimeStatistics(
      totalTasbeeh: totalTasbeeh ?? this.totalTasbeeh,
      totalQuranPages: totalQuranPages ?? this.totalQuranPages,
      totalQuranHizb: totalQuranHizb ?? this.totalQuranHizb,
      activeDays: activeDays ?? this.activeDays,
      totalSessionSeconds: totalSessionSeconds ?? this.totalSessionSeconds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTasbeeh': totalTasbeeh,
      'totalQuranPages': totalQuranPages,
      'totalQuranHizb': totalQuranHizb,
      'activeDays': activeDays,
      'totalSessionSeconds': totalSessionSeconds,
    };
  }

  factory LifetimeStatistics.fromJson(Map<String, dynamic> json) {
    return LifetimeStatistics(
      totalTasbeeh: json['totalTasbeeh'] as int? ?? 0,
      totalQuranPages: json['totalQuranPages'] as int? ?? 0,
      totalQuranHizb: json['totalQuranHizb'] as int? ?? 0,
      activeDays: json['activeDays'] as int? ?? 0,
      totalSessionSeconds: json['totalSessionSeconds'] as int? ?? 0,
    );
  }
}

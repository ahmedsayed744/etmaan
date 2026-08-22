class TasbeehMonthlyStats {
  final String monthKey;
  final int subhanAllah;
  final int alhamdulillah;
  final int allahuAkbar;
  final int laIlahaIllallah;
  final int astaghfirullah;

  TasbeehMonthlyStats({
    required this.monthKey,
    this.subhanAllah = 0,
    this.alhamdulillah = 0,
    this.allahuAkbar = 0,
    this.laIlahaIllallah = 0,
    this.astaghfirullah = 0,
  });

  int get total => subhanAllah + alhamdulillah + allahuAkbar + laIlahaIllallah + astaghfirullah;

  TasbeehMonthlyStats copyWith({
    String? monthKey,
    int? subhanAllah,
    int? alhamdulillah,
    int? allahuAkbar,
    int? laIlahaIllallah,
    int? astaghfirullah,
  }) {
    return TasbeehMonthlyStats(
      monthKey: monthKey ?? this.monthKey,
      subhanAllah: subhanAllah ?? this.subhanAllah,
      alhamdulillah: alhamdulillah ?? this.alhamdulillah,
      allahuAkbar: allahuAkbar ?? this.allahuAkbar,
      laIlahaIllallah: laIlahaIllallah ?? this.laIlahaIllallah,
      astaghfirullah: astaghfirullah ?? this.astaghfirullah,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthKey': monthKey,
      'subhanAllah': subhanAllah,
      'alhamdulillah': alhamdulillah,
      'allahuAkbar': allahuAkbar,
      'laIlahaIllallah': laIlahaIllallah,
      'astaghfirullah': astaghfirullah,
    };
  }

  factory TasbeehMonthlyStats.fromJson(Map<String, dynamic> json) {
    return TasbeehMonthlyStats(
      monthKey: json['monthKey'] as String? ?? '',
      subhanAllah: json['subhanAllah'] as int? ?? 0,
      alhamdulillah: json['alhamdulillah'] as int? ?? 0,
      allahuAkbar: json['allahuAkbar'] as int? ?? 0,
      laIlahaIllallah: json['laIlahaIllallah'] as int? ?? 0,
      astaghfirullah: json['astaghfirullah'] as int? ?? 0,
    );
  }
}

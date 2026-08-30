class NotificationHistoryEntry {
  final String type; // 'verse' | 'hadith'
  final String title;
  final String body;
  final DateTime scheduledAt;

  // Verse metadata
  final String? surahName;
  final int? verseNumber;
  final int? surahNumber;

  // Hadith metadata
  final String? bookName;

  const NotificationHistoryEntry({
    required this.type,
    required this.title,
    required this.body,
    required this.scheduledAt,
    this.surahName,
    this.verseNumber,
    this.surahNumber,
    this.bookName,
  });

  factory NotificationHistoryEntry.fromJson(Map<String, dynamic> json) {
    return NotificationHistoryEntry(
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      surahName: json['surahName'] as String?,
      verseNumber: json['verseNumber'] as int?,
      surahNumber: json['surahNumber'] as int?,
      bookName: json['bookName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      'body': body,
      'scheduledAt': scheduledAt.toIso8601String(),
      if (surahName != null) 'surahName': surahName,
      if (verseNumber != null) 'verseNumber': verseNumber,
      if (surahNumber != null) 'surahNumber': surahNumber,
      if (bookName != null) 'bookName': bookName,
    };
  }
}

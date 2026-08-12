class VerseModel {
  final int id;
  final int surahNumber;
  final String surahName;
  final int verseNumber;
  // final String category;
  final String text;

  const VerseModel({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.verseNumber,
    // required this.category,
    required this.text,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'] as int,
      surahNumber: json['surahNumber'] as int,
      surahName: json['surahName'] as String,
      verseNumber: json['verseNumber'] as int,
      // category: json['category'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'verseNumber': verseNumber,
      // 'category': category,
      'text': text,
    };
  }
}

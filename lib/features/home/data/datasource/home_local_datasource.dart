import 'dart:convert';
import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';
import 'package:flutter/services.dart';
class HomeLocalDataSource {

  // ============================================
  // Hadith
  // ============================================

  Future<List<HadithModel>> getHadiths() async {
    const files = [
      'assets/data/hadith/bukhari_1.json',
      'assets/data/hadith/bukhari_2.json',
      'assets/data/hadith/bukhari_3.json',
      'assets/data/hadith/bukhari_4.json',
      'assets/data/hadith/bukhari_5.json',
      'assets/data/hadith/bukhari_6.json',
      'assets/data/hadith/bukhari_7.json',
      'assets/data/hadith/bukhari_8.json',
    ];

    final List<HadithModel> allHadiths = [];

    for (final file in files) {
      final jsonString = await rootBundle.loadString(file);

      final List<dynamic> data = jsonDecode(jsonString);

      final hadiths = data.map(
        (item) => HadithModel.fromJson(
          item as Map<String, dynamic>,
        ),
      );

      allHadiths.addAll(hadiths);
    }

    return allHadiths;
  }

  // ============================================
  // Quran Verses
  // ============================================

  Future<List<VerseModel>> getVerses() async {
    const files = [
      'assets/data/verse/verses_1.json',
      'assets/data/verse/verses_2.json',
      'assets/data/verse/verses_3.json',
      'assets/data/verse/verses_4.json',
      'assets/data/verse/verses_5.json',
      'assets/data/verse/verses_6.json',
    ];

    final List<VerseModel> allVerses = [];

    for (final file in files) {
      final jsonString = await rootBundle.loadString(file);

      final List<dynamic> data = jsonDecode(jsonString);

      final verses = data.map(
        (item) => VerseModel.fromJson(
          item as Map<String, dynamic>,
        ),
      );

      allVerses.addAll(verses);
    }
    return allVerses;
  }
}
import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/hadith_model.dart';
import '../models/verse_model.dart';

class HomeLocalDataSource {
  List<HadithModel>? _dailyHadithsCache;
  List<VerseModel>? _dailyVersesCache;

  // ============================================
  // Daily Hadiths
  // ============================================

  Future<List<HadithModel>> getDailyHadiths() async {
    // Return cached data
    if (_dailyHadithsCache != null) {
      return _dailyHadithsCache!;
    }

    final jsonString = await rootBundle.loadString(
      'assets/data/daily/daily_hadith.json',
    );

    final List<dynamic> data = jsonDecode(jsonString);

    _dailyHadithsCache = data
        .map(
          (item) => HadithModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return _dailyHadithsCache!;
  }

  // ============================================
  // Daily Verses
  // ============================================

  Future<List<VerseModel>> getDailyVerses() async {
    // Return cached data
    if (_dailyVersesCache != null) {
      return _dailyVersesCache!;
    }

    final jsonString = await rootBundle.loadString(
      'assets/data/daily/daily_verses.json',
    );

    final List<dynamic> data = jsonDecode(jsonString);

    _dailyVersesCache = data
        .map(
          (item) => VerseModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return _dailyVersesCache!;
  }
}
import 'dart:convert';
import 'dart:math';

import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'notification_content_repository.dart';

class NotificationContentRepositoryImp
    implements NotificationContentRepository {
  NotificationContentRepositoryImp({Random? random})
    : _random = random ?? Random();

  static const List<String> verseAssetPaths = [
    'assets/data/verse/verses_1.json',
    'assets/data/verse/verses_2.json',
    'assets/data/verse/verses_3.json',
    'assets/data/verse/verses_4.json',
    'assets/data/verse/verses_5.json',
    'assets/data/verse/verses_6.json',
  ];

  static const List<String> hadithAssetPaths = [
    'assets/data/hadith/bukhari_1.json',
    'assets/data/hadith/bukhari_2.json',
    'assets/data/hadith/bukhari_3.json',
    'assets/data/hadith/bukhari_4.json',
    'assets/data/hadith/bukhari_5.json',
    'assets/data/hadith/bukhari_6.json',
    'assets/data/hadith/bukhari_7.json',
    'assets/data/hadith/bukhari_8.json',
  ];

  final Random _random;

  List<VerseModel>? _verses;
  List<HadithModel>? _hadiths;
  Future<void>? _loadFuture;

  @override
  Future<List<VerseModel>> getVerses() async {
    await _ensureLoaded();
    return List.unmodifiable(_verses ?? const []);
  }

  @override
  Future<List<HadithModel>> getHadiths() async {
    await _ensureLoaded();
    return List.unmodifiable(_hadiths ?? const []);
  }

  @override
  Future<VerseModel?> getRandomVerse({Set<int> excludeIds = const {}}) async {
    final items = await getRandomVerses(1, excludeIds: excludeIds);
    return items.isEmpty ? null : items.first;
  }

  @override
  Future<HadithModel?> getRandomHadith({
    Set<int> excludeIds = const {},
  }) async {
    final items = await getRandomHadiths(1, excludeIds: excludeIds);
    return items.isEmpty ? null : items.first;
  }

  @override
  Future<List<VerseModel>> getRandomVerses(
    int count, {
    Set<int> excludeIds = const {},
  }) async {
    final pool = await getVerses();
    return _pickUnique(pool, count, (item) => item.id, excludeIds);
  }

  @override
  Future<List<HadithModel>> getRandomHadiths(
    int count, {
    Set<int> excludeIds = const {},
  }) async {
    final pool = await getHadiths();
    return _pickUnique(pool, count, (item) => item.id, excludeIds);
  }

  Future<void> _ensureLoaded() {
    return _loadFuture ??= _loadPools();
  }

  Future<void> _loadPools() async {
    final verseResults = await Future.wait(
      verseAssetPaths.map(_loadJsonList),
    );
    final hadithResults = await Future.wait(
      hadithAssetPaths.map(_loadJsonList),
    );

    _verses = _parseItems(verseResults, VerseModel.fromJson, 'verse');
    _hadiths = _parseItems(hadithResults, HadithModel.fromJson, 'hadith');

    if (kDebugMode) {
      debugPrint(
        'Notification content loaded: '
        '${_verses?.length ?? 0} verses from ${verseAssetPaths.length} files, '
        '${_hadiths?.length ?? 0} hadiths from ${hadithAssetPaths.length} files',
      );
    }
  }

  Future<List<dynamic>> _loadJsonList(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded;
      }
      if (kDebugMode) {
        debugPrint('Notification content: $path is not a JSON list');
      }
      return const [];
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Notification content failed to load $path: $error');
      }
      return const [];
    }
  }

  List<T> _parseItems<T>(
    List<List<dynamic>> fileContents,
    T Function(Map<String, dynamic> json) fromJson,
    String label,
  ) {
    final items = <T>[];

    for (final fileContent in fileContents) {
      for (final raw in fileContent) {
        if (raw is! Map<String, dynamic>) {
          continue;
        }
        try {
          items.add(fromJson(raw));
        } catch (error) {
          if (kDebugMode) {
            debugPrint('Notification content skipped invalid $label: $error');
          }
        }
      }
    }

    return items;
  }

  List<T> _pickUnique<T>(
    List<T> pool,
    int count,
    int Function(T item) idOf,
    Set<int> excludeIds,
  ) {
    if (count <= 0 || pool.isEmpty) {
      return const [];
    }

    final uniqueById = <int, T>{};
    for (final item in pool) {
      uniqueById.putIfAbsent(idOf(item), () => item);
    }

    final available = uniqueById.values
        .where((item) => !excludeIds.contains(idOf(item)))
        .toList();
    available.shuffle(_random);

    if (available.length >= count) {
      return available.take(count).toList();
    }

    final selected = [...available];
    final fallback = uniqueById.values.toList()..shuffle(_random);
    var index = 0;
    while (selected.length < count && fallback.isNotEmpty) {
      selected.add(fallback[index % fallback.length]);
      index++;
    }

    return selected;
  }
}

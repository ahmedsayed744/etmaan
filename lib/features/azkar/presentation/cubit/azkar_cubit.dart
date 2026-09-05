import 'dart:convert';

import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repo/azkar_repo.dart';
import 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  final AzkarRepo repo;

  AzkarCubit(this.repo) : super(const AzkarInitial());

  /// Section key derived from jsonPath, e.g. "morning", "evening".
  String _sectionKey = '';

  Future<void> loadAzkar(String jsonPath) async {
    try {
      emit(const AzkarLoading());

      // Derive section key from path: "assets/data/azkar/morning.json" -> "morning"
      _sectionKey = jsonPath.split('/').last.replaceAll('.json', '');

      final cache = CacheHelper();

      // ── Daily reset check ──
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month}-${today.day}';
      final savedDate =
          cache.getData(key: CacheKeys.azkarProgressDate) as String?;

      if (savedDate != todayStr) {
        // New calendar day — wipe all azkar progress and update date.
        await cache.removeData(key: CacheKeys.azkarProgress);
        await cache.saveData(key: CacheKeys.azkarProgressDate, value: todayStr);
      }

      // ── Load items from JSON asset ──
      final azkar = await repo.getAzkar(jsonPath);

      // ── Restore saved counters ──
      final counters = <int, int>{};
      final savedProgress = _loadProgressMap(cache);
      final sectionMap = savedProgress[_sectionKey] as Map<String, dynamic>?;

      for (final item in azkar) {
        final saved = sectionMap?[item.id.toString()] as int?;
        counters[item.id] = saved ?? 0;
      }

      emit(AzkarLoaded(azkar: azkar, counters: counters));
    } catch (e) {
      emit(AzkarError(e.toString()));
    }
  }

  void increment(int id) {
    final currentState = state;

    if (currentState is! AzkarLoaded) {
      return;
    }

    final item = currentState.azkar.firstWhere((element) => element.id == id);

    final currentCount = currentState.counters[id] ?? 0;

    if (currentCount >= item.count) {
      return;
    }

    final updatedCounters = Map<int, int>.from(currentState.counters);

    updatedCounters[id] = currentCount + 1;

    emit(currentState.copyWith(counters: updatedCounters));

    // Persist immediately.
    _saveCounters(updatedCounters);
  }

  void reset() {
    final currentState = state;

    if (currentState is! AzkarLoaded) {
      return;
    }

    final counters = <int, int>{};

    for (final item in currentState.azkar) {
      counters[item.id] = 0;
    }

    emit(currentState.copyWith(counters: counters));

    // Clear this section from cache.
    _saveCounters(counters);
  }

  // ──────────────────────────────────────────────
  // Private helpers
  // ──────────────────────────────────────────────

  /// Read the global azkar progress JSON map from cache.
  Map<String, dynamic> _loadProgressMap(CacheHelper cache) {
    final raw = cache.getData(key: CacheKeys.azkarProgress) as String?;
    if (raw == null || raw.isEmpty) return {};
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  /// Write the current section's counters into the global progress map.
  Future<void> _saveCounters(Map<int, int> counters) async {
    try {
      final cache = CacheHelper();
      final progressMap = _loadProgressMap(cache);

      final sectionData = <String, int>{};
      for (final entry in counters.entries) {
        sectionData[entry.key.toString()] = entry.value;
      }
      progressMap[_sectionKey] = sectionData;

      await cache.saveData(
        key: CacheKeys.azkarProgress,
        value: jsonEncode(progressMap),
      );
    } catch (_) {
      // Silently fail — do not crash the app for a cache write error.
    }
  }
}

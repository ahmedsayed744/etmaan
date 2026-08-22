import 'dart:convert';
import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import '../models/user_statistics_model.dart';

class StatisticsLocalDataSource {
  final CacheHelper _cacheHelper = CacheHelper();

  Future<DailyStatistics?> getDailyStatistics() async {
    final String? jsonStr = _cacheHelper.getData(key: CacheKeys.statisticsDaily);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final Map<String, dynamic> json = jsonDecode(jsonStr);
        return DailyStatistics.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> saveDailyStatistics(DailyStatistics daily) async {
    return await _cacheHelper.saveData(
      key: CacheKeys.statisticsDaily,
      value: jsonEncode(daily.toJson()),
    );
  }

  Future<LifetimeStatistics?> getLifetimeStatistics() async {
    final String? jsonStr = _cacheHelper.getData(key: CacheKeys.statisticsLifetime);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final Map<String, dynamic> json = jsonDecode(jsonStr);
        return LifetimeStatistics.fromJson(json);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<bool> saveLifetimeStatistics(LifetimeStatistics lifetime) async {
    return await _cacheHelper.saveData(
      key: CacheKeys.statisticsLifetime,
      value: jsonEncode(lifetime.toJson()),
    );
  }

  String? getLastOpenDate() {
    return _cacheHelper.getData(key: CacheKeys.statisticsLastOpenDate);
  }

  Future<bool> saveLastOpenDate(String date) async {
    return await _cacheHelper.saveData(
      key: CacheKeys.statisticsLastOpenDate,
      value: date,
    );
  }
}

import 'dart:convert';
import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';
import '../model/tasbeeh_monthly_stats_model.dart';

class TasbeehStatisticsDatasource {
  final CacheHelper _cacheHelper = CacheHelper();

  Future<Map<String, TasbeehMonthlyStats>> getMonthlyStats() async {
    final String? jsonStr = _cacheHelper.getData(key: CacheKeys.tasbeehMonthlyStats);
    if (jsonStr != null && jsonStr.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonStr);
        final Map<String, TasbeehMonthlyStats> result = {};
        decoded.forEach((key, value) {
          result[key] = TasbeehMonthlyStats.fromJson(value as Map<String, dynamic>);
        });
        return result;
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  Future<bool> saveMonthlyStats(Map<String, TasbeehMonthlyStats> stats) async {
    final Map<String, dynamic> jsonMap = {};
    stats.forEach((key, value) {
      jsonMap[key] = value.toJson();
    });
    return await _cacheHelper.saveData(
      key: CacheKeys.tasbeehMonthlyStats,
      value: jsonEncode(jsonMap),
    );
  }
}

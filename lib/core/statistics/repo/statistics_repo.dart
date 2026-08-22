import '../models/user_statistics_model.dart';

abstract class StatisticsRepo {
  Future<DailyStatistics?> getDailyStatistics();
  Future<bool> saveDailyStatistics(DailyStatistics daily);
  Future<LifetimeStatistics?> getLifetimeStatistics();
  Future<bool> saveLifetimeStatistics(LifetimeStatistics lifetime);
  String? getLastOpenDate();
  Future<bool> saveLastOpenDate(String date);
}

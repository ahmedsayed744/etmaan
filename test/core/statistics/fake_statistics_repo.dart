// A fake implementation of StatisticsRepo for testing — no SharedPreferences needed.
import 'package:etmaan/core/statistics/models/user_statistics_model.dart';
import 'package:etmaan/core/statistics/repo/statistics_repo.dart';

class FakeStatisticsRepo implements StatisticsRepo {
  DailyStatistics? _daily;
  LifetimeStatistics? _lifetime;
  String? _lastOpenDate;

  // Pre-seed values for tests that need to simulate a persisted state.
  void seed({
    DailyStatistics? daily,
    LifetimeStatistics? lifetime,
    String? lastOpenDate,
  }) {
    _daily = daily;
    _lifetime = lifetime;
    _lastOpenDate = lastOpenDate;
  }

  @override
  Future<DailyStatistics?> getDailyStatistics() async => _daily;

  @override
  Future<bool> saveDailyStatistics(DailyStatistics daily) async {
    _daily = daily;
    return true;
  }

  @override
  Future<LifetimeStatistics?> getLifetimeStatistics() async => _lifetime;

  @override
  Future<bool> saveLifetimeStatistics(LifetimeStatistics lifetime) async {
    _lifetime = lifetime;
    return true;
  }

  @override
  String? getLastOpenDate() => _lastOpenDate;

  @override
  Future<bool> saveLastOpenDate(String date) async {
    _lastOpenDate = date;
    return true;
  }
}

import '../datasource/statistics_local_datasource.dart';
import '../models/user_statistics_model.dart';
import 'statistics_repo.dart';

class StatisticsRepoImp implements StatisticsRepo {
  final StatisticsLocalDataSource _dataSource;

  StatisticsRepoImp(this._dataSource);

  @override
  Future<DailyStatistics?> getDailyStatistics() {
    return _dataSource.getDailyStatistics();
  }

  @override
  Future<bool> saveDailyStatistics(DailyStatistics daily) {
    return _dataSource.saveDailyStatistics(daily);
  }

  @override
  Future<LifetimeStatistics?> getLifetimeStatistics() {
    return _dataSource.getLifetimeStatistics();
  }

  @override
  Future<bool> saveLifetimeStatistics(LifetimeStatistics lifetime) {
    return _dataSource.saveLifetimeStatistics(lifetime);
  }

  @override
  String? getLastOpenDate() {
    return _dataSource.getLastOpenDate();
  }

  @override
  Future<bool> saveLastOpenDate(String date) {
    return _dataSource.saveLastOpenDate(date);
  }
}

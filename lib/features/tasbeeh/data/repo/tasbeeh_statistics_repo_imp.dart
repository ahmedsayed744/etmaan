import '../datasource/tasbeeh_statistics_datasource.dart';
import '../model/tasbeeh_monthly_stats_model.dart';
import 'tasbeeh_statistics_repo.dart';

class TasbeehStatisticsRepoImp implements TasbeehStatisticsRepo {
  final TasbeehStatisticsDatasource _datasource;

  TasbeehStatisticsRepoImp(this._datasource);

  @override
  Future<Map<String, TasbeehMonthlyStats>> getMonthlyStats() {
    return _datasource.getMonthlyStats();
  }

  @override
  Future<bool> saveMonthlyStats(Map<String, TasbeehMonthlyStats> stats) {
    return _datasource.saveMonthlyStats(stats);
  }
}

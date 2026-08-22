import '../model/tasbeeh_monthly_stats_model.dart';

abstract class TasbeehStatisticsRepo {
  Future<Map<String, TasbeehMonthlyStats>> getMonthlyStats();
  Future<bool> saveMonthlyStats(Map<String, TasbeehMonthlyStats> stats);
}

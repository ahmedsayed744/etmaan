import '../../data/model/tasbeeh_monthly_stats_model.dart';

abstract class TasbeehStatisticsState {
  const TasbeehStatisticsState();
}

class TasbeehStatisticsLoading extends TasbeehStatisticsState {
  const TasbeehStatisticsLoading();
}

class TasbeehStatisticsEmpty extends TasbeehStatisticsState {
  const TasbeehStatisticsEmpty();
}

class TasbeehStatisticsLoaded extends TasbeehStatisticsState {
  final List<TasbeehMonthlyStats> months;
  final TasbeehMonthlyStats? selectedMonth;

  const TasbeehStatisticsLoaded({
    required this.months,
    this.selectedMonth,
  });
}

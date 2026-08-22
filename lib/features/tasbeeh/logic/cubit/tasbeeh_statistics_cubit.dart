import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/tasbeeh_monthly_stats_model.dart';
import '../../data/repo/tasbeeh_statistics_repo.dart';
import 'tasbeeh_statistics_state.dart';

class TasbeehStatisticsCubit extends Cubit<TasbeehStatisticsState> {
  final TasbeehStatisticsRepo _repo;
  Map<String, TasbeehMonthlyStats> _allStats = {};

  TasbeehStatisticsCubit(this._repo) : super(const TasbeehStatisticsLoading());

  static String _getCurrentMonthKey() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }

  Future<void> initializeStatistics() async {
    emit(const TasbeehStatisticsLoading());
    try {
      _allStats = await _repo.getMonthlyStats();
      _emitLoaded();
    } catch (e) {
      _allStats = {};
      emit(const TasbeehStatisticsEmpty());
    }
  }

  void recordDhikr(int dhikrIndex) {
    if (dhikrIndex < 0 || dhikrIndex > 4) return;

    final monthKey = _getCurrentMonthKey();
    TasbeehMonthlyStats currentMonth = _allStats[monthKey] ?? TasbeehMonthlyStats(monthKey: monthKey);

    switch (dhikrIndex) {
      case 0:
        currentMonth = currentMonth.copyWith(subhanAllah: currentMonth.subhanAllah + 1);
        break;
      case 1:
        currentMonth = currentMonth.copyWith(alhamdulillah: currentMonth.alhamdulillah + 1);
        break;
      case 2:
        currentMonth = currentMonth.copyWith(allahuAkbar: currentMonth.allahuAkbar + 1);
        break;
      case 3:
        currentMonth = currentMonth.copyWith(laIlahaIllallah: currentMonth.laIlahaIllallah + 1);
        break;
      case 4:
        currentMonth = currentMonth.copyWith(astaghfirullah: currentMonth.astaghfirullah + 1);
        break;
    }

    _allStats[monthKey] = currentMonth;
    
    // Save locally
    _repo.saveMonthlyStats(_allStats);

    _emitLoaded();
  }

  void selectMonth(String monthKey) {
    if (state is TasbeehStatisticsLoaded) {
      final currentState = state as TasbeehStatisticsLoaded;
      emit(TasbeehStatisticsLoaded(
        months: currentState.months,
        selectedMonth: _allStats[monthKey],
      ));
    }
  }
  
  void clearSelection() {
    if (state is TasbeehStatisticsLoaded) {
      final currentState = state as TasbeehStatisticsLoaded;
      emit(TasbeehStatisticsLoaded(
        months: currentState.months,
        selectedMonth: null,
      ));
    }
  }

  void _emitLoaded() {
    if (_allStats.isEmpty) {
      emit(const TasbeehStatisticsEmpty());
      return;
    }

    final sortedMonths = _allStats.values.toList()
      ..sort((a, b) => b.monthKey.compareTo(a.monthKey)); // Descending order (newest first)

    final currentState = state;
    TasbeehMonthlyStats? selected;

    if (currentState is TasbeehStatisticsLoaded && currentState.selectedMonth != null) {
      // Keep selection updated with new counts if applicable
      selected = _allStats[currentState.selectedMonth!.monthKey];
    }

    emit(TasbeehStatisticsLoaded(
      months: sortedMonths,
      selectedMonth: selected,
    ));
  }
}

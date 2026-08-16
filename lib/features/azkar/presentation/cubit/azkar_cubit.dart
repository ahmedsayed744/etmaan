import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/azkar_repo.dart';
import 'azkar_state.dart';

class AzkarCubit extends Cubit<AzkarState> {
  final AzkarRepo repo;

  AzkarCubit(this.repo , )
      : super(const AzkarInitial());

  Future<void> loadAzkar(String jsonPath) async {
    try {
      emit(const AzkarLoading());

      final azkar = await repo.getAzkar(jsonPath);

      final counters = <int, int>{};

      for (final item in azkar) {
        counters[item.id] = 0;
      }

      emit(
        AzkarLoaded(
          azkar: azkar,
          counters: counters,
        ),
      );
    } catch (e) {
      emit(
        AzkarError(
          e.toString(),
        ),
      );
    }
  }

  void increment(int id) {
    final currentState = state;

    if (currentState is! AzkarLoaded) {
      return;
    }

    final item = currentState.azkar.firstWhere(
      (element) => element.id == id,
    );

    final currentCount =
        currentState.counters[id] ?? 0;

    if (currentCount >= item.count) {
      return;
    }

    final updatedCounters =
        Map<int, int>.from(
      currentState.counters,
    );

    updatedCounters[id] = currentCount + 1;

    emit(
      currentState.copyWith(
        counters: updatedCounters,
      ),
    );
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

    emit(
      currentState.copyWith(
        counters: counters,
      ),
    );
  }
}
import '../../data/models/azkar_model.dart';

abstract class AzkarState {
  const AzkarState();
}

class AzkarInitial extends AzkarState {
  const AzkarInitial();
}

class AzkarLoading extends AzkarState {
  const AzkarLoading();
}

class AzkarLoaded extends AzkarState {
  final List<AzkarModel> azkar;
  final Map<int, int> counters;

  const AzkarLoaded({
    required this.azkar,
    required this.counters,
  });

  int get completedCount {
    return azkar.where((item) {
      return (counters[item.id] ?? 0) >= item.count;
    }).length;
  }

  double get progress {
    if (azkar.isEmpty) return 0;

    return completedCount / azkar.length;
  }

  AzkarLoaded copyWith({
    List<AzkarModel>? azkar,
    Map<int, int>? counters,
  }) {
    return AzkarLoaded(
      azkar: azkar ?? this.azkar,
      counters: counters ?? this.counters,
    );
  }
}

class AzkarError extends AzkarState {
  final String message;

  const AzkarError(this.message);
}
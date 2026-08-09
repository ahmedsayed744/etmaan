import '../../data/model/tasbeeh_model.dart';

sealed class TasbeehState {
  const TasbeehState();
}

class TasbeehInitial extends TasbeehState {
  const TasbeehInitial();
}

class TasbeehUpdated extends TasbeehState {
  final List<TasbeehModel> tasbeehList;
  final int selectedIndex;
  final int count;

  const TasbeehUpdated({
    required this.tasbeehList,
    required this.selectedIndex,
    required this.count,
  });

  TasbeehModel get currentTasbeeh => tasbeehList[selectedIndex];

  int get target => currentTasbeeh.target;

  double get progress {
    if (target == 0) return 0;

    return count / target;
  }

  int get percentage {
    return (progress * 100).round();
  }
}
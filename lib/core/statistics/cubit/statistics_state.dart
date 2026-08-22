import '../models/user_statistics_model.dart';

abstract class StatisticsState {
  const StatisticsState();
}

class StatisticsInitial extends StatisticsState {
  const StatisticsInitial();
}

class StatisticsLoading extends StatisticsState {
  const StatisticsLoading();
}

class StatisticsLoaded extends StatisticsState {
  final DailyStatistics daily;
  final LifetimeStatistics lifetime;

  const StatisticsLoaded({
    required this.daily,
    required this.lifetime,
  });
}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);
}

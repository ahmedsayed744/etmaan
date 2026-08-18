import '../../data/models/location_model.dart';
import '../../data/models/prayer_time_model.dart';
import '../../data/models/qibla_model.dart';

enum PrayerStatus {
  initial,
  loading,
  success,
  error,
}

class PrayerState {
  final PrayerStatus status;
  final LocationModel? location;
  final List<PrayerTimeModel> prayerTimes;
  final PrayerTimeModel? nextPrayer;
  final QiblaModel? qibla;
  final double? compassHeading;
  final Duration remaining;
  final String? errorMessage;

  const PrayerState({
    this.status = PrayerStatus.initial,
    this.location,
    this.prayerTimes = const [],
    this.nextPrayer,
    this.qibla,
    this.compassHeading,
    this.remaining = Duration.zero,
    this.errorMessage,
  });

  PrayerState copyWith({
    PrayerStatus? status,
    LocationModel? location,
    List<PrayerTimeModel>? prayerTimes,
    PrayerTimeModel? nextPrayer,
    QiblaModel? qibla,
    double? compassHeading,
    Duration? remaining,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PrayerState(
      status: status ?? this.status,
      location: location ?? this.location,
      prayerTimes:
          prayerTimes ?? this.prayerTimes,
      nextPrayer:
          nextPrayer ?? this.nextPrayer,
      qibla: qibla ?? this.qibla,
      compassHeading:
          compassHeading ?? this.compassHeading,
      remaining:
          remaining ?? this.remaining,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
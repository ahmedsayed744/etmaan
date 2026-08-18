import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../../data/models/prayer_time_model.dart';
import '../../data/repo/prayer_repo.dart';
import 'prayer_state.dart';

class PrayerCubit extends Cubit<PrayerState> {
  final PrayerRepo repo;

  StreamSubscription<CompassEvent>?
      _compassSubscription;

  Timer? _countdownTimer;

  PrayerCubit(this.repo)
      : super(const PrayerState());

  Future<void> initialize() async {
    try {
      emit(
        state.copyWith(
          status: PrayerStatus.loading,
          clearError: true,
        ),
      );

      final location =
          await repo.getLocation();

      final prayerTimes =
          repo.getPrayerTimes(location);

      final qibla =
          repo.getQibla(location);

      emit(
        state.copyWith(
          status: PrayerStatus.success,
          location: location,
          prayerTimes: prayerTimes,
          qibla: qibla,
          clearError: true,
        ),
      );

      _updateNextPrayer();

      _startCountdown();

      _startCompass();
    } catch (e) {
      emit(
        state.copyWith(
          status: PrayerStatus.error,
          errorMessage: _cleanError(e),
        ),
      );
    }
  }

  void _updateNextPrayer() {
    if (state.prayerTimes.isEmpty ||
        state.location == null) {
      return;
    }

    final now = DateTime.now();

    final upcoming = state.prayerTimes.where(
      (prayer) =>
          prayer.type != PrayerType.sunrise &&
          prayer.time.isAfter(now),
    );

    if (upcoming.isNotEmpty) {
      final next = upcoming.first;

      emit(
        state.copyWith(
          nextPrayer: next,
          remaining:
              next.time.difference(now),
        ),
      );

      return;
    }

    final tomorrowFajr =
        repo.getTomorrowFajr(
      state.location!,
    );

    final fajr = PrayerTimeModel(
      type: PrayerType.fajr,
      name: 'الفجر',
      time: tomorrowFajr,
    );

    emit(
      state.copyWith(
        nextPrayer: fajr,
        remaining:
            tomorrowFajr.difference(now),
      ),
    );
  }

  void _startCountdown() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final next =
            state.nextPrayer;

        if (next == null) {
          return;
        }

        final now = DateTime.now();

        final remaining =
            next.time.difference(now);

        if (remaining.inSeconds <= 0) {
          _updateNextPrayer();
          return;
        }

        emit(
          state.copyWith(
            remaining: remaining,
          ),
        );
      },
    );
  }

  void _startCompass() {
    _compassSubscription?.cancel();

    _compassSubscription =
        FlutterCompass.events?.listen(
      (event) {
        final heading = event.heading;

        if (heading == null) {
          return;
        }

        emit(
          state.copyWith(
            compassHeading: heading,
          ),
        );
      },
    );
  }

  String get formattedRemaining {
    final duration = state.remaining;

    final hours = duration.inHours
        .toString()
        .padLeft(2, '0');

    final minutes =
        (duration.inMinutes % 60)
            .toString()
            .padLeft(2, '0');

    final seconds =
        (duration.inSeconds % 60)
            .toString()
            .padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }

  double get qiblaRelativeAngle {
    final qiblaDirection =
        state.qibla?.direction;

    final heading =
        state.compassHeading;

    if (qiblaDirection == null ||
        heading == null) {
      return 0;
    }

    var angle =
        qiblaDirection - heading;

    while (angle > 180) {
      angle -= 360;
    }

    while (angle < -180) {
      angle += 360;
    }

    return angle;
  }

  String _cleanError(Object error) {
    final message = error
        .toString()
        .replaceFirst('Exception: ', '');

    return message;
  }

  @override
  Future<void> close() async {
    await _compassSubscription?.cancel();
    _countdownTimer?.cancel();

    return super.close();
  }
}
import 'package:bloc_test/bloc_test.dart';
import 'package:etmaan/features/prayer/data/models/location_model.dart';
import 'package:etmaan/features/prayer/data/models/prayer_time_model.dart';
import 'package:etmaan/features/prayer/data/models/qibla_model.dart';
import 'package:etmaan/features/prayer/data/repo/prayer_repo.dart';
import 'package:etmaan/features/prayer/presentation/cubit/prayer_cubit.dart';
import 'package:etmaan/features/prayer/presentation/cubit/prayer_state.dart';
import 'package:flutter_test/flutter_test.dart';

// ──────────────────────────────────────────────────
// Fake PrayerRepo
// ──────────────────────────────────────────────────

class _FakePrayerRepo implements PrayerRepo {
  final LocationModel location;
  final List<PrayerTimeModel> prayers;
  final QiblaModel qibla;

  _FakePrayerRepo({
    required this.location,
    required this.prayers,
    required this.qibla,
  });

  @override
  Future<LocationModel> getLocation() async => location;

  @override
  List<PrayerTimeModel> getPrayerTimes(LocationModel loc) => prayers;

  @override
  List<PrayerTimeModel> getPrayerTimesForDate(LocationModel loc, DateTime date) =>
      prayers;

  @override
  DateTime getTomorrowFajr(LocationModel loc) =>
      DateTime.now().add(const Duration(hours: 20));

  @override
  QiblaModel getQibla(LocationModel loc) => qibla;
}

class _ThrowingPrayerRepo implements PrayerRepo {
  @override
  Future<LocationModel> getLocation() async =>
      throw Exception('GPS not available');

  @override
  List<PrayerTimeModel> getPrayerTimes(LocationModel loc) => [];

  @override
  List<PrayerTimeModel> getPrayerTimesForDate(LocationModel loc, DateTime date) =>
      [];

  @override
  DateTime getTomorrowFajr(LocationModel loc) =>
      DateTime.now().add(const Duration(hours: 20));

  @override
  QiblaModel getQibla(LocationModel loc) =>
      const QiblaModel(direction: 135);
}

// ──────────────────────────────────────────────────
// Helpers
// ──────────────────────────────────────────────────

final _location = const LocationModel(
  latitude: 30.0444,
  longitude: 31.2357,
  city: 'Cairo',
  country: 'Egypt',
);

List<PrayerTimeModel> _fakePrayers({int hoursFromNow = 2}) {
  final now = DateTime.now();
  return [
    PrayerTimeModel(
        type: PrayerType.fajr,
        name: 'الفجر',
        time: now.subtract(const Duration(hours: 10))),
    PrayerTimeModel(
        type: PrayerType.sunrise,
        name: 'الشروق',
        time: now.subtract(const Duration(hours: 8))),
    PrayerTimeModel(
        type: PrayerType.dhuhr,
        name: 'الظهر',
        time: now.subtract(const Duration(hours: 4))),
    PrayerTimeModel(
        type: PrayerType.asr,
        name: 'العصر',
        time: now.subtract(const Duration(hours: 1))),
    PrayerTimeModel(
        type: PrayerType.maghrib,
        name: 'المغرب',
        time: now.add(Duration(hours: hoursFromNow))),
    PrayerTimeModel(
        type: PrayerType.isha,
        name: 'العشاء',
        time: now.add(Duration(hours: hoursFromNow + 2))),
  ];
}

void main() {
  group('PrayerCubit', () {
    late _FakePrayerRepo repo;

    setUp(() {
      repo = _FakePrayerRepo(
        location: _location,
        prayers: _fakePrayers(),
        qibla: const QiblaModel(direction: 135.0),
      );
    });

    // ──────────────────────────────────────────────────
    // Initial state
    // ──────────────────────────────────────────────────

    test('initial state is PrayerStatus.initial', () {
      final cubit = PrayerCubit(repo, compassStream: const Stream.empty());
      expect(cubit.state.status, PrayerStatus.initial);
      cubit.close();
    });

    // ──────────────────────────────────────────────────
    // Success flow
    // ──────────────────────────────────────────────────

    blocTest<PrayerCubit, PrayerState>(
      'initialize() emits loading then success with location and prayers',
      build: () => PrayerCubit(repo, compassStream: const Stream.empty()),
      act: (c) => c.initialize(),
      expect: () => [
        predicate<PrayerState>((s) => s.status == PrayerStatus.loading),
        predicate<PrayerState>((s) => s.status == PrayerStatus.success),
        predicate<PrayerState>((s) => s.status == PrayerStatus.success && s.nextPrayer != null),
      ],
      verify: (c) {
        expect(c.state.location?.city, 'Cairo');
        expect(c.state.prayerTimes.length, 6);
        expect(c.state.qibla?.direction, closeTo(135, 0.1));
        expect(c.state.nextPrayer, isNotNull);
      },
    );

    // ──────────────────────────────────────────────────
    // Next prayer identification (Maghrib is next in fake data)
    // ──────────────────────────────────────────────────

    blocTest<PrayerCubit, PrayerState>(
      'initialize() picks the next upcoming prayer (Maghrib)',
      build: () => PrayerCubit(repo, compassStream: const Stream.empty()),
      act: (c) => c.initialize(),
      verify: (c) {
        expect(c.state.nextPrayer?.type, PrayerType.maghrib);
      },
    );

    // ──────────────────────────────────────────────────
    // Error flow (GPS unavailable)
    // ──────────────────────────────────────────────────

    blocTest<PrayerCubit, PrayerState>(
      'initialize() emits error state when getLocation throws',
      build: () => PrayerCubit(_ThrowingPrayerRepo(), compassStream: const Stream.empty()),
      act: (c) => c.initialize(),
      verify: (c) {
        expect(c.state.status, PrayerStatus.error);
        expect(c.state.errorMessage, isNotNull);
      },
    );

    // ──────────────────────────────────────────────────
    // formattedRemaining
    // ──────────────────────────────────────────────────

    test('formattedRemaining formats correctly for zero duration', () {
      final cubit = PrayerCubit(repo, compassStream: const Stream.empty());
      // State defaults to Duration.zero
      expect(cubit.formattedRemaining, '00:00:00');
      cubit.close();
    });

    // ──────────────────────────────────────────────────
    // qiblaRelativeAngle – null safety
    // ──────────────────────────────────────────────────

    test('qiblaRelativeAngle returns 0 when qibla or heading is null', () {
      final cubit = PrayerCubit(repo, compassStream: const Stream.empty());
      // Initial state has no qibla or heading
      expect(cubit.qiblaRelativeAngle, 0.0);
      cubit.close();
    });
  });
}

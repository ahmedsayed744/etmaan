import 'package:bloc_test/bloc_test.dart';
import 'package:etmaan/core/statistics/cubit/statistics_cubit.dart';
import 'package:etmaan/core/statistics/cubit/statistics_state.dart';
import 'package:etmaan/core/statistics/models/user_statistics_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_statistics_repo.dart';

// Helper: today's date string in the same format as StatisticsCubit.
String _today() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

void main() {
  // StatisticsCubit uses WidgetsBindingObserver so the binding must be ready.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('StatisticsCubit', () {
    late FakeStatisticsRepo repo;

    setUp(() {
      repo = FakeStatisticsRepo();
    });

    // ──────────────────────────────────────────────────
    // Initialization – fresh start
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'initialize() with empty cache emits StatisticsLoaded with zeroed daily stats',
      build: () => StatisticsCubit(repo),
      act: (cubit) => cubit.initialize(),
      expect: () => [
        isA<StatisticsLoading>(),
        isA<StatisticsLoaded>(),
      ],
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        expect(state.daily.quranPages, 0);
        expect(state.daily.tasbeehCount, 0);
        expect(state.daily.quranHizb, 0);
        expect(state.lifetime.activeDays, 1); // first open → active day
      },
    );

    // ──────────────────────────────────────────────────
    // Initialization – existing data, same day
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'initialize() with existing same-day data restores it',
      build: () {
        repo.seed(
          daily: DailyStatistics(
            date: _today(),
            tasbeehCount: 5,
            quranPages: 3,
          ),
          lifetime: LifetimeStatistics(totalTasbeeh: 5, activeDays: 1),
          lastOpenDate: _today(),
        );
        return StatisticsCubit(repo);
      },
      act: (cubit) => cubit.initialize(),
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        expect(state.daily.tasbeehCount, 5);
        expect(state.daily.quranPages, 3);
        expect(state.lifetime.totalTasbeeh, 5);
      },
    );

    // ──────────────────────────────────────────────────
    // Daily Reset on new day
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'initialize() on a new calendar day resets daily stats',
      build: () {
        repo.seed(
          daily: DailyStatistics(
            date: '2000-01-01', // old date
            tasbeehCount: 99,
            quranPages: 7,
          ),
          lifetime: LifetimeStatistics(totalTasbeeh: 99, activeDays: 10),
          lastOpenDate: '2000-01-01',
        );
        return StatisticsCubit(repo);
      },
      act: (cubit) => cubit.initialize(),
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        // Daily must be reset to zero
        expect(state.daily.tasbeehCount, 0);
        expect(state.daily.quranPages, 0);
        expect(state.daily.date, equals(_today()));
        // Active days must have incremented
        expect(state.lifetime.activeDays, 11);
      },
    );

    // ──────────────────────────────────────────────────
    // incrementTasbeeh
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'incrementTasbeeh increments daily tasbeehCount and lifetime total',
      build: () => StatisticsCubit(repo),
      act: (cubit) async {
        await cubit.initialize();
        cubit.incrementTasbeeh();
        cubit.incrementTasbeeh();
      },
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        expect(state.daily.tasbeehCount, 2);
        expect(state.lifetime.totalTasbeeh, 2);
      },
    );

    // ──────────────────────────────────────────────────
    // trackQuranPage – normal increment
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'trackQuranPage increments quranPages for a new page',
      build: () => StatisticsCubit(repo),
      act: (cubit) async {
        await cubit.initialize();
        cubit.trackQuranPage(5);
      },
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        expect(state.daily.quranPages, 1);
        expect(state.lifetime.totalQuranPages, 1);
      },
    );

    // ──────────────────────────────────────────────────
    // trackQuranPage – duplicate prevention
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'trackQuranPage does NOT double-count the same page in a session',
      build: () => StatisticsCubit(repo),
      act: (cubit) async {
        await cubit.initialize();
        cubit.trackQuranPage(5);
        cubit.trackQuranPage(5); // same page — must be ignored
        cubit.trackQuranPage(5); // same page again — must be ignored
      },
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        expect(state.daily.quranPages, 1);
      },
    );

    // ──────────────────────────────────────────────────
    // trackQuranPage – multiple distinct pages
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'trackQuranPage counts each distinct page once',
      build: () => StatisticsCubit(repo),
      act: (cubit) async {
        await cubit.initialize();
        for (var page = 1; page <= 10; page++) {
          cubit.trackQuranPage(page);
        }
      },
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        expect(state.daily.quranPages, 10);
      },
    );

    // ──────────────────────────────────────────────────
    // incrementQuranHizb
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'incrementQuranHizb increments hizb counters',
      build: () => StatisticsCubit(repo),
      act: (cubit) async {
        await cubit.initialize();
        cubit.incrementQuranHizb();
        cubit.incrementQuranHizb();
      },
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        expect(state.daily.quranHizb, 2);
        expect(state.lifetime.totalQuranHizb, 2);
      },
    );

    // ──────────────────────────────────────────────────
    // Active days – no double counting on same day re-open
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'initialize() on the SAME day does NOT increment activeDays again',
      build: () {
        repo.seed(
          daily: DailyStatistics(date: _today()),
          lifetime: LifetimeStatistics(activeDays: 5),
          lastOpenDate: _today(),
        );
        return StatisticsCubit(repo);
      },
      act: (cubit) => cubit.initialize(),
      verify: (cubit) {
        final state = cubit.state as StatisticsLoaded;
        expect(state.lifetime.activeDays, 5); // unchanged
      },
    );

    // ──────────────────────────────────────────────────
    // Error state
    // ──────────────────────────────────────────────────

    blocTest<StatisticsCubit, StatisticsState>(
      'initialize() emits StatisticsError when repo throws',
      build: () {
        final errorRepo = _ThrowingRepo();
        return StatisticsCubit(errorRepo);
      },
      act: (cubit) => cubit.initialize(),
      expect: () => [
        isA<StatisticsLoading>(),
        isA<StatisticsError>(),
      ],
    );
  });

  // ──────────────────────────────────────────────────
  // DailyStatistics model
  // ──────────────────────────────────────────────────

  group('DailyStatistics model', () {
    test('fromJson parses correctly', () {
      final json = {
        'date': '2025-01-01',
        'tasbeehCount': 10,
        'quranPages': 5,
        'quranHizb': 2,
        'sessionSeconds': 300,
      };
      final model = DailyStatistics.fromJson(json);
      expect(model.date, '2025-01-01');
      expect(model.tasbeehCount, 10);
      expect(model.quranPages, 5);
    });

    test('fromJson uses defaults for missing fields', () {
      final json = {'date': '2025-01-01'};
      final model = DailyStatistics.fromJson(json);
      expect(model.tasbeehCount, 0);
      expect(model.quranPages, 0);
    });

    test('toJson round-trips correctly', () {
      final model = DailyStatistics(
        date: '2025-06-15',
        tasbeehCount: 7,
        quranPages: 4,
        quranHizb: 1,
        sessionSeconds: 120,
      );
      final json = model.toJson();
      final restored = DailyStatistics.fromJson(json);
      expect(restored.date, model.date);
      expect(restored.tasbeehCount, model.tasbeehCount);
      expect(restored.quranPages, model.quranPages);
    });

    test('copyWith updates specific fields only', () {
      final original = DailyStatistics(
        date: '2025-01-01',
        tasbeehCount: 3,
        quranPages: 2,
      );
      final updated = original.copyWith(tasbeehCount: 99);
      expect(updated.tasbeehCount, 99);
      expect(updated.quranPages, 2); // unchanged
    });
  });

  // ──────────────────────────────────────────────────
  // LifetimeStatistics model
  // ──────────────────────────────────────────────────

  group('LifetimeStatistics model', () {
    test('fromJson parses correctly', () {
      final json = {
        'totalTasbeeh': 100,
        'totalQuranPages': 50,
        'totalQuranHizb': 10,
        'activeDays': 30,
        'totalSessionSeconds': 7200,
      };
      final model = LifetimeStatistics.fromJson(json);
      expect(model.totalTasbeeh, 100);
      expect(model.activeDays, 30);
    });

    test('fromJson uses defaults for missing fields', () {
      final model = LifetimeStatistics.fromJson({});
      expect(model.totalTasbeeh, 0);
      expect(model.activeDays, 0);
    });

    test('toJson round-trips correctly', () {
      final model = LifetimeStatistics(
        totalTasbeeh: 200,
        totalQuranPages: 100,
        activeDays: 60,
      );
      final restored = LifetimeStatistics.fromJson(model.toJson());
      expect(restored.totalTasbeeh, 200);
      expect(restored.activeDays, 60);
    });
  });
}

// ──────────────────────────────────────────────────
// Helper: repo that always throws (for error-state test)
// ──────────────────────────────────────────────────

class _ThrowingRepo extends FakeStatisticsRepo {
  @override
  Future<DailyStatistics?> getDailyStatistics() async {
    throw Exception('disk error');
  }
}

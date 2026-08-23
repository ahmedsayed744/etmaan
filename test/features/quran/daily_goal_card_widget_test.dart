import 'package:etmaan/core/statistics/cubit/statistics_cubit.dart';
import 'package:etmaan/core/statistics/cubit/statistics_state.dart';
import 'package:etmaan/core/statistics/models/user_statistics_model.dart';
import 'package:etmaan/core/statistics/repo/statistics_repo.dart';
import 'package:etmaan/core/theme/app_theme.dart';
import 'package:etmaan/features/quran/presentation/widget/daily_goal_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

// ──────────────────────────────────────────────────
// In-memory repo stub — no SharedPreferences
// ──────────────────────────────────────────────────

class _FakeRepo implements StatisticsRepo {
  @override
  Future<DailyStatistics?> getDailyStatistics() async => null;
  @override
  Future<bool> saveDailyStatistics(DailyStatistics d) async => true;
  @override
  Future<LifetimeStatistics?> getLifetimeStatistics() async => null;
  @override
  Future<bool> saveLifetimeStatistics(LifetimeStatistics l) async => true;
  @override
  String? getLastOpenDate() => null;
  @override
  Future<bool> saveLastOpenDate(String d) async => true;
}

// A cubit stub that emits a predetermined state immediately.
class _StubStatisticsCubit extends StatisticsCubit {
  final StatisticsState _initialState;
  _StubStatisticsCubit(this._initialState) : super(_FakeRepo()) {
    emit(_initialState);
  }
}

// ──────────────────────────────────────────────────
// Helpers
// ──────────────────────────────────────────────────

StatisticsLoaded _loadedWith(int pages) => StatisticsLoaded(
      daily: DailyStatistics(
        date: '2025-01-01',
        quranPages: pages,
      ),
      lifetime: LifetimeStatistics(),
    );

Widget _wrap(Widget child, {required StatisticsState state}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: BlocProvider<StatisticsCubit>(
        create: (_) => _StubStatisticsCubit(state),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

// ──────────────────────────────────────────────────
// Tests
// ──────────────────────────────────────────────────

void main() {
  group('DailyGoalCard widget', () {
    testWidgets('shows هدف اليوم label', (tester) async {
      await tester.pumpWidget(_wrap(const DailyGoalCard(), state: _loadedWith(0)));
      await tester.pump();
      expect(find.text('هدف اليوم'), findsOneWidget);
    });

    testWidgets('shows target pages "10 صفحات"', (tester) async {
      await tester.pumpWidget(_wrap(const DailyGoalCard(), state: _loadedWith(0)));
      await tester.pump();
      expect(find.text('10 صفحات'), findsOneWidget);
    });

    testWidgets('0 pages: shows 10 متبقية and 0 مكتملة and 0%', (tester) async {
      await tester.pumpWidget(_wrap(const DailyGoalCard(), state: _loadedWith(0)));
      await tester.pump();
      expect(find.text('10 متبقية'), findsOneWidget);
      expect(find.text('0 مكتملة'), findsOneWidget);
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('8 pages: shows 2 متبقية and 8 مكتملة and 80%', (tester) async {
      await tester.pumpWidget(_wrap(const DailyGoalCard(), state: _loadedWith(8)));
      await tester.pump();
      expect(find.text('2 متبقية'), findsOneWidget);
      expect(find.text('8 مكتملة'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
    });

    testWidgets('10 pages: shows 0 متبقية and 10 مكتملة and 100%', (tester) async {
      await tester.pumpWidget(_wrap(const DailyGoalCard(), state: _loadedWith(10)));
      await tester.pump();
      expect(find.text('0 متبقية'), findsOneWidget);
      expect(find.text('10 مكتملة'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('15 pages (over goal): shows 15 مكتملة and 0 متبقية and 100%', (tester) async {
      await tester.pumpWidget(_wrap(const DailyGoalCard(), state: _loadedWith(15)));
      await tester.pump();
      expect(find.text('0 متبقية'), findsOneWidget);
      expect(find.text('15 مكتملة'), findsOneWidget);
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(_wrap(const DailyGoalCard(), state: _loadedWith(5)));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows safe defaults in initial/loading state (0 pages)', (tester) async {
      await tester.pumpWidget(
        _wrap(const DailyGoalCard(), state: const StatisticsInitial()),
      );
      await tester.pump();
      expect(find.text('10 متبقية'), findsOneWidget);
      expect(find.text('0 مكتملة'), findsOneWidget);
    });
  });
}

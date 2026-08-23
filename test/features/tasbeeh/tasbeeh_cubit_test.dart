import 'package:bloc_test/bloc_test.dart';
import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_cubit.dart';
import 'package:etmaan/features/tasbeeh/logic/cubit/tasbeeh_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TasbeehCubit', () {
    late TasbeehCubit cubit;

    setUp(() {
      cubit = TasbeehCubit();
    });

    tearDown(() => cubit.close());

    // ──────────────────────────────────────────────────
    // Initial state
    // ──────────────────────────────────────────────────

    test('initial state is TasbeehUpdated with count 0 and index 0', () {
      final state = cubit.state as TasbeehUpdated;
      expect(state.count, 0);
      expect(state.selectedIndex, 0);
    });

    test('initial tasbeeh list has 5 items', () {
      final state = cubit.state as TasbeehUpdated;
      expect(state.tasbeehList.length, 5);
    });

    // ──────────────────────────────────────────────────
    // Increment
    // ──────────────────────────────────────────────────

    blocTest<TasbeehCubit, TasbeehState>(
      'increment increases count by 1',
      build: () => TasbeehCubit(),
      act: (c) => c.increment(),
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.count, 1);
      },
    );

    blocTest<TasbeehCubit, TasbeehState>(
      'increment stops at target (does not exceed it)',
      build: () => TasbeehCubit(),
      act: (c) {
        // First tasbeeh target is 33 — spam 100 taps
        for (var i = 0; i < 100; i++) {
          c.increment();
        }
      },
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.count, 33);
      },
    );

    // ──────────────────────────────────────────────────
    // Reset
    // ──────────────────────────────────────────────────

    blocTest<TasbeehCubit, TasbeehState>(
      'reset resets count to 0',
      build: () => TasbeehCubit(),
      act: (c) {
        c.increment();
        c.increment();
        c.reset();
      },
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.count, 0);
      },
    );

    // ──────────────────────────────────────────────────
    // Select
    // ──────────────────────────────────────────────────

    blocTest<TasbeehCubit, TasbeehState>(
      'selectTasbeeh switches to the requested index and resets count',
      build: () => TasbeehCubit(),
      act: (c) {
        c.increment(); // count = 1
        c.selectTasbeeh(2);
      },
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.selectedIndex, 2);
        expect(state.count, 0); // reset on switch
      },
    );

    blocTest<TasbeehCubit, TasbeehState>(
      'selectTasbeeh ignores out-of-bounds index',
      build: () => TasbeehCubit(),
      act: (c) {
        c.selectTasbeeh(99); // out of bounds
      },
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.selectedIndex, 0); // unchanged
      },
    );

    // ──────────────────────────────────────────────────
    // Navigation
    // ──────────────────────────────────────────────────

    blocTest<TasbeehCubit, TasbeehState>(
      'nextTasbeeh advances the index',
      build: () => TasbeehCubit(),
      act: (c) => c.nextTasbeeh(),
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.selectedIndex, 1);
      },
    );

    blocTest<TasbeehCubit, TasbeehState>(
      'nextTasbeeh wraps around to 0 at the end',
      build: () => TasbeehCubit(),
      act: (c) {
        c.selectTasbeeh(4); // last item
        c.nextTasbeeh();
      },
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.selectedIndex, 0);
      },
    );

    blocTest<TasbeehCubit, TasbeehState>(
      'previousTasbeeh decrements the index',
      build: () => TasbeehCubit(),
      act: (c) {
        c.selectTasbeeh(3);
        c.previousTasbeeh();
      },
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.selectedIndex, 2);
      },
    );

    blocTest<TasbeehCubit, TasbeehState>(
      'previousTasbeeh wraps around to last item from index 0',
      build: () => TasbeehCubit(),
      act: (c) => c.previousTasbeeh(),
      verify: (c) {
        final state = c.state as TasbeehUpdated;
        expect(state.selectedIndex, 4);
      },
    );

    // ──────────────────────────────────────────────────
    // Progress calculation
    // ──────────────────────────────────────────────────

    test('progress is 0 at start', () {
      final state = cubit.state as TasbeehUpdated;
      expect(state.progress, 0.0);
    });

    test('percentage is 0 at start', () {
      final state = cubit.state as TasbeehUpdated;
      expect(state.percentage, 0);
    });

    test('progress and percentage reflect count correctly after increments', () {
      final target = (cubit.state as TasbeehUpdated).target;
      for (var i = 0; i < target; i++) {
        cubit.increment();
      }
      final state = cubit.state as TasbeehUpdated;
      expect(state.progress, closeTo(1.0, 0.001));
      expect(state.percentage, 100);
    });
  });
}

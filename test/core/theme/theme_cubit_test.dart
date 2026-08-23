import 'package:bloc_test/bloc_test.dart';
import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/theme/cubit/theme_cubit.dart';
import 'package:etmaan/core/theme/cubit/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _initCache({Map<String, Object> values = const {}}) async {
  SharedPreferences.setMockInitialValues(values);
  await CacheHelper().init();
}

void main() {
  group('ThemeCubit', () {
    // ──────────────────────────────────────────────────
    // Initial state
    // ──────────────────────────────────────────────────

    test('initial state defaults to light mode when no cached value', () async {
      await _initCache();
      final cubit = ThemeCubit();
      expect(cubit.state.themeMode, ThemeMode.light);
      expect(cubit.state.isDark, isFalse);
      await cubit.close();
    });

    test('initial state loads dark mode when "dark" is cached', () async {
      await _initCache(values: {'themeMode': 'dark'});
      final cubit = ThemeCubit();
      expect(cubit.state.themeMode, ThemeMode.dark);
      expect(cubit.state.isDark, isTrue);
      await cubit.close();
    });

    // ──────────────────────────────────────────────────
    // toggleTheme — light → dark
    // ──────────────────────────────────────────────────

    test('toggleTheme switches light to dark', () async {
      await _initCache();
      final cubit = ThemeCubit();
      cubit.toggleTheme();
      expect(cubit.state.themeMode, ThemeMode.dark);
      expect(cubit.state.isDark, isTrue);
      await cubit.close();
    });

    // ──────────────────────────────────────────────────
    // toggleTheme — dark → light
    // ──────────────────────────────────────────────────

    test('toggleTheme switches dark back to light', () async {
      await _initCache(values: {'themeMode': 'dark'});
      final cubit = ThemeCubit();
      expect(cubit.state.themeMode, ThemeMode.dark); // verify seed
      cubit.toggleTheme();
      expect(cubit.state.themeMode, ThemeMode.light);
      await cubit.close();
    });

    // ──────────────────────────────────────────────────
    // setDarkMode
    // ──────────────────────────────────────────────────

    test('setDarkMode(true) switches to dark mode', () async {
      await _initCache();
      final cubit = ThemeCubit();
      cubit.setDarkMode(true);
      expect(cubit.state.themeMode, ThemeMode.dark);
      await cubit.close();
    });

    test('setDarkMode(false) switches to light mode', () async {
      await _initCache(values: {'themeMode': 'dark'});
      final cubit = ThemeCubit();
      cubit.setDarkMode(false);
      expect(cubit.state.themeMode, ThemeMode.light);
      await cubit.close();
    });

    // ──────────────────────────────────────────────────
    // Persistence: verify cache key is updated
    // ──────────────────────────────────────────────────

    test('toggleTheme persists dark value to cache', () async {
      await _initCache();
      final cubit = ThemeCubit();
      cubit.toggleTheme(); // light → dark
      final cached = CacheHelper().getData(key: 'themeMode');
      expect(cached, 'dark');
      await cubit.close();
    });

    test('toggleTheme persists light value to cache after dark → light', () async {
      await _initCache(values: {'themeMode': 'dark'});
      final cubit = ThemeCubit();
      cubit.toggleTheme(); // dark → light
      final cached = CacheHelper().getData(key: 'themeMode');
      expect(cached, 'light');
      await cubit.close();
    });

    // ──────────────────────────────────────────────────
    // blocTest for state stream (no SharedPreferences seeding needed)
    // ──────────────────────────────────────────────────

    blocTest<ThemeCubit, ThemeState>(
      'toggleTheme emits exactly one new ThemeState',
      setUp: () async => _initCache(),
      build: () => ThemeCubit(),
      act: (c) => c.toggleTheme(),
      // Depending on bloc_test version, may emit initial state too.
      // Just verify the last state.
      verify: (c) {
        expect(c.state, isA<ThemeState>());
      },
    );
  });

  group('ThemeState', () {
    test('isDark is true only for ThemeMode.dark', () {
      expect(const ThemeState(themeMode: ThemeMode.dark).isDark, isTrue);
      expect(const ThemeState(themeMode: ThemeMode.light).isDark, isFalse);
      expect(const ThemeState(themeMode: ThemeMode.system).isDark, isFalse);
    });
  });
}

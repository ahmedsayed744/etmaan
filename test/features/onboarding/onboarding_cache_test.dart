import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:etmaan/core/cache/cache_keys.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper().init();
  });

  group('Onboarding cache logic', () {
    // ──────────────────────────────────────────────────
    // First launch — no flag set
    // ──────────────────────────────────────────────────

    test('fresh install: isOnBoardingVisited is null → show onboarding', () {
      final value = CacheHelper().getData(key: CacheKeys.isOnBoardingVisited);
      expect(value == true, isFalse,
          reason: 'Onboarding must show when flag is null');
    });

    // ──────────────────────────────────────────────────
    // Explicit false stored
    // ──────────────────────────────────────────────────

    test('flag stored as false → still show onboarding', () async {
      await CacheHelper()
          .saveData(key: CacheKeys.isOnBoardingVisited, value: false);
      final value = CacheHelper().getData(key: CacheKeys.isOnBoardingVisited);
      expect(value == true, isFalse);
    });

    // ──────────────────────────────────────────────────
    // Completion — flag saved as true
    // ──────────────────────────────────────────────────

    test('after completing onboarding: flag is saved as true', () async {
      await CacheHelper()
          .saveData(key: CacheKeys.isOnBoardingVisited, value: true);
      final value = CacheHelper().getData(key: CacheKeys.isOnBoardingVisited);
      expect(value == true, isTrue,
          reason: 'Skip RootView onboarding when true');
    });

    // ──────────────────────────────────────────────────
    // Clear flag (for dev testing)
    // ──────────────────────────────────────────────────

    test('clearing onboarding flag makes it null again', () async {
      await CacheHelper()
          .saveData(key: CacheKeys.isOnBoardingVisited, value: true);
      await CacheHelper()
          .removeData(key: CacheKeys.isOnBoardingVisited);
      final value = CacheHelper().getData(key: CacheKeys.isOnBoardingVisited);
      expect(value == true, isFalse,
          reason: 'Onboarding should show again after flag is cleared');
    });

    // ──────────────────────────────────────────────────
    // Only boolean true should skip onboarding
    // ──────────────────────────────────────────────────

    test('storing string "true" does NOT skip onboarding (type safety)', () async {
      await CacheHelper()
          .saveData(key: CacheKeys.isOnBoardingVisited, value: 'true');
      final value = CacheHelper().getData(key: CacheKeys.isOnBoardingVisited);
      // 'true' != true (strict equality)
      expect(value == true, isFalse);
    });

    test('storing int 1 does NOT skip onboarding (type safety)', () async {
      await CacheHelper()
          .saveData(key: CacheKeys.isOnBoardingVisited, value: 1);
      final value = CacheHelper().getData(key: CacheKeys.isOnBoardingVisited);
      expect(value == true, isFalse);
    });
  });
}

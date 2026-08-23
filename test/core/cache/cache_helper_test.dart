import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:etmaan/core/cache/cache_helper.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper().init();
  });

  group('CacheHelper', () {
    // ──────────────────────────────────────────────────
    // Save & Get
    // ──────────────────────────────────────────────────

    test('saves and retrieves a String value', () async {
      await CacheHelper().saveData(key: 'testKey', value: 'hello');
      final result = CacheHelper().getData(key: 'testKey');
      expect(result, equals('hello'));
    });

    test('saves and retrieves an int value', () async {
      await CacheHelper().saveData(key: 'intKey', value: 42);
      final result = CacheHelper().getData(key: 'intKey');
      expect(result, equals(42));
    });

    test('saves and retrieves a bool value (true)', () async {
      await CacheHelper().saveData(key: 'boolKey', value: true);
      final result = CacheHelper().getData(key: 'boolKey');
      expect(result, equals(true));
    });

    test('saves and retrieves a bool value (false)', () async {
      await CacheHelper().saveData(key: 'boolKey', value: false);
      final result = CacheHelper().getData(key: 'boolKey');
      expect(result, equals(false));
    });

    test('saves and retrieves a double value', () async {
      await CacheHelper().saveData(key: 'doubleKey', value: 3.14);
      final result = CacheHelper().getData(key: 'doubleKey');
      expect(result, closeTo(3.14, 0.001));
    });

    // ──────────────────────────────────────────────────
    // Missing & Null
    // ──────────────────────────────────────────────────

    test('returns null for a missing key', () {
      final result = CacheHelper().getData(key: 'nonExistentKey');
      expect(result, isNull);
    });

    test('missing bool key does NOT equal true (onboarding safety check)', () {
      final result = CacheHelper().getData(key: 'isOnBoardingVisited');
      expect(result == true, isFalse);
    });

    // ──────────────────────────────────────────────────
    // Remove
    // ──────────────────────────────────────────────────

    test('removes a key successfully', () async {
      await CacheHelper().saveData(key: 'removeMe', value: 'value');
      final removed = await CacheHelper().removeData(key: 'removeMe');
      expect(removed, isTrue);
      expect(CacheHelper().getData(key: 'removeMe'), isNull);
    });

    test('removing a non-existent key returns true without error', () async {
      final result = await CacheHelper().removeData(key: 'doesNotExist');
      expect(result, isTrue);
    });

    // ──────────────────────────────────────────────────
    // Type errors
    // ──────────────────────────────────────────────────

    test('throws on unsupported type', () async {
      expect(
        () async => await CacheHelper().saveData(
          key: 'badType',
          value: <String>[],
        ),
        throwsException,
      );
    });

    // ──────────────────────────────────────────────────
    // Overwrite
    // ──────────────────────────────────────────────────

    test('overwriting a key with a new value updates the stored value',
        () async {
      await CacheHelper().saveData(key: 'overwrite', value: 'first');
      await CacheHelper().saveData(key: 'overwrite', value: 'second');
      expect(CacheHelper().getData(key: 'overwrite'), equals('second'));
    });
  });
}

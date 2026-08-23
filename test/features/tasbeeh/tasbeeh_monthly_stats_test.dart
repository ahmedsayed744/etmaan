import 'package:etmaan/features/tasbeeh/data/model/tasbeeh_monthly_stats_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TasbeehMonthlyStats', () {
    // ──────────────────────────────────────────────────
    // Construction & defaults
    // ──────────────────────────────────────────────────

    test('default values are all 0', () {
      final stats = TasbeehMonthlyStats(monthKey: '2025-01');
      expect(stats.subhanAllah, 0);
      expect(stats.alhamdulillah, 0);
      expect(stats.allahuAkbar, 0);
      expect(stats.laIlahaIllallah, 0);
      expect(stats.astaghfirullah, 0);
    });

    // ──────────────────────────────────────────────────
    // total getter
    // ──────────────────────────────────────────────────

    test('total is the sum of all dhikr counts', () {
      final stats = TasbeehMonthlyStats(
        monthKey: '2025-01',
        subhanAllah: 10,
        alhamdulillah: 5,
        allahuAkbar: 3,
        laIlahaIllallah: 2,
        astaghfirullah: 1,
      );
      expect(stats.total, 21);
    });

    test('total is 0 when everything is 0', () {
      final stats = TasbeehMonthlyStats(monthKey: '2025-01');
      expect(stats.total, 0);
    });

    // ──────────────────────────────────────────────────
    // copyWith
    // ──────────────────────────────────────────────────

    test('copyWith updates only specified fields', () {
      final original = TasbeehMonthlyStats(
        monthKey: '2025-01',
        subhanAllah: 5,
        alhamdulillah: 10,
      );
      final updated = original.copyWith(subhanAllah: 99);
      expect(updated.subhanAllah, 99);
      expect(updated.alhamdulillah, 10); // unchanged
    });

    // ──────────────────────────────────────────────────
    // JSON serialization
    // ──────────────────────────────────────────────────

    test('toJson / fromJson round-trips correctly', () {
      final original = TasbeehMonthlyStats(
        monthKey: '2025-06',
        subhanAllah: 33,
        alhamdulillah: 33,
        allahuAkbar: 34,
        laIlahaIllallah: 100,
        astaghfirullah: 100,
      );
      final restored = TasbeehMonthlyStats.fromJson(original.toJson());
      expect(restored.monthKey, original.monthKey);
      expect(restored.subhanAllah, original.subhanAllah);
      expect(restored.total, original.total);
    });

    test('fromJson uses defaults for missing fields', () {
      final stats = TasbeehMonthlyStats.fromJson({'monthKey': '2025-01'});
      expect(stats.subhanAllah, 0);
      expect(stats.total, 0);
    });
  });
}

import 'package:etmaan/features/azkar/data/models/azkar_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ──────────────────────────────────────────────────
  // AzkarModel – JSON parsing
  // ──────────────────────────────────────────────────

  group('AzkarModel', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 1,
        'text': 'سُبْحَانَ الله',
        'count': 33,
        'source': 'Sahih Muslim',
      };
      final model = AzkarModel.fromJson(json);
      expect(model.id, 1);
      expect(model.text, 'سُبْحَانَ الله');
      expect(model.count, 33);
      expect(model.source, 'Sahih Muslim');
    });

    test('fromJson handles null source gracefully', () {
      final json = {
        'id': 2,
        'text': 'الحمد لله',
        'count': 33,
        // no 'source' key
      };
      final model = AzkarModel.fromJson(json);
      expect(model.source, isNull);
    });

    test('fromJson preserves Arabic text exactly', () {
      const arabic = 'أَسْتَغْفِرُ اللهَ الْعَظِيمَ';
      final json = {'id': 3, 'text': arabic, 'count': 100};
      final model = AzkarModel.fromJson(json);
      expect(model.text, arabic);
    });

    test('fromJson parses count = 1 correctly', () {
      final json = {'id': 4, 'text': 'لا إله إلا الله', 'count': 1};
      final model = AzkarModel.fromJson(json);
      expect(model.count, 1);
    });
  });

  // ──────────────────────────────────────────────────
  // Daily goal calculation helpers (pure math)
  // These replicate what DailyGoalCard computes from StatisticsState
  // ──────────────────────────────────────────────────

  group('Daily Quran Goal calculation', () {
    const targetPages = 10;

    int remaining(int completed) =>
        (targetPages - completed).clamp(0, targetPages);

    double progress(int completed) =>
        (completed / targetPages).clamp(0.0, 1.0);

    test('0 pages: remaining=10, progress=0%', () {
      expect(remaining(0), 10);
      expect(progress(0), 0.0);
    });

    test('1 page: remaining=9, progress=10%', () {
      expect(remaining(1), 9);
      expect(progress(1), closeTo(0.1, 0.001));
    });

    test('5 pages: remaining=5, progress=50%', () {
      expect(remaining(5), 5);
      expect(progress(5), closeTo(0.5, 0.001));
    });

    test('8 pages: remaining=2, progress=80%', () {
      expect(remaining(8), 2);
      expect(progress(8), closeTo(0.8, 0.001));
    });

    test('10 pages: remaining=0, progress=100%', () {
      expect(remaining(10), 0);
      expect(progress(10), 1.0);
    });

    test('more than 10 pages: remaining stays at 0, progress capped at 1.0', () {
      expect(remaining(15), 0);
      expect(progress(15), 1.0);
    });

    test('progress never exceeds 1.0', () {
      for (var n = 0; n <= 50; n++) {
        expect(progress(n), lessThanOrEqualTo(1.0));
      }
    });

    test('remaining never goes negative', () {
      for (var n = 0; n <= 50; n++) {
        expect(remaining(n), greaterThanOrEqualTo(0));
      }
    });
  });

  // ──────────────────────────────────────────────────
  // SurahModel search simulation
  // ──────────────────────────────────────────────────

  group('Quran surah search logic', () {
    final surahs = [
      _FakeSurah(1, 'الفاتحة', 'Al-Fatihah'),
      _FakeSurah(2, 'البقرة', 'Al-Baqarah'),
      _FakeSurah(3, 'آل عمران', 'Aal-Imran'),
      _FakeSurah(4, 'النساء', 'An-Nisa'),
      _FakeSurah(112, 'الإخلاص', 'Al-Ikhlas'),
    ];

    List<_FakeSurah> search(String query) {
      if (query.isEmpty) return surahs;
      final q = query.toLowerCase();
      final parsed = int.tryParse(query);
      if (parsed != null) {
        return surahs.where((s) => s.number == parsed).toList();
      }
      return surahs
          .where((s) =>
              s.name.contains(q) ||
              s.englishName.toLowerCase().contains(q))
          .toList();
    }

    test('empty query returns all surahs', () {
      expect(search('').length, 5);
    });

    test('Arabic name search finds correct surah', () {
      final results = search('الفاتحة');
      expect(results.length, 1);
      expect(results.first.number, 1);
    });

    test('English name search finds correct surah', () {
      final results = search('ikhlas');
      expect(results.length, 1);
      expect(results.first.number, 112);
    });

    test('number search finds surah by number', () {
      final results = search('2');
      expect(results.length, 1);
      expect(results.first.name, 'البقرة');
    });

    test('search for non-existent term returns empty list', () {
      expect(search('xyz123abc').isEmpty, isTrue);
    });

    test('case-insensitive English search works', () {
      final results = search('AL-FATIHAH');
      expect(results.length, 1);
    });
  });
}

class _FakeSurah {
  final int number;
  final String name;
  final String englishName;
  _FakeSurah(this.number, this.name, this.englishName);
}

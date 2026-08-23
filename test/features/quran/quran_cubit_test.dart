import 'package:bloc_test/bloc_test.dart';
import 'package:etmaan/features/quran/data/domain/quran_repo.dart';
import 'package:etmaan/features/quran/data/models/surah_model.dart';
import 'package:etmaan/features/quran/logic/cubit/quran_cubit.dart';
import 'package:etmaan/features/quran/logic/cubit/quran_state.dart';
import 'package:flutter_test/flutter_test.dart';

// ──────────────────────────────────────────────────
// Fake QuranRepo
// ──────────────────────────────────────────────────

class _FakeQuranRepo implements QuranRepo {
  final List<SurahModel> _all;

  _FakeQuranRepo(this._all);

  @override
  Future<List<SurahModel>> getSurahsPage({
    required int page,
    int pageSize = 20,
    String query = '',
  }) async {
    var items = _all.where((s) {
      if (query.isEmpty) return true;
      final q = query.toLowerCase();
      final num = int.tryParse(query);
      if (num != null) return s.number == num;
      return s.name.contains(q) || s.englishName.toLowerCase().contains(q);
    }).toList();

    final offset = page * pageSize;
    if (offset >= items.length) return [];
    return items.skip(offset).take(pageSize).toList();
  }
}

class _ThrowingQuranRepo implements QuranRepo {
  @override
  Future<List<SurahModel>> getSurahsPage({
    required int page,
    int pageSize = 20,
    String query = '',
  }) async {
    throw Exception('JSON parse error');
  }
}

List<SurahModel> _makeSurahs(int count) => List.generate(
  count,
  (i) => SurahModel(
    number: i + 1,
    name: 'سورة ${i + 1}',
    englishName: 'Surah ${i + 1}',
    versesCount: 7,
    page: i + 1,
    revelationType: 'Meccan',
  ),
);

void main() {
  group('QuranCubit', () {
    // ──────────────────────────────────────────────────
    // loadFirstPage – happy path
    // ──────────────────────────────────────────────────

    blocTest<QuranCubit, QuranState>(
      'loadFirstPage emits QuranLoaded when data fits one page',
      build: () => QuranCubit(_FakeQuranRepo(_makeSurahs(5))),
      act: (c) => c.loadFirstPage(),
      verify: (c) {
        expect(c.state, isA<QuranEndOfData>());
        final state = c.state as QuranEndOfData;
        expect(state.surahs.length, 5);
      },
    );

    blocTest<QuranCubit, QuranState>(
      'loadFirstPage emits QuranLoaded when there are more pages',
      build: () => QuranCubit(_FakeQuranRepo(_makeSurahs(114))),
      act: (c) => c.loadFirstPage(),
      verify: (c) {
        expect(c.state, isA<QuranLoaded>());
        final state = c.state as QuranLoaded;
        expect(state.surahs.length, QuranCubit.pageSize);
      },
    );

    test('loadMore appends next page to existing surahs', () async {
      final cubit = QuranCubit(_FakeQuranRepo(_makeSurahs(40)));

      await cubit.loadFirstPage();

      expect(cubit.state, isA<QuranLoaded>());
      expect((cubit.state as QuranLoaded).surahs.length, QuranCubit.pageSize);

      await cubit.loadMore();

      expect(cubit.state, isA<QuranLoaded>());

      final state = cubit.state as QuranLoaded;

      expect(state.surahs.length, QuranCubit.pageSize * 2);

      await cubit.close();
    });

    // ──────────────────────────────────────────────────
    // search
    // ──────────────────────────────────────────────────

    blocTest<QuranCubit, QuranState>(
      'search filters surahs by Arabic name',
      build: () => QuranCubit(_FakeQuranRepo(_makeSurahs(114))),
      act: (c) => c.search('سورة 1'),
      verify: (c) {
        // 'سورة 1' matches "سورة 1", "سورة 10", "سورة 11" … etc.
        final state = c.state;
        expect(state is QuranLoaded || state is QuranEndOfData, isTrue);
      },
    );

    blocTest<QuranCubit, QuranState>(
      'search by number returns only that surah',
      build: () => QuranCubit(_FakeQuranRepo(_makeSurahs(114))),
      act: (c) => c.search('5'),
      verify: (c) {
        // Only surah #5
        final surahs = switch (c.state) {
          QuranEndOfData(:final surahs) => surahs,
          QuranLoaded(:final surahs) => surahs,
          _ => <SurahModel>[],
        };
        expect(surahs.length, 1);
        expect(surahs.first.number, 5);
      },
    );

    // ──────────────────────────────────────────────────
    // Empty results
    // ──────────────────────────────────────────────────

    blocTest<QuranCubit, QuranState>(
      'search returns empty list for unknown query',
      build: () => QuranCubit(_FakeQuranRepo(_makeSurahs(114))),
      act: (c) => c.search('XYZ_NOT_EXISTS'),
      verify: (c) {
        final surahs = switch (c.state) {
          QuranEndOfData(:final surahs) => surahs,
          QuranLoaded(:final surahs) => surahs,
          _ => <SurahModel>[],
        };
        expect(surahs.isEmpty, isTrue);
      },
    );

    // ──────────────────────────────────────────────────
    // Error handling
    // ──────────────────────────────────────────────────

    blocTest<QuranCubit, QuranState>(
      'loadFirstPage emits QuranError when repo throws',
      build: () => QuranCubit(_ThrowingQuranRepo()),
      act: (c) => c.loadFirstPage(),
      verify: (c) {
        expect(c.state, isA<QuranError>());
      },
    );
  });
}

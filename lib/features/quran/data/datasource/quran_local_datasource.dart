import '../models/surah_data.dart';
import '../models/surah_model.dart';

class QuranLocalDataSource {
  static const int pageSize = 10;

  Future<List<SurahModel>> getSurahsPage({
    required int page,
    int pageSize = QuranLocalDataSource.pageSize,
    String query = '',
  }) async {
    final start = page * pageSize;
    if (start < 0) {
      return const [];
    }

    final pageItems = <SurahModel>[];
    var index = 0;

    for (final surah in _filtered(query)) {
      if (index >= start + pageSize) {
        break;
      }
      if (index >= start) {
        pageItems.add(surah);
      }
      index++;
    }

    return pageItems;
  }

  Iterable<SurahModel> _filtered(String query) {
    final value = query.trim().toLowerCase();
    if (value.isEmpty) {
      return surahs;
    }

    return surahs.where((surah) {
      return surah.name.toLowerCase().contains(value) ||
          surah.englishName.toLowerCase().contains(value) ||
          surah.number.toString() == value;
    });
  }
}

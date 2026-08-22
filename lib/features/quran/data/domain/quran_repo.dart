import '../models/surah_model.dart';

abstract class QuranRepo {
  Future<List<SurahModel>> getSurahsPage({
    required int page,
    int pageSize,
    String query,
  });
}

import '../datasource/quran_local_datasource.dart';
import '../domain/quran_repo.dart';
import '../models/surah_model.dart';

class QuranRepoImp implements QuranRepo {
  final QuranLocalDataSource dataSource;

  QuranRepoImp(this.dataSource);

  @override
  Future<List<SurahModel>> getSurahsPage({
    required int page,
    int pageSize = QuranLocalDataSource.pageSize,
    String query = '',
  }) {
    return dataSource.getSurahsPage(
      page: page,
      pageSize: pageSize,
      query: query,
    );
  }
}

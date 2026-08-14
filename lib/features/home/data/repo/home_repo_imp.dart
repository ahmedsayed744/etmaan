import 'package:etmaan/features/home/data/datasource/home_local_datasource.dart';
import 'package:etmaan/features/home/data/domain/home_repo.dart';
import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';

class HomeRepoImp implements HomeRepo {
  final HomeLocalDataSource dataSource;

  HomeRepoImp(this.dataSource);

  @override
  Future<List<HadithModel>> getDailyHadiths() {
    return dataSource.getDailyHadiths();
  }

  @override
  Future<List<VerseModel>> getDailyVerses() {
    return dataSource.getDailyVerses();
  }
}
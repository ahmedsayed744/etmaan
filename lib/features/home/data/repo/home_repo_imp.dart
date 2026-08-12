import 'package:etmaan/features/home/data/domain/home_repo.dart';
import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';

import '../datasource/home_local_datasource.dart';


class HomeRepoImp implements HomeRepo {
  final HomeLocalDataSource dataSource;

  HomeRepoImp(this.dataSource);

  @override

  Future<List<HadithModel>> getHadiths() {
    return dataSource.getHadiths();
  }

  @override
  Future<List<VerseModel>> getVerses() {
    return dataSource.getVerses();
  }
}
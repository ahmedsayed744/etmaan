import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';

abstract class HomeRepo {
  Future<List<HadithModel>> getDailyHadiths();

  Future<List<VerseModel>> getDailyVerses();
}
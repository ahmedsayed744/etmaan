import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';

abstract class NotificationContentRepository {
  Future<List<VerseModel>> getVerses();

  Future<List<HadithModel>> getHadiths();

  Future<VerseModel?> getRandomVerse({Set<int> excludeIds = const {}});

  Future<HadithModel?> getRandomHadith({Set<int> excludeIds = const {}});

  Future<List<VerseModel>> getRandomVerses(
    int count, {
    Set<int> excludeIds = const {},
  });

  Future<List<HadithModel>> getRandomHadiths(
    int count, {
    Set<int> excludeIds = const {},
  });
}

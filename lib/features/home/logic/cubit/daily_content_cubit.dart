import 'package:etmaan/features/home/data/domain/home_repo.dart';
import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  final HomeRepo homeRepo;

  DailyContentCubit(this.homeRepo)
      : super(const DailyContentInitial());

  Future<void> getDailyContent() async {
    try {
      emit(const DailyContentLoading());

      final results = await Future.wait([
        homeRepo.getHadiths(),
        homeRepo.getVerses(),
      ]);

      final hadiths = results[0] as List<HadithModel>;
      final verses = results[1] as List<VerseModel>;

      if (hadiths.isEmpty) {
        throw Exception('No hadiths found');
      }

      if (verses.isEmpty) {
        throw Exception('No Quran verses found');
      }

      final now = DateTime.now();

      final startDate = DateTime(
        now.year,
        1,
        1,
      );

      final today = DateTime(
        now.year,
        now.month,
        now.day,
      );

      final dayNumber = today.difference(startDate).inDays;

      final hadithIndex = dayNumber % hadiths.length;

      final verseIndex = dayNumber % verses.length;

      emit(
        DailyContentLoaded(
          hadith: hadiths[hadithIndex],
          verse: verses[verseIndex],
        ),
      );
    } catch (e) {
      emit(
        DailyContentError(
          e.toString(),
        ),
      );
    }
  }
}
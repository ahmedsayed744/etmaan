import 'package:etmaan/features/home/data/domain/home_repo.dart';
import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'daily_content_state.dart';

class DailyContentCubit extends Cubit<DailyContentState> {
  final HomeRepo homeRepo;

  DailyContentCubit(this.homeRepo) : super(const DailyContentInitial());
 Future<void> getDailyContent() async {
  final stopwatch = Stopwatch()..start();

  try {
    emit(const DailyContentLoading());

    final results = await Future.wait([
      homeRepo.getDailyHadiths(),
      homeRepo.getDailyVerses(),
    ]);

    final hadiths = results[0] as List<HadithModel>;
    final verses = results[1] as List<VerseModel>;

    if (hadiths.isEmpty || verses.isEmpty) {
      emit(
        const DailyContentError(
          'لا توجد بيانات متاحة',
        ),
      );
      return;
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

    final todayHadith = hadiths[hadithIndex];
    final todayVerse = verses[verseIndex];

    debugPrint(
      'Daily Content Loaded: '
      '${stopwatch.elapsedMilliseconds} ms',
    );

    emit(
      DailyContentLoaded(
        hadith: todayHadith,
        verse: todayVerse,
      ),
    );
  } catch (e) {
    debugPrint('Daily Content Error: $e');

    emit(
      DailyContentError(
        e.toString(),
      ),
    );
  }
}}

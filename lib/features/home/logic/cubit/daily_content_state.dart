import 'package:etmaan/features/home/data/models/hadith_model.dart';
import 'package:etmaan/features/home/data/models/verse_model.dart';
abstract class DailyContentState {
  const DailyContentState();
}

class DailyContentInitial extends DailyContentState {
  const DailyContentInitial();
}

class DailyContentLoading extends DailyContentState {
  const DailyContentLoading();
}

class DailyContentLoaded extends DailyContentState {
  final HadithModel hadith;
  final VerseModel verse;

  const DailyContentLoaded({
    required this.hadith,
    required this.verse,
  });
}

class DailyContentError extends DailyContentState {
  final String message;

  const DailyContentError(this.message);
}
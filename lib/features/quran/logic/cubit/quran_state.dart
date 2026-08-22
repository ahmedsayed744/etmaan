import '../../data/models/surah_model.dart';

abstract class QuranState {
  const QuranState();
}

class QuranInitial extends QuranState {
  const QuranInitial();
}

class QuranLoading extends QuranState {
  const QuranLoading();
}

class QuranLoaded extends QuranState {
  final List<SurahModel> surahs;

  const QuranLoaded(this.surahs);
}

class QuranLoadingMore extends QuranState {
  final List<SurahModel> surahs;

  const QuranLoadingMore(this.surahs);
}

class QuranEndOfData extends QuranState {
  final List<SurahModel> surahs;

  const QuranEndOfData(this.surahs);
}

class QuranError extends QuranState {
  final String message;
  final List<SurahModel> surahs;

  const QuranError(this.message, {this.surahs = const []});
}

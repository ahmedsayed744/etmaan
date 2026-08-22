import 'package:etmaan/features/quran/data/datasource/quran_local_datasource.dart';
import 'package:etmaan/features/quran/data/domain/quran_repo.dart';
import 'package:etmaan/features/quran/data/models/surah_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit(this._repo) : super(const QuranInitial());

  final QuranRepo _repo;

  static const int pageSize = QuranLocalDataSource.pageSize;

  bool _isFetching = false;
  bool _hasMore = true;
  int _page = 0;
  int _requestId = 0;
  String _query = '';
  List<SurahModel> _items = const [];

  Future<void> loadFirstPage() {
    _page = 0;
    _hasMore = true;
    _items = const [];
    return _fetch(isLoadMore: false);
  }

  Future<void> search(String query) {
    _query = query;
    return loadFirstPage();
  }

  Future<void> loadMore() {
    if (_isFetching || !_hasMore || _items.isEmpty || state is QuranEndOfData) {
      return Future.value();
    }
    return _fetch(isLoadMore: true);
  }

  Future<void> retry() {
    if (_items.isEmpty) {
      return loadFirstPage();
    }
    return _fetch(isLoadMore: true);
  }

  Future<void> _fetch({required bool isLoadMore}) async {
    if (_isFetching && isLoadMore) {
      return;
    }

    final requestId = ++_requestId;
    _isFetching = true;

    if (isLoadMore) {
      emit(QuranLoadingMore(List.unmodifiable(_items)));
    } else {
      emit(const QuranLoading());
    }

    try {
      final page = isLoadMore ? _page + 1 : 0;
      final result = await _repo.getSurahsPage(
        page: page,
        pageSize: pageSize,
        query: _query,
      );

      if (requestId != _requestId || isClosed) {
        return;
      }

      if (isLoadMore) {
        _items = [..._items, ...result];
        _page = page;
      } else {
        _items = result;
        _page = 0;
      }

      _hasMore = result.length >= pageSize;

      final surahs = List<SurahModel>.unmodifiable(_items);
      if (_hasMore) {
        emit(QuranLoaded(surahs));
      } else {
        emit(QuranEndOfData(surahs));
      }
    } catch (error) {
      if (requestId != _requestId || isClosed) {
        return;
      }
      emit(
        QuranError(
          error.toString(),
          surahs: List<SurahModel>.unmodifiable(_items),
        ),
      );
    } finally {
      if (requestId == _requestId) {
        _isFetching = false;
      }
    }
  }
}

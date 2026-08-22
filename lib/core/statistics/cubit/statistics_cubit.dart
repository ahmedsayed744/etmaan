import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_statistics_model.dart';
import '../repo/statistics_repo.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState>
    with WidgetsBindingObserver {
  final StatisticsRepo _repo;

  DailyStatistics _daily = DailyStatistics(date: _getCurrentDate());
  LifetimeStatistics _lifetime = LifetimeStatistics();

  DateTime? _sessionStart;
  final Set<int> _sessionQuranPages = {};

  StatisticsCubit(this._repo) : super(const StatisticsInitial());

  static String _getCurrentDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  Future<void> initialize() async {
    emit(const StatisticsLoading());
    WidgetsBinding.instance.addObserver(this);

    try {
      final cachedDaily = await _repo.getDailyStatistics();
      final cachedLifetime = await _repo.getLifetimeStatistics();
      final lastOpenDate = _repo.getLastOpenDate();
      final currentDate = _getCurrentDate();

      if (cachedLifetime != null) {
        _lifetime = cachedLifetime;
      }

      if (cachedDaily != null) {
        _daily = cachedDaily;
      }

      // Handle new day
      if (lastOpenDate != currentDate) {
        if (lastOpenDate != null) {
          // New day detected. We can optionally archive history here.
        }

        // Reset daily and increment active days
        _daily = DailyStatistics(date: currentDate);
        _lifetime = _lifetime.copyWith(activeDays: _lifetime.activeDays + 1);

        await _repo.saveDailyStatistics(_daily);
        await _repo.saveLifetimeStatistics(_lifetime);
        await _repo.saveLastOpenDate(currentDate);
      } else {
        // App opened on the same day it was already opened
        // Check if daily date matches current date just in case
        if (_daily.date != currentDate) {
          _daily = DailyStatistics(date: currentDate);
          await _repo.saveDailyStatistics(_daily);
        }
      }

      startSession();
      _emitLoaded();
    } catch (e) {
      emit(StatisticsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    endSession();
    return super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      startSession();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      endSession();
    }
  }

  void startSession() {
    if (_sessionStart == null) {
      _sessionStart = DateTime.now();
      _sessionQuranPages.clear();
    }
  }

  void endSession() {
    if (_sessionStart != null) {
      final now = DateTime.now();
      final elapsed = now.difference(_sessionStart!).inSeconds;

      if (elapsed > 0) {
        _daily = _daily.copyWith(
          sessionSeconds: _daily.sessionSeconds + elapsed,
        );
        _lifetime = _lifetime.copyWith(
          totalSessionSeconds: _lifetime.totalSessionSeconds + elapsed,
        );

        _saveAndEmit();
      }
      _sessionStart = null;
    }
  }

  void incrementTasbeeh() {
    _daily = _daily.copyWith(tasbeehCount: _daily.tasbeehCount + 1);
    _lifetime = _lifetime.copyWith(totalTasbeeh: _lifetime.totalTasbeeh + 1);
    _saveAndEmit();
  }

  void trackQuranPage(int page) {
    if (!_sessionQuranPages.contains(page)) {
      _sessionQuranPages.add(page);

      _daily = _daily.copyWith(quranPages: _daily.quranPages + 1);
      _lifetime = _lifetime.copyWith(
        totalQuranPages: _lifetime.totalQuranPages + 1,
      );
      _saveAndEmit();
    }
  }

  void incrementQuranHizb() {
    _daily = _daily.copyWith(quranHizb: _daily.quranHizb + 1);
    _lifetime = _lifetime.copyWith(
      totalQuranHizb: _lifetime.totalQuranHizb + 1,
    );
    _saveAndEmit();
  }

  Future<void> _saveAndEmit() async {
    // Check for date change before saving
    final currentDate = _getCurrentDate();
    if (_daily.date != currentDate) {
      _daily = DailyStatistics(date: currentDate);
      _lifetime = _lifetime.copyWith(activeDays: _lifetime.activeDays + 1);
      await _repo.saveLastOpenDate(currentDate);
      _sessionQuranPages.clear();
    }

    _emitLoaded();

    // Fire and forget saves
    _repo.saveDailyStatistics(_daily);
    _repo.saveLifetimeStatistics(_lifetime);
  }

  void _emitLoaded() {
    emit(StatisticsLoaded(daily: _daily, lifetime: _lifetime));
  }
}

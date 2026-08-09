import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/tasbeeh_model.dart';
import 'tasbeeh_state.dart';

class TasbeehCubit extends Cubit<TasbeehState> {
  TasbeehCubit() : super(const TasbeehInitial()) {
    _initialize();
  }

  final List<TasbeehModel> _tasbeehList = const [
    TasbeehModel(
      arabicName: 'سُبْحَانَ الله',
      target: 33,
      color: Color(0xFF2E8B68),
    ),

    TasbeehModel(
      arabicName: 'الْحَمْدُ لِلَّه',
      target: 33,
      color: Color(0xFF4384ED),
    ),

    TasbeehModel(
      arabicName: 'اللهُ أَكْبَر',
      target: 34,
      color: Color(0xFF7F43E4),
    ),

    TasbeehModel(
      arabicName: 'لَا إِلٰهَ إِلَّا الله',
      target: 100,
      color: Color(0xFFD1B46E),
    ),

    TasbeehModel(
      arabicName: 'أَسْتَغْفِرُ الله',
      target: 100,
      color: Color(0xFFE85A5A),
    ),
  ];

  int _selectedIndex = 0;
  int _count = 0;

  void _initialize() {
    emit(
      TasbeehUpdated(
        tasbeehList: _tasbeehList,
        selectedIndex: _selectedIndex,
        count: _count,
      ),
    );
  }

  // ==========================
  // Current Tasbeeh
  // ==========================

  TasbeehModel get currentTasbeeh {
    return _tasbeehList[_selectedIndex];
  }

  int get count => _count;
  int get target => currentTasbeeh.target;
  // ==========================
  // Increment
  // ==========================

  void increment() {
    if (_count >= currentTasbeeh.target) {
      return;
    }
    _count++;
    _emit();
  }

  // ==========================
  // Reset
  // ==========================

  void reset() {
    _count = 0;

    _emit();
  }

  // ==========================
  // Select Tasbeeh
  // ==========================

  void selectTasbeeh(int index) {
    if (index < 0 || index >= _tasbeehList.length) {
      return;
    }

    _selectedIndex = index;
    _count = 0;

    _emit();
  }

  // ==========================
  // Next Tasbeeh
  // ==========================

  void nextTasbeeh() {
    if (_selectedIndex < _tasbeehList.length - 1) {
      _selectedIndex++;
    } else {
      _selectedIndex = 0;
    }

    _count = 0;

    _emit();
  }

  // ==========================
  // Previous Tasbeeh
  // ==========================

  void previousTasbeeh() {
    if (_selectedIndex > 0) {
      _selectedIndex--;
    } else {
      _selectedIndex = _tasbeehList.length - 1;
    }

    _count = 0;

    _emit();
  }

  // ==========================
  // Emit State
  // ==========================

  void _emit() {
    emit(
      TasbeehUpdated(
        tasbeehList: _tasbeehList,
        selectedIndex: _selectedIndex,
        count: _count,
      ),
    );
  }
}

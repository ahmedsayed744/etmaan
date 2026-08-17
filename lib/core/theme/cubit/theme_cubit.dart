import 'package:etmaan/core/cache/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.light)) {
    _loadTheme();
  }

  void _loadTheme() {
    final String? themeStr = CacheHelper().getData(key: 'themeMode') as String?;
    if (themeStr == 'dark') {
      emit(const ThemeState(themeMode: ThemeMode.dark));
    } else {
      emit(const ThemeState(themeMode: ThemeMode.light));
    }
  }

  void toggleTheme() {
    final nextMode = state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    CacheHelper().saveData(key: 'themeMode', value: nextMode == ThemeMode.dark ? 'dark' : 'light');
    emit(ThemeState(themeMode: nextMode));
  }

  void setDarkMode(bool value) {
    final nextMode = value ? ThemeMode.dark : ThemeMode.light;
    CacheHelper().saveData(key: 'themeMode', value: value ? 'dark' : 'light');
    emit(ThemeState(themeMode: nextMode));
  }
}
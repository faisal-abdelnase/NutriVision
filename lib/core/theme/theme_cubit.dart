import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._preferences)
    : super(_readThemeMode(_preferences.getString(_preferenceKey)));

  static const _preferenceKey = 'theme_mode';
  final SharedPreferences _preferences;

  static ThemeMode _readThemeMode(String? value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == state) return;
    emit(mode);
    await _preferences.setString(_preferenceKey, mode.name);
  }

  Future<void> toggleTheme() =>
      setThemeMode(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
}

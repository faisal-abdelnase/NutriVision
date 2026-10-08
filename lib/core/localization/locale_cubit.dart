import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._preferences)
    : super(_readLocale(_preferences.getString(_preferenceKey)));

  static const _preferenceKey = 'app_locale';
  final SharedPreferences _preferences;

  static Locale _readLocale(String? languageCode) =>
      languageCode == 'ar' ? const Locale('ar') : const Locale('en');

  Future<void> changeLocale(Locale locale) async {
    if (locale.languageCode != 'en' && locale.languageCode != 'ar') return;
    final selected = Locale(locale.languageCode);
    if (selected == state) return;
    emit(selected);
    await _preferences.setString(_preferenceKey, selected.languageCode);
  }
}

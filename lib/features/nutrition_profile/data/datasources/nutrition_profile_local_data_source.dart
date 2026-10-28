import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/nutrition_profile_model.dart';

abstract class NutritionProfileLocalDataSource {
  Future<void> cacheNutritionProfile(NutritionProfileModel profile);
  NutritionProfileModel? getCachedNutritionProfile({String? userId});
  Future<void> clearCache();
}

class NutritionProfileLocalDataSourceImpl
    implements NutritionProfileLocalDataSource {
  final SharedPreferences preferences;

  static const String _globalKey = 'cached_nutrition_profile';

  NutritionProfileLocalDataSourceImpl({required this.preferences});

  @override
  Future<void> cacheNutritionProfile(NutritionProfileModel profile) async {
    final jsonStr = jsonEncode(profile.toLocalJson());
    await preferences.setString(_globalKey, jsonStr);
    await preferences.setString('${_globalKey}_${profile.userId}', jsonStr);
  }

  @override
  NutritionProfileModel? getCachedNutritionProfile({String? userId}) {
    String? raw;
    if (userId != null && userId.isNotEmpty) {
      raw = preferences.getString('${_globalKey}_$userId');
    }
    raw ??= preferences.getString(_globalKey);

    if (raw == null || raw.isEmpty) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return NutritionProfileModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await preferences.remove(_globalKey);
  }
}

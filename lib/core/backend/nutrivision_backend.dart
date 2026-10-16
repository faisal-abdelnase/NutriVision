import 'package:cloud_functions/cloud_functions.dart';

/// Typed entry point for NutriVision Cloud Functions.
/// Firebase SDK attaches the current user's ID token automatically.
class NutriVisionBackend {
  NutriVisionBackend({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  Future<Map<String, dynamic>> _call(String name, Map<String, dynamic> data) async {
    final result = await _functions.httpsCallable(name).call(data);
    final value = result.data;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FirebaseFunctionsException(code: 'data-loss', message: 'Backend returned an unexpected response.');
  }

  Future<Map<String, dynamic>> bootstrapUser({String? fullName}) =>
      _call('bootstrapUser', {if (fullName != null) 'fullName': fullName});

  Future<Map<String, dynamic>> completeOnboarding({
    required String goal,
    List<String> dietaryPreferences = const [],
    List<String> allergies = const [],
    List<String> excludedIngredients = const [],
  }) => _call('completeOnboarding', {
    'goal': goal, 'dietaryPreferences': dietaryPreferences,
    'allergies': allergies, 'excludedIngredients': excludedIngredients,
  });

  Future<Map<String, dynamic>> updateNutritionProfile(Map<String, dynamic> profile) =>
      _call('updateNutritionProfile', {'profile': profile});

  Future<Map<String, dynamic>> updateUserPreferences(Map<String, dynamic> preferences) =>
      _call('updateUserPreferences', {'preferences': preferences});

  Future<Map<String, dynamic>> saveMeal(Map<String, dynamic> meal) =>
      _call('saveMeal', {'meal': meal});

  Future<Map<String, dynamic>> deleteMeal(String mealId) =>
      _call('deleteMeal', {'mealId': mealId});

  Future<Map<String, dynamic>> getDashboardSummary({DateTime? date}) =>
      _call('getDashboardSummary', {if (date != null) 'date': date.toIso8601String()});

  Future<Map<String, dynamic>> analyzeMeal({String? description, String? imagePath}) =>
      _call('analyzeMeal', {if (description != null) 'description': description, if (imagePath != null) 'imagePath': imagePath});

  Future<Map<String, dynamic>> sendCoachMessage({String? conversationId, required String message}) =>
      _call('sendCoachMessage', {if (conversationId != null) 'conversationId': conversationId, 'message': message});

  Future<Map<String, dynamic>> generateRecipe({
    required List<String> availableIngredients,
    List<String> dietaryPreferences = const [],
    List<String> allergies = const [],
    List<String> excludedIngredients = const [],
    int servings = 2,
  }) => _call('generateRecipe', {
    'availableIngredients': availableIngredients, 'dietaryPreferences': dietaryPreferences,
    'allergies': allergies, 'excludedIngredients': excludedIngredients, 'servings': servings,
  });

  Future<Map<String, dynamic>> saveGroceryItem(Map<String, dynamic> item) =>
      _call('saveGroceryItem', {'item': item});

  Future<Map<String, dynamic>> deleteGroceryItem(String itemId) =>
      _call('deleteGroceryItem', {'itemId': itemId});

  Future<Map<String, dynamic>> saveProgressEntry(Map<String, dynamic> entry) =>
      _call('saveProgressEntry', {'entry': entry});

  Future<Map<String, dynamic>> deleteProgressEntry(String entryId) =>
      _call('deleteProgressEntry', {'entryId': entryId});

  Future<Map<String, dynamic>> getProgressHistory({DateTime? startDate, DateTime? endDate, int pageSize = 30}) =>
      _call('getProgressHistory', {
        if (startDate != null) 'startDate': startDate.toIso8601String(),
        if (endDate != null) 'endDate': endDate.toIso8601String(), 'pageSize': pageSize,
      });

  Future<Map<String, dynamic>> deleteUserAccount() => _call('deleteUserAccount', const {});

  Future<Map<String, dynamic>> registerDeviceToken({required String token, required String deviceId, required String platform}) =>
      _call('registerDeviceToken', {'token': token, 'deviceId': deviceId, 'platform': platform});

  Future<Map<String, dynamic>> scheduleMealReminder({required int hour, required int minute, required String timezone, bool enabled = true}) =>
      _call('scheduleMealReminder', {'hour': hour, 'minute': minute, 'timezone': timezone, 'enabled': enabled});
}
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/onboarding_state_model.dart';

abstract class OnboardingLocalDataSource {
  Future<OnboardingStateModel> readOnboardingState();

  Future<void> saveOnboardingState(OnboardingStateModel state);
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences sharedPreferences;

  OnboardingLocalDataSourceImpl({required this.sharedPreferences});

  static const String _onboardingStateKey = 'onboarding_state';

  @override
  Future<OnboardingStateModel> readOnboardingState() async {
    final jsonString = sharedPreferences.getString(_onboardingStateKey);

    if (jsonString == null) {
      return const OnboardingStateModel(isCompleted: false);
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return OnboardingStateModel.fromJson(json);
    } catch (_) {
      return const OnboardingStateModel(isCompleted: false);
    }
  }

  @override
  Future<void> saveOnboardingState(OnboardingStateModel state) async {
    final jsonString = jsonEncode(state.toJson());

    final saved = await sharedPreferences.setString(
      _onboardingStateKey,
      jsonString,
    );

    if (!saved) {
      throw Exception('Failed to save onboarding state.');
    }
  }
}

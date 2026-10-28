import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/nutrition_profile_model.dart';
import 'nutrition_profile_remote_data_source.dart';

class NutritionProfileRemoteDataSourceImpl
    implements NutritionProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  NutritionProfileRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('nutrition_profiles');

  @override
  Future<NutritionProfileModel?> fetchNutritionProfile({
    required String userId,
  }) async {
    final doc = await _collection.doc(userId).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return NutritionProfileModel.fromJson(doc.data()!);
  }

  @override
  Future<NutritionProfileModel> createNutritionProfile({
    required NutritionProfileModel profile,
  }) async {
    final docRef = _collection.doc(profile.userId);
    final model = NutritionProfileModel.fromEntity(_withUpdatedAt(profile));

    await docRef.set(model.toJson(), SetOptions(merge: true));

    return model;
  }

  @override
  Future<NutritionProfileModel> updateNutritionProfile({
    required NutritionProfileModel profile,
  }) async {
    final docRef = _collection.doc(profile.userId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw StateError('Nutrition profile does not exist for this user.');
    }

    final model = NutritionProfileModel.fromEntity(_withUpdatedAt(profile));

    await docRef.set(model.toJson(), SetOptions(merge: true));

    return model;
  }

  @override
  Future<NutritionProfileModel> updateNutritionGoals({
    required String userId,
    required Map<String, dynamic> goals,
  }) async {
    final docRef = _collection.doc(userId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw StateError('Create the nutrition profile before updating goals.');
    }

    await docRef.set({
      ...goals,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final updatedSnapshot = await docRef.get();

    return NutritionProfileModel.fromJson(updatedSnapshot.data()!);
  }

  @override
  Future<NutritionProfileModel> updateDietaryPreferences({
    required String userId,
    required List<String> dietaryPreferences,
    required List<String> allergies,
  }) async {
    final docRef = _collection.doc(userId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw StateError(
        'Create the nutrition profile before updating preferences.',
      );
    }

    await docRef.set({
      'dietaryPreferences': dietaryPreferences,
      'allergies': allergies,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final updatedSnapshot = await docRef.get();

    return NutritionProfileModel.fromJson(updatedSnapshot.data()!);
  }

  NutritionProfileModel _withUpdatedAt(NutritionProfileModel profile) {
    return NutritionProfileModel(
      userId: profile.userId,
      age: profile.age,
      heightCm: profile.heightCm,
      weightKg: profile.weightKg,
      goal: profile.goal,
      dailyCalorieTarget: profile.dailyCalorieTarget,
      proteinTargetGrams: profile.proteinTargetGrams,
      carbohydrateTargetGrams: profile.carbohydrateTargetGrams,
      fatTargetGrams: profile.fatTargetGrams,
      dietaryPreferences: List<String>.from(profile.dietaryPreferences),
      allergies: List<String>.from(profile.allergies),
      updatedAt: DateTime.now(),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'nutrivision_backend.dart';

/// Firebase adapter for feature reads and private file uploads.
/// Business-sensitive writes are delegated to Cloud Functions.
class FirebaseNutriVisionDataSource {
  FirebaseNutriVisionDataSource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    NutriVisionBackend? backend,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _backend = backend ?? NutriVisionBackend();

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final NutriVisionBackend _backend;

  String get _uid {
    final user = _auth.currentUser;
    if (user == null) throw StateError('Sign in is required.');
    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _userRef =>
      _firestore.collection('users').doc(_uid);

  Future<Map<String, dynamic>?> getUserProfile() async {
    final snapshot = await _userRef.get();
    return snapshot.data();
  }

  Future<Map<String, dynamic>?> getNutritionProfile() async {
    final snapshot = await _userRef.collection('nutrition_profile').doc('current').get();
    return snapshot.data();
  }

  Stream<List<Map<String, dynamic>>> watchMeals({int limit = 30}) =>
      _userRef.collection('meals')
          .orderBy('consumedAt', descending: true)
          .limit(limit.clamp(1, 100).toInt())
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(growable: false));

  Future<List<Map<String, dynamic>>> getRecentMeals({int limit = 30}) async {
    final snapshot = await _userRef.collection('meals')
        .orderBy('consumedAt', descending: true)
        .limit(limit.clamp(1, 100).toInt())
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> getPublicRecipes({int limit = 30}) async {
    final snapshot = await _firestore.collection('recipes')
        .where('visibility', isEqualTo: 'public')
        .orderBy('createdAt', descending: true)
        .limit(limit.clamp(1, 50).toInt())
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(growable: false);
  }

  Future<List<Map<String, dynamic>>> getGroceryItems() async {
    final snapshot = await _userRef.collection('grocery_items')
        .orderBy('updatedAt', descending: true).limit(200).get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList(growable: false);
  }

  Future<String> uploadMealImage({required String mealId, required File file}) async {
    final safeMealId = _safeSegment(mealId);
    final extension = _extension(file.path);
    final fileName = DateTime.now().microsecondsSinceEpoch.toString() + '.' + extension;
    final path = 'users/' + _uid + '/meal_images/' + safeMealId + '/' + fileName;
    await _storage.ref(path).putFile(file, SettableMetadata(contentType: _contentType(extension)));
    return path;
  }

  Future<String> uploadProfilePhoto(File file) async {
    final extension = _extension(file.path);
    final path = 'users/' + _uid + '/profile/avatar_' +
        DateTime.now().microsecondsSinceEpoch.toString() + '.' + extension;
    await _storage.ref(path).putFile(file, SettableMetadata(contentType: _contentType(extension)));
    await _backend.updateProfilePhotoPath(path);
    return path;
  }

  Future<void> deleteStorageFile(String path) async {
    if (!path.startsWith('users/' + _uid + '/')) {
      throw ArgumentError('File path must belong to the current user.');
    }
    await _storage.ref(path).delete();
  }

  Future<Map<String, dynamic>> getMealAnalysisHistory({int pageSize = 20}) =>
      _backend.getMealAnalysisHistory(pageSize: pageSize);

  Future<Map<String, dynamic>> getDashboardSummary({DateTime? date}) =>
      _backend.getDashboardSummary(date: date);

  Future<Map<String, dynamic>> analyzeMeal({String? description, String? imagePath}) =>
      _backend.analyzeMeal(description: description, imagePath: imagePath);

  Future<Map<String, dynamic>> sendCoachMessage({String? conversationId, required String message}) =>
      _backend.sendCoachMessage(conversationId: conversationId, message: message);

  Future<Map<String, dynamic>> getCoachConversationHistory({
    required String conversationId,
    int pageSize = 30,
  }) => _backend.getCoachConversationHistory(conversationId: conversationId, pageSize: pageSize);

  Future<Map<String, dynamic>> generateRecipe({
    required List<String> ingredients,
    List<String> dietaryPreferences = const [],
    List<String> allergies = const [],
    List<String> excludedIngredients = const [],
    int servings = 2,
  }) => _backend.generateRecipe(
    availableIngredients: ingredients,
    dietaryPreferences: dietaryPreferences,
    allergies: allergies,
    excludedIngredients: excludedIngredients,
    servings: servings,
  );

  Future<Map<String, dynamic>> getSavedRecipes({int pageSize = 20}) =>
      _backend.getSavedRecipes(pageSize: pageSize);

  Future<Map<String, dynamic>> setRecipeSaved({required String recipeId, required bool saved}) =>
      _backend.setRecipeSaved(recipeId: recipeId, saved: saved);

  Future<Map<String, dynamic>> getProgressSummary() => _backend.getProgressSummary();

  String _safeSegment(String value) {
    final segment = value.trim();
    if (!RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(segment)) {
      throw ArgumentError('Invalid storage path segment.');
    }
    return segment;
  }

  String _extension(String path) {
    final extension = path.contains('.') ? path.split('.').last.toLowerCase() : 'jpg';
    if (!['jpg', 'jpeg', 'png', 'webp', 'heic'].contains(extension)) {
      throw ArgumentError('Unsupported image format.');
    }
    return extension;
  }

  String _contentType(String extension) {
    switch (extension) {
      case 'png': return 'image/png';
      case 'webp': return 'image/webp';
      case 'heic': return 'image/heic';
      default: return 'image/jpeg';
    }
  }
}
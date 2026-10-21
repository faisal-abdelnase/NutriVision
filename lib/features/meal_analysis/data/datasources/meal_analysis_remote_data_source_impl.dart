import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';


import '../models/meal_analysis_request_model.dart';
import '../models/meal_analysis_result_model.dart';
import 'meal_analysis_remote_data_source.dart';

class MealAnalysisRemoteDataSourceImpl
    implements MealAnalysisRemoteDataSource {
  final Dio dio;
  final FirebaseFirestore firestore;


  MealAnalysisRemoteDataSourceImpl({
    required this.dio,
    required this.firestore,
  });

  CollectionReference<Map<String, dynamic>> _collection(
    String userId,
  ) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('meal_analyses');
  }

  @override
  Future<MealAnalysisResultModel> analyzeMealFromText({
    required MealAnalysisRequestModel request,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      '/analyze/text',
      data: request.toJson(),
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException(
        'The AI service returned an empty response.',
      );
    }

    final result = MealAnalysisResultModel.fromJson(data);

    if (result.userId != request.userId || result.id.isEmpty) {
      throw const FormatException(
        'The AI service returned an invalid analysis result.',
      );
    }

    return result;
  }

  @override
  Future<MealAnalysisResultModel> analyzeMealFromImage({
    required MealAnalysisRequestModel request,
  }) async {
    final imagePath = request.imagePath;

    if (imagePath == null || imagePath.trim().isEmpty) {
      throw ArgumentError('An image path is required.');
    }

    final imageFile = File(imagePath);

    if (!await imageFile.exists()) {
      throw ArgumentError('The selected image does not exist.');
    }

    final formData = FormData.fromMap({
      'userId': request.userId,
      'description': request.description,
      'mealType': request.mealType,
      'servingSizeGrams': request.servingSizeGrams,
      'dietaryPreferences': request.dietaryPreferences,
      'allergies': request.allergies,
      'image': await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split(Platform.pathSeparator).last,
      ),
    });

    final response = await dio.post<Map<String, dynamic>>(
      '/analyze/image',
      data: formData,
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException(
        'The AI service returned an empty response.',
      );
    }

    final result = MealAnalysisResultModel.fromJson(data);

    if (result.userId != request.userId || result.id.isEmpty) {
      throw const FormatException(
        'The AI service returned an invalid analysis result.',
      );
    }

    return result;
  }

  @override
  Future<MealAnalysisResultModel?> fetchMealAnalysisById({
    required String analysisId,
    required String userId,
  }) async {
    final snapshot = await _collection(userId).doc(analysisId).get();

    if (!snapshot.exists) return null;

    return MealAnalysisResultModel.fromJson({
      ...snapshot.data()!,
      'id': snapshot.id,
    });
  }

  @override
  Future<MealAnalysisResultModel> saveMealAnalysis({
    required MealAnalysisResultModel result,
  }) async {
    if (result.id.isEmpty || result.userId.isEmpty) {
      throw ArgumentError('Analysis ID and user ID are required.');
    }

    final savedResult = result;

    await _collection(result.userId)
        .doc(result.id)
        .set(savedResult.toJson());

    return savedResult;
  }

  @override
  Future<List<MealAnalysisResultModel>> fetchMealAnalysisHistory({
    required String userId,
    required int page,
    required int pageSize,
  }) async {
    if (page < 1 || pageSize < 1) {
      throw ArgumentError(
        'Page and pageSize must be greater than zero.',
      );
    }

    final snapshot = await _collection(userId)
        .orderBy('analyzedAt', descending: true)
        .limit((page - 1) * pageSize + pageSize)
        .get();

    final documents = snapshot.docs.skip((page - 1) * pageSize);

    return documents.map((doc) {
      return MealAnalysisResultModel.fromJson({
        ...doc.data(),
        'id': doc.id,
      });
    }).toList();
  }
}
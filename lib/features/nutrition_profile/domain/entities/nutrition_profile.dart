class NutritionProfile {
  final String userId;

  final int? age;
  final double? heightCm;
  final double? weightKg;

  final String? goal;

  final double? dailyCalorieTarget;
  final double? proteinTargetGrams;
  final double? carbohydrateTargetGrams;
  final double? fatTargetGrams;

  final List<String> dietaryPreferences;
  final List<String> allergies;

  final DateTime? updatedAt;

  const NutritionProfile({
    required this.userId,
    this.age,
    this.heightCm,
    this.weightKg,
    this.goal,
    this.dailyCalorieTarget,
    this.proteinTargetGrams,
    this.carbohydrateTargetGrams,
    this.fatTargetGrams,
    this.dietaryPreferences = const [],
    this.allergies = const [],
    this.updatedAt,
  });
}

extension NutritionProfileX on NutritionProfile {
  bool get isCalibrated =>
      dailyCalorieTarget != null && dailyCalorieTarget! > 0;

  String get goalLabelAr {
    switch (goal?.toLowerCase()) {
      case 'loseweight':
        return 'خسارة الوزن';
      case 'gainmuscle':
        return 'بناء الكتلة العضلية';
      case 'maintainweight':
        return 'تثبيت الوزن والتوازن';
      case 'eathealthier':
      default:
        return 'تحسين التغذية والصحة العامة';
    }
  }

  String get goalLabelEn {
    switch (goal?.toLowerCase()) {
      case 'loseweight':
        return 'Weight Loss Deficit';
      case 'gainmuscle':
        return 'Muscle Hypertrophy';
      case 'maintainweight':
        return 'Weight Maintenance';
      case 'eathealthier':
      default:
        return 'Clean Healthy Living';
    }
  }

  String get regimenName {
    if (dietaryPreferences.isNotEmpty) {
      final first = dietaryPreferences.first.toLowerCase();
      if ([
        'standard',
        'highprotein',
        'mediterranean',
        'lowcarb',
        'vegetarian',
        'vegan',
      ].contains(first)) {
        return first;
      }
    }
    return 'standard';
  }

  String get regimenLabelAr {
    switch (regimenName) {
      case 'highprotein':
        return 'عالي البروتين';
      case 'mediterranean':
        return 'حمية البحر المتوسط';
      case 'lowcarb':
        return 'منخفض الكربوهيدرات';
      case 'vegetarian':
        return 'نباتي';
      case 'vegan':
        return 'نباتي صِرف';
      case 'standard':
      default:
        return 'متوازن قياسي';
    }
  }

  String get regimenLabelEn {
    switch (regimenName) {
      case 'highprotein':
        return 'High Protein';
      case 'mediterranean':
        return 'Mediterranean';
      case 'lowcarb':
        return 'Low Carb';
      case 'vegetarian':
        return 'Vegetarian';
      case 'vegan':
        return 'Vegan';
      case 'standard':
      default:
        return 'Standard Balanced';
    }
  }

  bool containsAllergen(String ingredientName) {
    if (allergies.isEmpty) return false;
    final lower = ingredientName.toLowerCase();
    for (final allergen in allergies) {
      final aLower = allergen.toLowerCase();
      if (aLower.isEmpty) continue;
      if (lower.contains(aLower) || aLower.contains(lower)) return true;
      if (aLower == 'peanuts' &&
          (lower.contains('peanut') || lower.contains('فول سوداني'))) {
        return true;
      }
      if (aLower == 'seafood' &&
          (lower.contains('fish') ||
              lower.contains('salmon') ||
              lower.contains('shrimp') ||
              lower.contains('shellfish') ||
              lower.contains('tuna') ||
              lower.contains('seafood') ||
              lower.contains('سمك') ||
              lower.contains('سلمون') ||
              lower.contains('جمبري') ||
              lower.contains('بحري'))) {
        return true;
      }
      if (aLower == 'dairy' &&
          (lower.contains('milk') ||
              lower.contains('cheese') ||
              lower.contains('butter') ||
              lower.contains('cream') ||
              lower.contains('whey') ||
              lower.contains('lactose') ||
              lower.contains('حليب') ||
              lower.contains('جبن') ||
              lower.contains('قشطة') ||
              lower.contains('لبن'))) {
        return true;
      }
      if (aLower == 'eggs' &&
          (lower.contains('egg') ||
              lower.contains('albumin') ||
              lower.contains('بيض') ||
              lower.contains('صفار'))) {
        return true;
      }
      if (aLower == 'gluten' &&
          (lower.contains('wheat') ||
              lower.contains('bread') ||
              lower.contains('flour') ||
              lower.contains('barley') ||
              lower.contains('rye') ||
              lower.contains('قمح') ||
              lower.contains('خبز') ||
              lower.contains('جلوتين') ||
              lower.contains('شعير'))) {
        return true;
      }
      if (aLower == 'soy' &&
          (lower.contains('soy') ||
              lower.contains('tofu') ||
              lower.contains('edamame') ||
              lower.contains('صويا') ||
              lower.contains('توفو'))) {
        return true;
      }
      if (aLower == 'sesame' &&
          (lower.contains('sesame') ||
              lower.contains('tahini') ||
              lower.contains('سمسم') ||
              lower.contains('طحينة'))) {
        return true;
      }
      if (aLower == 'tree_nuts' &&
          (lower.contains('almond') ||
              lower.contains('walnut') ||
              lower.contains('cashew') ||
              lower.contains('hazelnut') ||
              lower.contains('مكسرات') ||
              lower.contains('لوز') ||
              lower.contains('جوز') ||
              lower.contains('كاجو'))) {
        return true;
      }
    }
    return false;
  }
}

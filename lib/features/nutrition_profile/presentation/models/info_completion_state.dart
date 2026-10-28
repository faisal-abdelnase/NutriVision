import 'package:equatable/equatable.dart';

import '../../domain/entities/nutrition_profile.dart';

enum MeasurementSystem { metric, imperial }

enum BiologicalSex { male, female, other }

enum DietaryGoalType { loseWeight, maintainWeight, gainMuscle, eatHealthier }

enum DietaryRegimenType {
  standard,
  highProtein,
  mediterranean,
  lowCarb,
  vegetarian,
  vegan,
}

class InfoCompletionData extends Equatable {
  const InfoCompletionData({
    this.system = MeasurementSystem.metric,
    this.sex = BiologicalSex.female,
    this.age = 28,
    this.heightCm = 178.0,
    this.weightKg = 74.5,
    this.activityMultiplier = 1.55,
    this.goal = DietaryGoalType.loseWeight,
    this.regimen = DietaryRegimenType.highProtein,
    this.selectedAllergens = const {'peanuts', 'seafood'},
    this.customAllergens = const ['Mustard (الخردل)'],
    this.selectedDislikes = const {
      'Mushrooms / الفطر',
      'Artificial Sweeteners / المحليات الصناعية',
    },
  });

  factory InfoCompletionData.fromNutritionProfile(NutritionProfile profile) {
    DietaryGoalType goalType = DietaryGoalType.loseWeight;
    for (final g in DietaryGoalType.values) {
      if (g.name.toLowerCase() == profile.goal?.toLowerCase()) {
        goalType = g;
        break;
      }
    }

    DietaryRegimenType regimenType = DietaryRegimenType.highProtein;
    if (profile.dietaryPreferences.isNotEmpty) {
      final first = profile.dietaryPreferences.first.toLowerCase();
      for (final r in DietaryRegimenType.values) {
        if (r.name.toLowerCase() == first) {
          regimenType = r;
          break;
        }
      }
    }

    final Set<String> allergens = {};
    final List<String> customs = [];
    const standardAllergens = {
      'peanuts',
      'seafood',
      'dairy',
      'eggs',
      'gluten',
      'soy',
      'tree_nuts',
      'sesame',
    };
    for (final a in profile.allergies) {
      if (standardAllergens.contains(a.toLowerCase())) {
        allergens.add(a.toLowerCase());
      } else {
        customs.add(a);
      }
    }

    final Set<String> dislikes = {};
    if (profile.dietaryPreferences.length > 1) {
      dislikes.addAll(profile.dietaryPreferences.skip(1));
    }

    return InfoCompletionData(
      age: profile.age ?? 28,
      heightCm: profile.heightCm ?? 178.0,
      weightKg: profile.weightKg ?? 74.5,
      goal: goalType,
      regimen: regimenType,
      selectedAllergens: allergens.isEmpty
          ? const {'peanuts', 'seafood'}
          : allergens,
      customAllergens: customs,
      selectedDislikes: dislikes,
    );
  }

  final MeasurementSystem system;
  final BiologicalSex sex;
  final int age;
  final double heightCm;
  final double weightKg;
  final double activityMultiplier;
  final DietaryGoalType goal;
  final DietaryRegimenType regimen;
  final Set<String> selectedAllergens;
  final List<String> customAllergens;
  final Set<String> selectedDislikes;

  double get bmr {
    switch (sex) {
      case BiologicalSex.male:
        return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
      case BiologicalSex.female:
        return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
      case BiologicalSex.other:
        return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 78;
    }
  }

  double get tdee => bmr * activityMultiplier;

  int get targetCalories {
    switch (goal) {
      case DietaryGoalType.loseWeight:
        return (tdee - 400).round().clamp(1200, 5000);
      case DietaryGoalType.maintainWeight:
        return tdee.round().clamp(1200, 5000);
      case DietaryGoalType.gainMuscle:
        return (tdee + 300).round().clamp(1200, 5000);
      case DietaryGoalType.eatHealthier:
        return (tdee - 50).round().clamp(1200, 5000);
    }
  }

  List<double> get macroPercentages {
    switch (goal) {
      case DietaryGoalType.loseWeight:
        return [0.35, 0.35, 0.30];
      case DietaryGoalType.maintainWeight:
        return [0.25, 0.50, 0.25];
      case DietaryGoalType.gainMuscle:
        return [0.30, 0.45, 0.25];
      case DietaryGoalType.eatHealthier:
        return [0.20, 0.50, 0.30];
    }
  }

  int get proteinGrams => ((targetCalories * macroPercentages[0]) / 4).round();
  int get carbGrams => ((targetCalories * macroPercentages[1]) / 4).round();
  int get fatGrams => ((targetCalories * macroPercentages[2]) / 9).round();

  String get glycemicAim {
    switch (goal) {
      case DietaryGoalType.loseWeight:
        return '< 110';
      case DietaryGoalType.maintainWeight:
        return '< 120';
      case DietaryGoalType.gainMuscle:
        return '< 125';
      case DietaryGoalType.eatHealthier:
        return '< 105';
    }
  }

  String get goalModeNameEn {
    switch (goal) {
      case DietaryGoalType.loseWeight:
        return 'Lose Weight Mode';
      case DietaryGoalType.maintainWeight:
        return 'Maintain Weight Mode';
      case DietaryGoalType.gainMuscle:
        return 'Gain Muscle Mode';
      case DietaryGoalType.eatHealthier:
        return 'Vitality & Diversity Mode';
    }
  }

  String get goalModeNameAr {
    switch (goal) {
      case DietaryGoalType.loseWeight:
        return 'نمط خسارة الوزن';
      case DietaryGoalType.maintainWeight:
        return 'نمط الحفاظ على الوزن';
      case DietaryGoalType.gainMuscle:
        return 'نمط بناء العضلات';
      case DietaryGoalType.eatHealthier:
        return 'نمط تحسين التغذية والحيوية';
    }
  }

  String get aiStrategyNoteEn {
    switch (goal) {
      case DietaryGoalType.loseWeight:
        return 'High dietary protein threshold (1.8g/kg) is prioritized during negative energy balance to spare myofibrillar lean tissue and suppress ghrelin spikes.';
      case DietaryGoalType.maintainWeight:
        return 'Iso-caloric equilibrium targeting micronutrient absorption efficiency, cellular energy homeostasis, and stabilized cortisol diurnal rhythms.';
      case DietaryGoalType.gainMuscle:
        return 'Anabolic hyper-partitioning ensures leucine trigger points (3.0g/meal) with sufficient carbohydrate replenishment for muscle glycogen resynthesis.';
      case DietaryGoalType.eatHealthier:
        return 'Focus shifts from pure macro ratios to phytonutrient diversity score, pre/probiotic fiber intake (>35g), and anti-inflammatory polyphenol loads.';
    }
  }

  String get aiStrategyNoteAr {
    switch (goal) {
      case DietaryGoalType.loseWeight:
        return 'يتم إعطاء الأولوية للبروتين العالي (١.٨ غ/كغ) أثناء عجز الطاقة للحفاظ على الكتلة العضلية والحد من ارتفاع هرمون الجوع.';
      case DietaryGoalType.maintainWeight:
        return 'توازن سعري كامل يستهدف كفاءة امتصاص العناصر الغذائية الصغرى، والحفاظ على توازن الطاقة واستقرار هرمون الكورتيزول.';
      case DietaryGoalType.gainMuscle:
        return 'توزيع بنائي محفز يضمن تفعيل مسار الليوسين (٣.٠ غ/وجبة) مع تعويض كافٍ للكربوهيدرات لإعادة ملء مخازن الجليكوجين.';
      case DietaryGoalType.eatHealthier:
        return 'التركيز ينتقل إلى تنوع المغذيات النباتية، وتناول ألياف حيوية تزيد عن ٣٥ غرام لتعزيز صحة الميكروبيوم ومقاومة الالتهابات.';
    }
  }

  InfoCompletionData copyWith({
    MeasurementSystem? system,
    BiologicalSex? sex,
    int? age,
    double? heightCm,
    double? weightKg,
    double? activityMultiplier,
    DietaryGoalType? goal,
    DietaryRegimenType? regimen,
    Set<String>? selectedAllergens,
    List<String>? customAllergens,
    Set<String>? selectedDislikes,
  }) {
    return InfoCompletionData(
      system: system ?? this.system,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      activityMultiplier: activityMultiplier ?? this.activityMultiplier,
      goal: goal ?? this.goal,
      regimen: regimen ?? this.regimen,
      selectedAllergens: selectedAllergens ?? this.selectedAllergens,
      customAllergens: customAllergens ?? this.customAllergens,
      selectedDislikes: selectedDislikes ?? this.selectedDislikes,
    );
  }

  @override
  List<Object?> get props => [
    system,
    sex,
    age,
    heightCm,
    weightKg,
    activityMultiplier,
    goal,
    regimen,
    selectedAllergens,
    customAllergens,
    selectedDislikes,
  ];
}

// import 'package:flutter/material.dart';

// import '../../../../core/extensions/context_extensions.dart';
// import '../../../../core/responsive/responsive_value.dart';
// import '../../../../core/theme/theme_dimensions.dart';
// import '../../../../core/theme/theme_extensions.dart';
// import '../../../../core/widgets/app_card.dart';
// import '../../../../core/widgets/macro_tile.dart';
// import '../../../../core/widgets/scaled_text.dart';
// import '../../domain/entities/daily_nutrition_summary.dart';

// class CalorieSummaryCard extends StatelessWidget {
//   const CalorieSummaryCard({super.key, required this.summary});

//   final DailyNutritionSummary summary;

//   @override
//   Widget build(BuildContext context) {
//     final n = context.nutritionColors;
//     final s = context.surfaceColors;
//     final consumed = summary.consumedCalories;
//     final target = summary.calorieTarget;
//     final hasTarget = target > 0;
//     final over = hasTarget && consumed > target;
//     final progress = hasTarget ? (consumed / target).clamp(0.0, 1.0) : 0.0;
//     final diff = target - consumed;

//     final remainingText = !hasTarget
//         ? context.tr('noCalorieTarget')
//         : over
//             ? context.tr('kcalOver', {'value': (-diff).round().toString()})
//             : context.tr('kcalRemaining', {'value': diff.round().toString()});

//     final size = responsiveValue<double>(context, xs: 140, md: 168);

//     return AppCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ScaledText(context.tr('caloriesLabel'),
//               style: context.textTheme.titleMedium),
//           const SizedBox(height: ThemeDimensions.spaceMd),
//           Center(
//             child: SizedBox.square(
//               dimension: size,
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   CircularProgressIndicator(
//                     value: progress,
//                     strokeWidth: 10,
//                     strokeCap: StrokeCap.round,
//                     backgroundColor: s.border,
//                     color: over ? context.statusColors.warning : n.calories,
//                   ),
//                   Center(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ScaledText(consumed.round().toString(),
//                             style: context.textTheme.headlineLarge),
//                         ScaledText(context.tr('kcalUnit'),
//                             style: context.textTheme.bodySmall),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: ThemeDimensions.spaceMd),
//           Center(
//             child: ScaledText(remainingText,
//                 textAlign: TextAlign.center,
//                 style: context.textTheme.bodyMedium),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MacroSummaryCard extends StatelessWidget {
//   const MacroSummaryCard({super.key, required this.summary});

//   final DailyNutritionSummary summary;

//   @override
//   Widget build(BuildContext context) {
//     final n = context.nutritionColors;
//     final p = summary.consumedProteinGrams;
//     final c = summary.consumedCarbohydrateGrams;
//     final f = summary.consumedFatGrams;

//     String grams(double v) =>
//         context.tr('gramsValue', {'value': v.round().toString()});

//     final energy = [p * 4, c * 4, f * 9];
//     final colors = [n.protein, n.carbohydrates, n.fats];
//     final total = energy.fold<double>(0, (a, b) => a + b);

//     return AppCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ScaledText(context.tr('macronutrients'),
//               style: context.textTheme.titleMedium),
//           const SizedBox(height: ThemeDimensions.space12),
//           Row(
//             children: [
//               Expanded(
//                 child: MacroTile(
//                   label: context.tr('protein'),
//                   value: grams(p),
//                   color: n.protein,
//                   softColor: n.proteinSoft,
//                 ),
//               ),
//               const SizedBox(width: ThemeDimensions.spaceSm),
//               Expanded(
//                 child: MacroTile(
//                   label: context.tr('carbohydrates'),
//                   value: grams(c),
//                   color: n.carbohydrates,
//                   softColor: n.carbohydratesSoft,
//                 ),
//               ),
//               const SizedBox(width: ThemeDimensions.spaceSm),
//               Expanded(
//                 child: MacroTile(
//                   label: context.tr('fat'),
//                   value: grams(f),
//                   color: n.fats,
//                   softColor: n.fatsSoft,
//                 ),
//               ),
//             ],
//           ),
//           if (total > 0) ...[
//             const SizedBox(height: ThemeDimensions.spaceMd),
//             ScaledText(context.tr('energyShare'),
//                 style: context.textTheme.bodySmall),
//             const SizedBox(height: 6),
//             ClipRRect(
//               borderRadius: ThemeDimensions.borderRadiusPill,
//               child: SizedBox(
//                 height: 8,
//                 child: Row(
//                   children: [
//                     for (var i = 0; i < 3; i++)
//                       if (energy[i] > 0)
//                         Expanded(
//                           flex: (energy[i] / total * 1000).round().clamp(1, 1000),
//                           child: ColoredBox(color: colors[i]),
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
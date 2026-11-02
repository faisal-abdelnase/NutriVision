// import 'package:flutter/material.dart';

// import '../../../../core/extensions/context_extensions.dart';
// import '../../../../core/theme/theme_dimensions.dart';
// import '../../../../core/utils/formatters.dart';
// import '../../../../core/widgets/app_card.dart';
// import '../../../../core/widgets/scaled_text.dart';
// import '../../../../core/widgets/state_views.dart';
// import '../../domain/entities/recent_meal_summary.dart';

// class RecentMealsCard extends StatelessWidget {
//   const RecentMealsCard({
//     super.key,
//     required this.meals,
//     required this.onOpenMeal,
//     required this.onAddMeal,
//   });

//   final List<RecentMealSummary> meals;
//   final ValueChanged<String> onOpenMeal;
//   final VoidCallback onAddMeal;

//   @override
//   Widget build(BuildContext context) {
//     final t = context.textTheme;
//     return AppCard(
//       padding: const EdgeInsets.symmetric(vertical: ThemeDimensions.spaceMd),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: ThemeDimensions.spaceMd),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ScaledText(context.tr('recentMeals'),
//                       style: t.titleMedium),
//                 ),
//                 TextButton.icon(
//                   onPressed: onAddMeal,
//                   icon: const Icon(Icons.add, size: 18),
//                   label: Text(context.tr('addMealAction')),
//                 ),
//               ],
//             ),
//           ),
//           if (meals.isEmpty)
//             Padding(
//               padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
//               child: AppEmptyView(
//                 icon: Icons.restaurant_outlined,
//                 message: context.tr('noMealsYet'),
//                 actionLabel: context.tr('addMealAction'),
//                 onAction: onAddMeal,
//               ),
//             )
//           else
//             for (final meal in meals)
//               ListTile(
//                 onTap: () => onOpenMeal(meal.mealId),
//                 leading: const Icon(Icons.restaurant_outlined),
//                 title: ScaledText(meal.name,
//                     style: t.titleSmall,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis),
//                 subtitle: ScaledText(Formatters.dateTime(meal.eatenAt),
//                     style: t.bodySmall),
//                 trailing: ScaledText(
//                   context.tr('kcalValue',
//                       {'value': meal.calories.round().toString()}),
//                   style: t.labelLarge,
//                 ),
//               ),
//         ],
//       ),
//     );
//   }
// }
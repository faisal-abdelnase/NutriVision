import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../domain/entities/meal.dart';
import '../../../domain/entities/meal_ingredient.dart';
import '../../cubit/meal_cubit.dart';
import '../../cubit/meal_state.dart';
import '../../../../progress/presentation/cubit/progress_cubit.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../addmeal/widgets/top_header_bar.dart';
import '../../addmeal/widgets/architecture_cards.dart';
import '../widgets/ai_clinical_intelligence_card.dart';
import '../widgets/analyzed_ingredients_card.dart';
import '../widgets/macronutrient_architecture_card.dart';
import '../widgets/meal_hero_card.dart';
import '../widgets/smart_swaps_card.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key, this.mealId, this.userId});

  final String? mealId;
  final String? userId;

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  @override
  void initState() {
    super.initState();
    _loadMeal();
  }

  @override
  void didUpdateWidget(covariant MealDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mealId != widget.mealId ||
        oldWidget.userId != widget.userId) {
      _loadMeal();
    }
  }

  void _loadMeal() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (widget.mealId != null && uid != null && widget.userId == uid) {
      debugPrint('[MEAL_DETAILS] Authenticated UID present: true');
      debugPrint('[MEAL_DETAILS] Requested meal ID: ${widget.mealId}');
      context.read<MealCubit>().getMealById(
        mealId: widget.mealId!,
        userId: uid,
      );
    }
  }

  Future<void> _deleteMeal(BuildContext context, Meal meal) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid != widget.userId) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete meal?'),
        content: Text('Delete ${meal.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<MealCubit>().deleteMeal(mealId: meal.id, userId: uid);
    if (!context.mounted) return;
    final state = context.read<MealCubit>().state;
    if (state is MealOperationSuccess) {
      await _refreshProgress(context);
      if (context.mounted) Navigator.of(context).pop(true);
    }
    if (state is MealError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  Future<void> _editMeal(BuildContext context, Meal meal) async {
    final name = TextEditingController(text: meal.name);
    final description = TextEditingController(text: meal.description ?? '');
    final portions = TextEditingController(text: '1');
    final values = await showDialog<(String, String, double)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: portions,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Portion multiplier',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final multiplier = double.tryParse(portions.text.trim());
              if (name.text.trim().isNotEmpty &&
                  multiplier != null &&
                  multiplier > 0) {
                Navigator.pop(dialogContext, (
                  name.text.trim(),
                  description.text.trim(),
                  multiplier,
                ));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    name.dispose();
    description.dispose();
    portions.dispose();
    if (values == null || !context.mounted) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid != widget.userId) return;
    final factor = values.$3;
    final updated = Meal(
      id: meal.id,
      userId: uid,
      name: values.$1,
      description: values.$2.isEmpty ? null : values.$2,
      mealType: meal.mealType,
      ingredients: meal.ingredients
          .map(
            (item) => MealIngredient(
              name: item.name,
              quantity: item.quantity * factor,
              unit: item.unit,
              foodId: item.foodId,
            ),
          )
          .toList(),
      calories: meal.calories * factor,
      proteinGrams: meal.proteinGrams * factor,
      carbohydrateGrams: meal.carbohydrateGrams * factor,
      fatGrams: meal.fatGrams * factor,
      eatenAt: meal.eatenAt,
      createdAt: meal.createdAt,
      updatedAt: DateTime.now(),
    );
    await context.read<MealCubit>().updateMeal(meal: updated);
    if (!context.mounted) return;
    final state = context.read<MealCubit>().state;
    if (state is MealOperationSuccess) {
      await _refreshProgress(context);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null)
        await context.read<MealCubit>().getMealById(
          mealId: meal.id,
          userId: uid,
        );
    } else if (state is MealError) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  Future<void> _refreshProgress(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final today = DateTime.now();
    final end = DateTime(
      today.year,
      today.month,
      today.day,
    ).add(const Duration(days: 1));
    await context.read<ProgressCubit>().loadProgress(
      userId: uid,
      startDate: end.subtract(const Duration(days: 7)),
      endDate: end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || widget.userId != uid) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meal Details')),
        body: const Center(
          child: Text('Authentication is required to view this meal.'),
        ),
      );
    }
    if (widget.mealId == null) {
      return const Scaffold(
        body: Center(child: Text('Select a meal to view details.')),
      );
    }
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        if (state is MealLoading || state is MealInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is MealError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Meal Details')),
            body: Center(child: Text(state.message)),
          );
        }
        if (state is! MealDetailsLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildMealDetails(context, state.meal);
      },
    );
  }

  Widget _buildMealDetails(BuildContext context, Meal meal) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: !isDesktop
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.darkText),
              title: const Text(
                'Meal Details • تفاصيل الوجبة',
                style: TextStyle(color: AppColors.darkText, fontSize: 15),
              ),
            )
          : null,
      // drawer: !isDesktop ? const Drawer(child: SidebarWidget()) : null,
      body: Row(
        children: [
          // if (isDesktop) const SidebarWidget(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopHeaderBar(),
                  const SizedBox(height: 16),

                  // Header Controls Row (Save / Edit / Delete)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      bool isSmall = constraints.maxWidth < 650;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meal Details تفاصيل الوجبة',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${meal.id}',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppColors.mutedText,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                              if (!isSmall)
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.favorite_border,
                                        size: 12,
                                      ),
                                      label: const Text(
                                        'Save Favorite',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    OutlinedButton.icon(
                                      onPressed: () => _editMeal(context, meal),
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        size: 12,
                                      ),
                                      label: const Text(
                                        'Edit Meal',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    OutlinedButton.icon(
                                      onPressed: () =>
                                          _deleteMeal(context, meal),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 12,
                                        color: Colors.red,
                                      ),
                                      label: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          if (isSmall) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Favorite',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                OutlinedButton(
                                  onPressed: () => _editMeal(context, meal),
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                OutlinedButton(
                                  onPressed: () => _deleteMeal(context, meal),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Main 2-Column Responsive Matrix
                  isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Side
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  MealHeroCard(meal: meal),
                                  SizedBox(height: 16),
                                  AnalyzedIngredientsCard(meal: meal),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Right Side
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  MacronutrientArchitectureCard(meal: meal),
                                  SizedBox(height: 16),
                                  AiClinicalIntelligenceCard(),
                                  SizedBox(height: 16),
                                  SmartSwapsCard(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            MealHeroCard(meal: meal),
                            SizedBox(height: 16),
                            MacronutrientArchitectureCard(meal: meal),
                            SizedBox(height: 16),
                            AnalyzedIngredientsCard(meal: meal),
                            SizedBox(height: 16),
                            AiClinicalIntelligenceCard(),
                            SizedBox(height: 16),
                            SmartSwapsCard(),
                          ],
                        ),

                  const SizedBox(height: 20),
                  const ArchitectureCards(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

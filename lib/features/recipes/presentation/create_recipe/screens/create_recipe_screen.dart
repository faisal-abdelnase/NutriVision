import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nutri_vision/core/theme/theme_extensions.dart';
import 'package:nutri_vision/core/routing/route_names.dart';
import 'package:nutri_vision/core/localization/app_localizations.dart';
import 'package:nutri_vision/core/widgets/content_container.dart';
import 'package:nutri_vision/core/widgets/state_message_view.dart';
import 'package:nutri_vision/features/meal_analysis/presentation/pages/meal_analysis_page.dart';
import 'package:nutri_vision/features/recipes/data/models/recipe_meal_analysis_mapper.dart';
import 'package:nutri_vision/features/recipes/domain/entities/recipe.dart';
import 'package:nutri_vision/features/recipes/presentation/cubit/recipes_cubit.dart';
import 'package:nutri_vision/features/recipes/presentation/cubit/recipes_state.dart';

import '../widgets/chips_input_field.dart';
import '../widgets/generated_recipe_card.dart';
import '../widgets/option_chips.dart';
import '../widgets/recipe_form_section.dart';
import '../widgets/servings_stepper.dart';

class CreateRecipeScreen extends StatelessWidget {
  const CreateRecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: StateMessageView(
          icon: Icons.lock_outline,
          title: 'Please sign in first',
        ),
      );
    }

    return BlocProvider(
      create: (_) => GetIt.instance<RecipesCubit>(),
      child: _CreateRecipeView(userId: userId),
    );
  }
}

class _CreateRecipeView extends StatefulWidget {
  const _CreateRecipeView({required this.userId});
  final String userId;

  @override
  State<_CreateRecipeView> createState() => _CreateRecipeViewState();
}

class _CreateRecipeViewState extends State<_CreateRecipeView> {
  static const _diets = [
    'Vegetarian',
    'Vegan',
    'Keto',
    'Low-carb',
    'Gluten-free',
    'High-protein',
  ];
  static const _goals = [
    'Lose weight',
    'Maintain weight',
    'Build muscle',
    'Eat healthier',
  ];

  final _resultKey = GlobalKey();
  List<String> _ingredients = [];
  List<String> _allergies = [];
  final Set<String> _selectedDiets = {};
  String? _goal;
  int _servings = 2;
  Recipe? _recipe;

  void _generate() {
    FocusScope.of(context).unfocus();
    context.read<RecipesCubit>().generateRecipe(
      userId: widget.userId,
      availableIngredients: _ingredients,
      dietaryPreferences: _selectedDiets.toList(),
      allergies: _allergies,
      goal: _goal,
      servings: _servings,
      languageCode: Localizations.localeOf(context).languageCode,
    );
  }

  void _scrollToResult() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _resultKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Recipe')),
      body: BlocConsumer<RecipesCubit, RecipesState>(
        listener: (context, state) {
          if (state is RecipeGenerated) {
            setState(() => _recipe = state.recipe);
            Navigator.of(context).pushNamed(
              RouteNames.mealAnalysis,
              arguments: MealAnalysisRouteArguments.fromResult(
                RecipeMealAnalysisMapper.map(state.recipe, widget.userId),
              ),
            );
          } else if (state is RecipesOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is RecipesError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).translate(
                    state.message.contains('FormatException')
                        ? 'recipeInvalid'
                        : 'recipeFailed',
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final loading = state is RecipesLoading;

          return ContentContainer(
            maxWidth: 720,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                RecipeFormSection(
                  title: 'What do you have?',
                  subtitle: 'Type an ingredient and press add.',
                  child: ChipsInputField(
                    hint: 'e.g. chicken breast',
                    values: _ingredients,
                    onChanged: (v) => setState(() => _ingredients = v),
                  ),
                ),
                const SizedBox(height: 12),
                RecipeFormSection(
                  title: 'Dietary preferences',
                  child: OptionChips(
                    options: _diets,
                    selected: _selectedDiets,
                    onToggle: (v) => setState(() {
                      _selectedDiets.contains(v)
                          ? _selectedDiets.remove(v)
                          : _selectedDiets.add(v);
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                RecipeFormSection(
                  title: 'Allergies',
                  child: ChipsInputField(
                    hint: 'e.g. peanuts',
                    values: _allergies,
                    onChanged: (v) => setState(() => _allergies = v),
                  ),
                ),
                const SizedBox(height: 12),
                RecipeFormSection(
                  title: 'Your goal',
                  child: OptionChips(
                    options: _goals,
                    selected: {if (_goal != null) _goal!},
                    onToggle: (v) =>
                        setState(() => _goal = _goal == v ? null : v),
                  ),
                ),
                const SizedBox(height: 12),
                RecipeFormSection(
                  title: 'Servings',
                  child: ServingsStepper(
                    value: _servings,
                    onChanged: (v) => setState(() => _servings = v),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: loading ? null : _generate,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(AIThemeColors.icon),
                  label: Text(
                    loading
                        ? AppLocalizations.of(
                            context,
                          ).translate('recipeGenerating')
                        : AppLocalizations.of(
                            context,
                          ).translate('recipeGenerate'),
                  ),
                ),
                if (_recipe != null) ...[
                  const SizedBox(height: 24),
                  KeyedSubtree(
                    key: _resultKey,
                    child: GeneratedRecipeCard(
                      recipe: _recipe!,
                      onSave: () => context.read<RecipesCubit>().saveRecipe(
                        userId: widget.userId,
                        recipeId: _recipe!.id,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

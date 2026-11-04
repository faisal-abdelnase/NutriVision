import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../meal_analysis/domain/entities/meal_analysis_request.dart';
import '../../../../meal_analysis/presentation/cubit/meal_analysis_cubit.dart';
import '../../../../meal_analysis/presentation/cubit/meal_analysis_state.dart';
import '../../../../meal_analysis/presentation/pages/meal_analysis_page.dart';
import '../widgets/describe_meal_card.dart';
import '../widgets/vision_ai_card.dart';
import '../widgets/search_database_card.dart';
import '../widgets/synthesis_action_banner.dart';
import '../widgets/architecture_cards.dart';
import '../widgets/top_header_bar.dart';

class AddMealScreen extends StatelessWidget {
  const AddMealScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => GetIt.instance<MealAnalysisCubit>(),
    child: _AddMealForm(onBack: onBack),
  );
}

class _AddMealForm extends StatefulWidget {
  const _AddMealForm({this.onBack});

  final VoidCallback? onBack;

  @override
  State<_AddMealForm> createState() => _AddMealFormState();
}

class _AddMealFormState extends State<_AddMealForm> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to analyze and save a meal.')),
      );
      return;
    }
    await context.read<MealAnalysisCubit>().analyzeText(
      request: MealAnalysisRequest(
        userId: user.uid,
        description: _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 900;
    return BlocListener<MealAnalysisCubit, MealAnalysisState>(
      listenWhen: (_, state) =>
          state is MealAnalysisSuccess || state is MealAnalysisFailure,
      listener: (context, state) {
        if (state is MealAnalysisSuccess) {
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => MealAnalysisPage(initialResult: state.result),
            ),
          );
        } else if (state is MealAnalysisFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: !desktop
            ? AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0,
                automaticallyImplyLeading: widget.onBack == null,
                leading: widget.onBack == null
                    ? null
                    : IconButton(
                        onPressed: widget.onBack,
                        icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
                      ),
                iconTheme: const IconThemeData(color: AppColors.darkText),
                title: const Text(
                  'NutriVision Clinical',
                  style: TextStyle(color: AppColors.darkText, fontSize: 16),
                ),
              )
            : null,
        body: BlocBuilder<MealAnalysisCubit, MealAnalysisState>(
          builder: (context, state) {
            final isLoading = state is MealAnalysisLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopHeaderBar(),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 14,
                      color: AppColors.primaryTeal,
                    ),
                    label: const Text(
                      'Back to Dashboard',
                      style: TextStyle(
                        color: AppColors.primaryTeal,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(
                    'Add a Meal',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Describe your meal to receive a nutrition analysis.',
                    style: TextStyle(color: AppColors.mutedText, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: DescribeMealCard(
                      controller: _descriptionController,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Enter a meal description.'
                          : value.trim().length < 3
                          ? 'Add a little more detail about your meal.'
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (desktop)
                    const Row(
                      children: [
                        Expanded(child: VisionAiCard()),
                        SizedBox(width: 16),
                        Expanded(child: SearchDatabaseCard()),
                      ],
                    )
                  else
                    const Column(
                      children: [
                        VisionAiCard(),
                        SizedBox(height: 16),
                        SearchDatabaseCard(),
                      ],
                    ),
                  const SizedBox(height: 20),
                  SynthesisActionBanner(
                    onAnalyze: _analyze,
                    isLoading: isLoading,
                  ),
                  if (state is MealAnalysisFailure) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _analyze,
                        child: const Text('Retry analysis'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const ArchitectureCards(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

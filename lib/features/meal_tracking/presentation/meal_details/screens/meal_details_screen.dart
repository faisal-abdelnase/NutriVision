import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../addmeal/widgets/sidebar_widget.dart';
import '../../addmeal/widgets/top_header_bar.dart';
import '../../addmeal/widgets/architecture_cards.dart';
import '../widgets/ai_clinical_intelligence_card.dart';
import '../widgets/analyzed_ingredients_card.dart';
import '../widgets/macronutrient_architecture_card.dart';
import '../widgets/meal_hero_card.dart';
import '../widgets/smart_swaps_card.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      drawer: !isDesktop ? const Drawer(child: SidebarWidget()) : null,
      body: Row(
        children: [
          if (isDesktop) const SidebarWidget(),

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
                                children: const [
                                  Text(
                                    'Meal Details تفاصيل الوجبة',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkText,
                                    ),
                                  ),
                                  Text(
                                    'ID: MLG-9402-A',
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
                                      onPressed: () {},
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
                                      onPressed: () {},
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
                                  onPressed: () {},
                                  child: const Text(
                                    'Edit',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                OutlinedButton(
                                  onPressed: () {},
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
                                children: const [
                                  MealHeroCard(),
                                  SizedBox(height: 16),
                                  AnalyzedIngredientsCard(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Right Side
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: const [
                                  MacronutrientArchitectureCard(),
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
                          children: const [
                            MealHeroCard(),
                            SizedBox(height: 16),
                            MacronutrientArchitectureCard(),
                            SizedBox(height: 16),
                            AnalyzedIngredientsCard(),
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

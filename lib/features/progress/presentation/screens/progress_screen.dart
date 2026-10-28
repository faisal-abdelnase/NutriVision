import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/architecture_cards.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/sidebar_widget.dart';
import '../../../meal_tracking/presentation/addmeal/widgets/top_header_bar.dart';
import '../widgets/caloric_equilibrium_card.dart';
import '../widgets/macronutrient_trajectories_card.dart';
import '../widgets/micro_and_paddings_card.dart';
import '../widgets/progress_summary_cards.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

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
                'Your Progress',
                style: TextStyle(color: AppColors.darkText, fontSize: 16),
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

                  // Header Controls Row
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
                                    'Your Progress',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkText,
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
                                        Icons.picture_as_pdf_outlined,
                                        size: 14,
                                      ),
                                      label: const Text(
                                        'Export PDF Report',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.share, size: 14),
                                      label: const Text(
                                        'Share with Dietitian',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryTeal,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Track longitudinal caloric balance, macronutrient distribution trends, and metabolic compliance across clinical cycles.',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.mutedText,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  const ProgressSummaryCards(),
                  const SizedBox(height: 16),

                  const CaloricEquilibriumCard(),
                  const SizedBox(height: 16),

                  const MacronutrientTrajectoriesCard(),
                  const SizedBox(height: 16),

                  const MicroAndPaddingsCard(),
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

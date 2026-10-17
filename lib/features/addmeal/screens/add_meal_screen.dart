import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/sidebar_widget.dart';
import '../widgets/top_header_bar.dart';
import '../widgets/describe_meal_card.dart';
import '../widgets/vision_ai_card.dart';
import '../widgets/search_database_card.dart';
import '../widgets/synthesis_action_banner.dart';
import '../widgets/architecture_cards.dart';

class AddMealScreen extends StatelessWidget {
  const AddMealScreen({Key? key}) : super(key: key);

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
        title: const Text('NutriVision Clinical', style: TextStyle(color: AppColors.darkText, fontSize: 16)),
      )
          : null,
      drawer: !isDesktop ? const Drawer(child: SidebarWidget()) : null,
      body: Row(
        children: [
          // 1. Sidebar Left (فقط للشاشات الكبيرة)
          if (isDesktop) const SidebarWidget(),

          // 2. Main Dashboard Content Right
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header
                  const TopHeaderBar(),
                  const SizedBox(height: 20),

                  // Back Button & Engine Specs Row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 700) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_back, size: 14, color: AppColors.primaryTeal),
                              label: const Text('Back to Dashboard', style: TextStyle(color: AppColors.primaryTeal, fontSize: 12, fontWeight: FontWeight.bold)),
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            ),
                            const Text('Add a Meal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                            const SizedBox(height: 4),
                            const Text(
                              'How would you like to add your meal today? Choose multimodal AI input or clinical database lookup.',
                              style: TextStyle(color: AppColors.mutedText, fontSize: 12),
                            ),
                          ],
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_back, size: 14, color: AppColors.primaryTeal),
                                label: const Text('Back to Dashboard', style: TextStyle(color: AppColors.primaryTeal, fontSize: 12, fontWeight: FontWeight.bold)),
                                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              ),
                              const Text('Add a Meal', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                              const SizedBox(height: 4),
                              const Text(
                                'How would you like to add your meal today? Choose multimodal AI input or clinical database lookup.',
                                style: TextStyle(color: AppColors.mutedText, fontSize: 12),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.hub_outlined, color: AppColors.primaryTeal, size: 20),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('CLINICAL ENGINE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.mutedText)),
                                    Text('Gemini Multimodal 2.5 + USDA Rev 28', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Inputs Section (تتحول إلى عمود رأسي على الهاتف، وبجانب بعضها على الشاشات الكبيرة)
                  isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Expanded(child: DescribeMealCard()),
                      SizedBox(width: 16),
                      Expanded(child: VisionAiCard()),
                      SizedBox(width: 16),
                      Expanded(child: SearchDatabaseCard()),
                    ],
                  )
                      : Column(
                    children: const [
                      DescribeMealCard(),
                      SizedBox(height: 16),
                      VisionAiCard(),
                      SizedBox(height: 16),
                      SearchDatabaseCard(),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Synthesis Banner
                  const SynthesisActionBanner(),

                  const SizedBox(height: 20),

                  // Flutter Architecture Spec Section
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
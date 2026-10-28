import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class ArchitectureCards extends StatelessWidget {
  const ArchitectureCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: const [
                  Icon(Icons.code, size: 16, color: AppColors.primaryTeal),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Flutter & Riverpod Multiplatform Architecture Contract',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'SPEC: v4.2.0-CLINICAL',
                style: TextStyle(
                  fontSize: 9,
                  color: Color(0xFF0369A1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // استخدام LayoutBuilder لتقسيم الكروت إلى عمود أو صف حسب مساحة الشاشة لتجنب الـ Overflow تماماً
        LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth >= 750;

            final cardsList = [
              _buildCard(
                '1. RIVERPOD NOTIFIER',
                'MealAnalysisNotifier',
                'Implements immutable AsyncValue<MealTelemetryPayload> with undo/redo draft rollback and optimistic offline caching.',
              ),
              _buildCard(
                '2. AI PIPELINE CHAIN',
                'Whisper NLP + Gemini Vision',
                'Edge Whisper model captures audio tokens. Gemini CV calculates 3D bounding geometry, with USDA FoodData fallback on low telemetry latency.',
              ),
              _buildCard(
                '3. RESPONSIVE LAYOUT',
                'AdaptiveBreakpoint Layout',
                'Mobile: Single-column modal sheet (<640dp), Tablet: 2-column split, Desktop: 3-column synchronized matrix (>1024dp).',
              ),
              _buildCard(
                '4. WCAG & HAPTICS',
                'HapticFeedback.lightImpact()',
                'WCAG AAA 7:1 contrast tokens across all bio-metrics. Dynamic Type scaling and bidirectional RTL mirror handling.',
              ),
            ];

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cardsList
                    .map(
                      (card) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: card,
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return Column(
                children: cardsList
                    .map(
                      (card) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: card,
                      ),
                    )
                    .toList(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildCard(String title, String tag, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 8,
                fontFamily: 'monospace',
                color: AppColors.mutedText,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.mutedText,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

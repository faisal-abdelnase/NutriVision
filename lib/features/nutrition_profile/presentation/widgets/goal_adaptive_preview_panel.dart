import 'package:flutter/material.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../models/info_completion_state.dart';

class GoalAdaptivePreviewPanel extends StatelessWidget {
  const GoalAdaptivePreviewPanel({
    super.key,
    required this.data,
    required this.surfaces,
    required this.isDark,
    required this.isRtl,
  });

  final InfoCompletionData data;
  final AppSurfaceColors surfaces;
  final bool isDark;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final panelBg = isDark
        ? ThemeColors.darkSurface1
        : ThemeColors.stitchSurfaceContainer;
    final tileBg = isDark
        ? ThemeColors.darkSurface2
        : ThemeColors.stitchSurfaceContainerLowest;
    final border = isDark ? ThemeColors.darkBorder : ThemeColors.slate200;

    final pPct = (data.macroPercentages[0] * 100).round();
    final cPct = (data.macroPercentages[1] * 100).round();
    final fPct = (data.macroPercentages[2] * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeDimensions.spaceLg),
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: ThemeColors.stitchPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRtl
                            ? 'معاينة النموذج الحيوي الديناميكي'
                            : 'DYNAMIC BIO-MODEL PREVIEW',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                          color: ThemeColors.stitchPrimary,
                        ),
                      ),
                      Text(
                        isRtl
                            ? 'المستهدفات الأيضية المتوقعة'
                            : 'Projected Metabolic Targets',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: surfaces.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? ThemeColors.darkSurface2
                      : ThemeColors.stitchSurfaceContainerLowest,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.auto_awesome_rounded,
                      size: 15,
                      color: ThemeColors.stitchPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isRtl ? data.goalModeNameAr : data.goalModeNameEn,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.stitchPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 720;
              final tile1 = _buildTargetCaloriesTile(tileBg, border);
              final tile2 = _buildGlycemicAimTile(tileBg, border);
              final tile3 = _buildMacroPartitionTile(
                tileBg,
                border,
                pPct,
                cPct,
                fPct,
              );

              if (isWide) {
                return Row(
                  children: [
                    Expanded(child: tile1),
                    const SizedBox(width: 12),
                    Expanded(child: tile2),
                    const SizedBox(width: 12),
                    Expanded(child: tile3),
                  ],
                );
              } else {
                return Column(
                  children: [
                    tile1,
                    const SizedBox(height: 10),
                    tile2,
                    const SizedBox(height: 10),
                    tile3,
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
            decoration: BoxDecoration(
              color: isDark
                  ? ThemeColors.darkSurface2
                  : ThemeColors.stitchSurfaceContainerLowest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.tips_and_updates_rounded,
                  color: ThemeColors.stitchPrimary,
                  size: 22,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isRtl
                            ? 'ملاحظة الاستراتيجية السريرية للذكاء الاصطناعي'
                            : 'NutriVision AI Clinical Strategy Note',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ThemeColors.stitchPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isRtl ? data.aiStrategyNoteAr : data.aiStrategyNoteEn,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: surfaces.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCaloriesTile(Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRtl ? 'الحد الأدنى المستهدف للسعرات' : 'Caloric Floor Target',
                style: const TextStyle(
                  fontSize: 12,
                  color: ThemeColors.slate500,
                ),
              ),
              const Icon(
                Icons.bolt_rounded,
                size: 18,
                color: Color(0xFFF97316),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatNumber(data.targetCalories),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: surfaces.textPrimary,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isRtl ? 'سعرة / يوم' : 'kcal / day',
                style: const TextStyle(
                  fontSize: 11,
                  color: ThemeColors.slate500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 6,
              color: ThemeColors.slate200,
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: (data.targetCalories / 3500).clamp(0.2, 1.0),
                child: Container(color: ThemeColors.stitchPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlycemicAimTile(Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRtl
                    ? 'استقرار سكر الدم المستهدف'
                    : 'Postprandial Glycemic Aim',
                style: const TextStyle(
                  fontSize: 12,
                  color: ThemeColors.slate500,
                ),
              ),
              const Icon(
                Icons.show_chart_rounded,
                size: 18,
                color: Color(0xFF0284C7),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                data.glycemicAim,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: surfaces.textPrimary,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(width: 4),
              Text(
                isRtl ? 'ملغ/ديسيلتر مستقر' : 'mg/dL steady',
                style: const TextStyle(
                  fontSize: 11,
                  color: ThemeColors.slate500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 14,
                color: ThemeColors.stitchPrimary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  isRtl
                      ? 'نطاق الحساسية المثلى للإنسولين'
                      : 'Optimal insulin sensitivity zone',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: ThemeColors.stitchPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroPartitionTile(
    Color bg,
    Color border,
    int pPct,
    int cPct,
    int fPct,
  ) {
    return Container(
      padding: const EdgeInsets.all(ThemeDimensions.spaceMd),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRtl ? 'توزيع المغذيات الكبرى' : 'Macro Partitioning',
                style: const TextStyle(
                  fontSize: 12,
                  color: ThemeColors.slate500,
                ),
              ),
              const Icon(
                Icons.pie_chart_rounded,
                size: 18,
                color: ThemeColors.stitchPrimary,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: pPct,
                    child: Container(color: ThemeColors.stitchPrimary),
                  ),
                  Expanded(
                    flex: cPct,
                    child: Container(color: const Color(0xFF0284C7)),
                  ),
                  Expanded(
                    flex: fPct,
                    child: Container(color: const Color(0xFFEA580C)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroTag(
                isRtl ? '$pPct% بروتين' : '$pPct% P',
                ThemeColors.stitchPrimary,
              ),
              _buildMacroTag(
                isRtl ? '$cPct% كارب' : '$cPct% C',
                const Color(0xFF0284C7),
              ),
              _buildMacroTag(
                isRtl ? '$fPct% دهون' : '$fPct% F',
                const Color(0xFFEA580C),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroTag(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  static String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

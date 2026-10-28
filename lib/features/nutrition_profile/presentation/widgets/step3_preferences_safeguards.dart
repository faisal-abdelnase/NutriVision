import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_colors.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/theme/theme_text_styles.dart';
import '../models/info_completion_state.dart';
import 'allergens_safeguard_selector.dart';
import 'dietary_regimen_selector.dart';
import 'food_dislikes_selector.dart';
import 'safety_telemetry_card.dart';

class Step3PreferencesSafeguards extends StatelessWidget {
  const Step3PreferencesSafeguards({
    super.key,
    required this.data,
    required this.onDataChanged,
    required this.onComplete,
    required this.onBack,
    required this.onSkip,
  });

  final InfoCompletionData data;
  final ValueChanged<InfoCompletionData> onDataChanged;
  final VoidCallback onComplete;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  void _addCustomAllergen(String text) {
    if (!data.customAllergens.contains(text)) {
      final updated = List<String>.from(data.customAllergens)..add(text);
      onDataChanged(data.copyWith(customAllergens: updated));
    }
  }

  void _removeCustomAllergen(String allergen) {
    final updated = List<String>.from(data.customAllergens)..remove(allergen);
    onDataChanged(data.copyWith(customAllergens: updated));
  }

  void _toggleAllergen(String key) {
    final current = Set<String>.from(data.selectedAllergens);
    if (current.contains(key)) {
      current.remove(key);
    } else {
      current.add(key);
    }
    onDataChanged(data.copyWith(selectedAllergens: current));
  }

  void _toggleDislike(String dislike) {
    final current = Set<String>.from(data.selectedDislikes);
    if (current.contains(dislike)) {
      current.remove(dislike);
    } else {
      current.add(dislike);
    }
    onDataChanged(data.copyWith(selectedDislikes: current));
  }

  @override
  Widget build(BuildContext context) {
    final surfaces = context.surfaceColors;
    final isDark = context.isDarkMode;
    final locale = Localizations.localeOf(context);
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        locale.languageCode == 'ar';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeDimensions.marginMobile,
        vertical: ThemeDimensions.spaceLg,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(surfaces, locale, isRtl),
              const SizedBox(height: ThemeDimensions.spaceXl),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 990;

                  final leftForm = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DietaryRegimenSelector(
                        selectedRegimen: data.regimen,
                        onRegimenChanged: (regimen) =>
                            onDataChanged(data.copyWith(regimen: regimen)),
                        surfaces: surfaces,
                        isDark: isDark,
                        isRtl: isRtl,
                      ),
                      const SizedBox(height: ThemeDimensions.spaceLg),

                      AllergensSafeguardSelector(
                        selectedAllergens: data.selectedAllergens,
                        customAllergens: data.customAllergens,
                        onToggleAllergen: _toggleAllergen,
                        onAddCustomAllergen: _addCustomAllergen,
                        onRemoveCustomAllergen: _removeCustomAllergen,
                        surfaces: surfaces,
                        isDark: isDark,
                        isRtl: isRtl,
                      ),
                      const SizedBox(height: ThemeDimensions.spaceLg),

                      FoodDislikesSelector(
                        selectedDislikes: data.selectedDislikes,
                        onToggleDislike: _toggleDislike,
                        surfaces: surfaces,
                        isDark: isDark,
                        isRtl: isRtl,
                      ),
                    ],
                  );

                  final rightSidebar = SafetyTelemetryCard(
                    data: data,
                    surfaces: surfaces,
                    isDark: isDark,
                    isRtl: isRtl,
                  );

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 8, child: leftForm),
                        const SizedBox(width: ThemeDimensions.gutterDesktop),
                        Expanded(flex: 4, child: rightSidebar),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        leftForm,
                        const SizedBox(height: ThemeDimensions.spaceXl),
                        rightSidebar,
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: ThemeDimensions.spaceXl),

              _buildNavigationBar(surfaces, isDark, isRtl),
              const SizedBox(height: ThemeDimensions.spaceLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    AppSurfaceColors surfaces,
    Locale locale,
    bool isRtl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: ThemeColors.stitchPrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.verified_rounded,
                size: 16,
                color: ThemeColors.stitchPrimary,
              ),
              const SizedBox(width: 6),
              Text(
                isRtl
                    ? 'بروتوكول السلامة الصارم المعتمد (CODEX • FDA-2024)'
                    : 'Deterministic Zero-Error Safety Protocol (CODEX • FDA-2024)',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: ThemeColors.stitchPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isRtl
              ? 'خصص قواعدك وتفضيلاتك الغذائية وموانع الحساسية'
              : 'Customize your nutrition rules & safeguards',
          style: TextStyle(
            fontFamily: ThemeTextStyles.headingFamilyFor(locale),
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: surfaces.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Text(
            isRtl
                ? 'يطبق NutriVision خوارزميات استبعاد طبية متقدمة للحماية من التلوث التبادلي للمسببات الحساسة وضمان توافق تام لكافة الوصفات المقترحة مع متطلباتك الصحية وأسلوب حياتك.'
                : 'NutriVision applies medical-grade exclusion algorithms to protect against cross-contamination allergens and strictly align AI-driven recipe generation and glycemic swap recommendations with your lifestyle requirements.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: surfaces.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationBar(
    AppSurfaceColors surfaces,
    bool isDark,
    bool isRtl,
  ) {
    final nextIcon = isRtl
        ? Icons.arrow_back_rounded
        : Icons.arrow_forward_rounded;
    final backIcon = isRtl
        ? Icons.arrow_forward_rounded
        : Icons.arrow_back_rounded;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 600;

        final backBtn = OutlinedButton.icon(
          onPressed: onBack,
          icon: Icon(backIcon, size: 18),
          label: Text(
            isRtl ? 'العودة للأهداف الغذائية' : 'Back to Dietary Goals',
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            side: BorderSide(
              color: isDark ? ThemeColors.darkBorder : ThemeColors.slate200,
            ),
            foregroundColor: surfaces.textPrimary,
          ),
        );

        final rightGroup = Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            TextButton(
              onPressed: onSkip,
              child: Text(
                isRtl
                    ? 'تخطي التفضيلات الاختيارية'
                    : 'Skip optional preferences',
                style: TextStyle(
                  fontSize: 13,
                  color: surfaces.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: onComplete,
              label: Text(
                isRtl
                    ? 'إكمال الإعداد وتشغيل لوحة التحكم'
                    : 'Complete Setup & Launch Dashboard',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              icon: Icon(nextIcon, size: 18),
              style: FilledButton.styleFrom(
                backgroundColor: ThemeColors.stitchPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                elevation: 3,
              ),
            ),
          ],
        );

        if (isDesktop) {
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 12,
            children: [backBtn, rightGroup],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: onComplete,
                label: Text(
                  isRtl
                      ? 'إكمال الإعداد وتشغيل لوحة التحكم'
                      : 'Complete Setup & Launch Dashboard',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                icon: Icon(nextIcon, size: 18),
                style: FilledButton.styleFrom(
                  backgroundColor: ThemeColors.stitchPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: backBtn),
                  TextButton(
                    onPressed: onSkip,
                    child: Text(
                      isRtl ? 'تخطي التفضيلات' : 'Skip preferences',
                      style: TextStyle(color: surfaces.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}

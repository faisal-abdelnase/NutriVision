import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/theme_colors.dart';

class InfoValidationAlertBanner extends StatelessWidget {
  const InfoValidationAlertBanner({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final locale = Localizations.localeOf(context);
    final isRtl =
        Directionality.of(context) == TextDirection.rtl ||
        locale.languageCode == 'ar';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: isDark
          ? ThemeColors.errorContainerDark
          : ThemeColors.errorContainer,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: ThemeColors.error,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRtl
                          ? 'معاملات القياس تتطلب مراجعة دقيقة'
                          : 'Physical Parameters Require Adjustment',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: ThemeColors.error,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isRtl
                          ? 'يتم التحقق تلقائياً من تناسب الطول والوزن طبقاً لمعايير ميفلين-سانت جور السريرية.'
                          : 'Weight and height ratio is being dynamically checked against Mifflin-St Jeor thresholds.',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: ThemeColors.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

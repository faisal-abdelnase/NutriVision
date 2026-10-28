import 'package:flutter/material.dart';
import '../../../../core/theme/theme_dimensions.dart';
import '../models/info_completion_state.dart';
import 'biometrics_intake_form.dart';
import 'metabolic_profiler_card.dart';

class Step1BiometricsCalibration extends StatelessWidget {
  const Step1BiometricsCalibration({
    super.key,
    required this.data,
    required this.onDataChanged,
    required this.onNext,
    required this.onBack,
  });

  final InfoCompletionData data;
  final ValueChanged<InfoCompletionData> onDataChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
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
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 960;

                  final leftCard = MetabolicProfilerCard(data: data);
                  final rightCard = BiometricsIntakeForm(
                    data: data,
                    onDataChanged: onDataChanged,
                    onNext: onNext,
                    onBack: onBack,
                  );

                  if (isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: leftCard),
                        const SizedBox(width: ThemeDimensions.gutterDesktop),
                        Expanded(flex: 7, child: rightCard),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        leftCard,
                        const SizedBox(height: ThemeDimensions.spaceLg),
                        rightCard,
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: ThemeDimensions.spaceLg),
            ],
          ),
        ),
      ),
    );
  }
}

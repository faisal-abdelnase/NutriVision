import 'package:flutter/material.dart';

import '../cards/slide1_food_scan_card.dart';
import '../cards/slide2_viewfinder_card.dart';
import '../cards/slide3_habits_card.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({
    super.key,
    required this.slideIndex,
    required this.pulse,
    required this.ping,
    required this.spin,
    required this.progress,
    required this.isDark,
  });

  final int slideIndex;
  final Animation<double> pulse;
  final Animation<double> ping;
  final AnimationController spin;
  final Animation<double> progress;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return switch (slideIndex) {
      0 => Slide1FoodScanCard(pulse: pulse, progress: progress),
      1 => Slide2ViewfinderCard(
        pulse: pulse,
        ping: ping,
        spin: spin,
        isDark: isDark,
      ),
      2 => Slide3HabitsCard(pulse: pulse, progress: progress, isDark: isDark),
      _ => Slide1FoodScanCard(pulse: pulse, progress: progress),
    };
  }
}

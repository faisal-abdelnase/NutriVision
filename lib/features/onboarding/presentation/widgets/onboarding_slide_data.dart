import 'package:flutter/material.dart';
import 'package:nutri_vision/core/theme/theme_colors.dart';

class OnboardingSlideData {
  const OnboardingSlideData({
    required this.titleKey,
    required this.bodyKey,
    required this.stepLabelKey,
    required this.featureBullets,
    required this.gradientColors,
  });

  final String titleKey;

  final String bodyKey;

  final String stepLabelKey;

  final List<OnboardingBullet> featureBullets;

  final List<Color> gradientColors;
}

class OnboardingBullet {
  const OnboardingBullet({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
  });

  final IconData icon;
  final String titleKey;
  final String subtitleKey;
}

const List<OnboardingSlideData> kOnboardingSlides = [
  OnboardingSlideData(
    titleKey: 'onboardingTitle1',
    bodyKey: 'onboardingBody1',
    stepLabelKey: 'step1Tag',
    featureBullets: [
      OnboardingBullet(
        icon: Icons.verified_rounded,
        titleKey: 'onboardingBullet1aTitle',
        subtitleKey: 'onboardingBullet1aSubtitle',
      ),
      OnboardingBullet(
        icon: Icons.donut_small_rounded,
        titleKey: 'onboardingBullet1bTitle',
        subtitleKey: 'onboardingBullet1bSubtitle',
      ),
    ],
    gradientColors: [
      ThemeColors.stitchPrimary,
      ThemeColors.stitchPrimaryContainer,
    ],
  ),
  OnboardingSlideData(
    titleKey: 'onboardingTitle2',
    bodyKey: 'onboardingBody2',
    stepLabelKey: 'step2Tag',
    featureBullets: [
      OnboardingBullet(
        icon: Icons.psychology_rounded,
        titleKey: 'onboardingBullet2aTitle',
        subtitleKey: 'onboardingBullet2aSubtitle',
      ),
      OnboardingBullet(
        icon: Icons.sync_alt_rounded,
        titleKey: 'onboardingBullet2bTitle',
        subtitleKey: 'onboardingBullet2bSubtitle',
      ),
    ],
    gradientColors: [
      ThemeColors.stitchSecondary,
      ThemeColors.stitchSecondaryContainer,
    ],
  ),
  OnboardingSlideData(
    titleKey: 'onboardingTitle3',
    bodyKey: 'onboardingBody3',
    stepLabelKey: 'step3Tag',
    featureBullets: [
      OnboardingBullet(
        icon: Icons.local_fire_department_rounded,
        titleKey: 'onboardingBullet3aTitle',
        subtitleKey: 'onboardingBullet3aSubtitle',
      ),
      OnboardingBullet(
        icon: Icons.insights_rounded,
        titleKey: 'onboardingBullet3bTitle',
        subtitleKey: 'onboardingBullet3bSubtitle',
      ),
    ],
    gradientColors: [
      ThemeColors.stitchPrimary,
      ThemeColors.stitchPrimaryContainer,
    ],
  ),
];

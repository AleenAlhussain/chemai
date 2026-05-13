import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';

class OnboardingPage {
  final String title;
  final String subtitle;
  final String illustrationAsset;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.illustrationAsset,
  });
}

class OnboardingController extends GetxController {
  final pageIndex = 0.obs;
  late final PageController pageController;

  final pages = [
    const OnboardingPage(
      title: 'Master Chemistry with AI',
      subtitle:
          'Your personal AI tutor designed to make Grade 9 Chemistry feel like a game.',
      illustrationAsset: 'atom',
    ),
    const OnboardingPage(
      title: 'Level Up Your Knowledge',
      subtitle:
          'Earn XP, unlock chapters, and rise through the quantum ranks as you learn.',
      illustrationAsset: 'rocket',
    ),
    const OnboardingPage(
      title: 'Pick Your Learning Style',
      subtitle:
          'Choose a mentor persona that matches how you think and learn best.',
      illustrationAsset: 'mentor',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void next() {
    if (pageIndex.value < pages.length - 1) {
      pageIndex.value++;
      pageController.animateToPage(
        pageIndex.value,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void skip() => _finish();

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    Get.offAllNamed(AppRoutes.mentor);
  }
}

import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../../data/models/flashcard_model.dart';

class FlashcardsController extends GetxController
    with SingleGetTickerProviderMixin {
  final cards = Flashcard.defaults;
  final currentIndex = 0.obs;
  final masteredCount = 15.obs;
  final dailyProgress = 0.38.obs;
  final isFlipped = false.obs;
  final totalCards = 40;
  final dailyGoalRemaining = 25;

  // Spectral Study counts
  final newCount = 12.obs;
  final learningCount = 5.obs;
  final reviewCount = 3.obs;

  late final AnimationController flipController;

  Flashcard get current => cards[currentIndex.value % cards.length];

  @override
  void onInit() {
    super.onInit();
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void flip() {
    if (isFlipped.value) {
      flipController.reverse();
    } else {
      flipController.forward();
    }
    isFlipped.value = !isFlipped.value;
  }

  /// Alias for flip() used by the Spectral Study reveal gesture.
  void reveal() => flip();

  void rateCard(String rating) {
    // rating: 'again', 'hard', 'good', 'easy'
    _nextCard();
  }

  void markMastered() {
    masteredCount.value = (masteredCount.value + 1).clamp(0, totalCards);
    dailyProgress.value =
        (dailyProgress.value + 0.025).clamp(0.0, 1.0);
    _nextCard();
  }

  void markForgotten() => _nextCard();

  void _nextCard() {
    isFlipped.value = false;
    flipController.reset();
    currentIndex.value = (currentIndex.value + 1) % cards.length;
  }

  double get flipAngle =>
      flipController.value * pi;

  @override
  void onClose() {
    flipController.dispose();
    super.onClose();
  }
}

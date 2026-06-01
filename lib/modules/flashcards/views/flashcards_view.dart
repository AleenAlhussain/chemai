import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/flashcards_controller.dart';

class FlashcardsView extends GetView<FlashcardsController> {
  const FlashcardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070A1E),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // ── Progress pills row ──────────────────────────────────────
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _ProgressPill(
                        label: 'spectral_new'
                            .trParams({'count': '${controller.newCount.value}'}),
                        filled: true,
                        color: AppColors.cyan,
                      ),
                      const SizedBox(width: 8),
                      _ProgressPill(
                        label: 'spectral_learning'.trParams(
                            {'count': '${controller.learningCount.value}'}),
                        filled: true,
                        color: AppColors.green,
                      ),
                      const SizedBox(width: 8),
                      _ProgressPill(
                        label: 'spectral_review'.trParams(
                            {'count': '${controller.reviewCount.value}'}),
                        filled: false,
                        color: AppColors.textSecondary,
                      ),
                      const Spacer(),
                      // Card count sub-label
                      Text(
                        'spectral_card_count'
                            .trParams({'current': '7', 'total': '20'}),
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: 20),

            // ── Main flashcard ──────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  controller.currentIndex.value;
                  return _SpectralCard(controller: controller);
                }),
              ),
            ),

            const SizedBox(height: 16),

            // ── KIMO TIP ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _KimoTip(
                tip: controller.current.definition.length > 60
                    ? controller.current.definition.substring(0, 60) + '…'
                    : controller.current.definition,
              ),
            ),

            const SizedBox(height: 16),

            // ── 4 Rating buttons ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _RatingButton(
                      label: 'spectral_again'.tr,
                      time: '<1m',
                      bgColor: const Color(0xFF3B0A0A),
                      icon: Icons.redo,
                      iconColor: const Color(0xFFEF4444),
                      onTap: () => controller.rateCard('again'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _RatingButton(
                      label: 'spectral_hard'.tr,
                      time: '2d',
                      bgColor: const Color(0xFF1A1A2E),
                      icon: Icons.sentiment_neutral,
                      iconColor: AppColors.textSecondary,
                      onTap: () => controller.rateCard('hard'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _RatingButton(
                      label: 'spectral_good'.tr,
                      time: '4d',
                      bgColor: const Color(0xFF0A1A3B),
                      icon: Icons.sentiment_satisfied,
                      iconColor: const Color(0xFF60A5FA),
                      onTap: () => controller.rateCard('good'),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _RatingButton(
                      label: 'spectral_easy'.tr,
                      time: '7d',
                      bgColor: const Color(0xFF041E1E),
                      icon: Icons.rocket_launch,
                      iconColor: AppColors.cyan,
                      hasCyanBorder: true,
                      onTap: () => controller.rateCard('easy'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0C0F2A),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'spectral_title'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'spectral_card_count'.trParams({'current': '7', 'total': '20'}),
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.close, color: AppColors.textSecondary),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }
}

// ── Progress pill ─────────────────────────────────────────────────────────────
class _ProgressPill extends StatelessWidget {
  final String label;
  final bool filled;
  final Color color;

  const _ProgressPill({
    required this.label,
    required this.filled,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: filled ? color : AppColors.borderDefault,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: filled ? color : AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Spectral card with flip ───────────────────────────────────────────────────
class _SpectralCard extends StatelessWidget {
  final FlashcardsController controller;
  const _SpectralCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.reveal,
      child: AnimatedBuilder(
        animation: controller.flipController,
        builder: (_, __) {
          final angle = controller.flipController.value * pi;
          final showFront = controller.flipController.value < 0.5;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: showFront
                ? _SpectralFront(card: controller.current)
                : Transform(
                    transform: Matrix4.rotationY(pi),
                    alignment: Alignment.center,
                    child: _SpectralBack(card: controller.current),
                  ),
          );
        },
      ),
    );
  }
}

// ── Card shell with cyan corner accents ──────────────────────────────────────
class _SpectralCardShell extends StatelessWidget {
  final Widget child;
  const _SpectralCardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0D1130),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderDefault),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withOpacity(0.08),
                blurRadius: 32,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ),

        // Top-left cyan L accent
        Positioned(
          top: 12,
          left: 12,
          child: _CyanCorner(topLeft: true),
        ),

        // Bottom-right cyan L accent
        Positioned(
          bottom: 12,
          right: 12,
          child: _CyanCorner(topLeft: false),
        ),
      ],
    );
  }
}

class _CyanCorner extends StatelessWidget {
  final bool topLeft;
  const _CyanCorner({required this.topLeft});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.cyan.withOpacity(0.6);
    const thickness = 2.0;
    const length = 14.0;

    return SizedBox(
      width: length,
      height: length,
      child: Stack(
        children: [
          // Horizontal bar
          Positioned(
            top: topLeft ? 0 : null,
            bottom: topLeft ? null : 0,
            left: topLeft ? 0 : null,
            right: topLeft ? null : 0,
            child: Container(
              width: length,
              height: thickness,
              color: color,
            ),
          ),
          // Vertical bar
          Positioned(
            top: topLeft ? 0 : null,
            bottom: topLeft ? null : 0,
            left: topLeft ? 0 : null,
            right: topLeft ? null : 0,
            child: Container(
              width: thickness,
              height: length,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Front face ────────────────────────────────────────────────────────────────
class _SpectralFront extends StatelessWidget {
  final dynamic card;
  const _SpectralFront({required this.card});

  @override
  Widget build(BuildContext context) {
    return _SpectralCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top label
          Text(
            'spectral_molecular_id'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // Icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.science, color: AppColors.textMuted, size: 20),
              Icon(Icons.bubble_chart, color: AppColors.textMuted, size: 20),
            ],
          ),

          const Spacer(),

          // Big formula text
          Text(
            card.formula.isNotEmpty ? card.formula : 'C₆H₁₂O₆',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'spectral_molecular_formula'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              letterSpacing: 1.8,
            ),
          ),

          const Spacer(),

          // Tap to reveal
          Column(
            children: [
              Icon(Icons.touch_app, color: AppColors.cyan, size: 22),
              const SizedBox(height: 6),
              Text(
                'spectral_tap_reveal'.tr,
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ── Back face ─────────────────────────────────────────────────────────────────
class _SpectralBack extends StatelessWidget {
  final dynamic card;
  const _SpectralBack({required this.card});

  @override
  Widget build(BuildContext context) {
    return _SpectralCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Term header
          Text(
            card.term,
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Container(width: 40, height: 1, color: AppColors.borderDefault),

          const SizedBox(height: 16),

          const Spacer(),

          // Definition
          Text(
            card.definition,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Example
          if (card.example.isNotEmpty)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgCardAlt,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Text(
                card.example,
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ── KIMO TIP ──────────────────────────────────────────────────────────────────
class _KimoTip extends StatelessWidget {
  final String tip;
  const _KimoTip({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          // Avatar circle
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.cyan.withOpacity(0.15),
              border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
            ),
            child: Icon(Icons.auto_awesome, color: AppColors.cyan, size: 18),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'spectral_kimo_tip'.tr,
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tip,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Rating button ─────────────────────────────────────────────────────────────
class _RatingButton extends StatelessWidget {
  final String label;
  final String time;
  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final bool hasCyanBorder;
  final VoidCallback onTap;

  const _RatingButton({
    required this.label,
    required this.time,
    required this.bgColor,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.hasCyanBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasCyanBorder
                ? AppColors.cyan.withOpacity(0.6)
                : AppColors.borderDefault,
            width: hasCyanBorder ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

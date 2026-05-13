import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Radial background glow
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.1),
                  radius: 0.9,
                  colors: [
                    AppColors.cyan.withOpacity(0.04),
                    AppColors.bgDeep,
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              // ── Logo block (centered slightly above middle) ──────────────
              Expanded(
                flex: 55,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // App icon with cyan glow
                      _GlowingLogo()
                          .animate()
                          .fadeIn(duration: 700.ms)
                          .scale(begin: const Offset(0.85, 0.85),
                              duration: 700.ms, curve: Curves.easeOut),

                      const SizedBox(height: 24),

                      // CHEMAI wordmark
                      Text(
                        'CHEMAI',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 8,
                            ),
                      ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Quantum Simulation Engine',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              letterSpacing: 2.5,
                              fontSize: 11,
                            ),
                      ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                    ],
                  ),
                ),
              ),

              // ── Progress section ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress bar
                    Obx(() => _NeuralProgressBar(value: controller.progress.value))
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 500.ms),

                    const SizedBox(height: 6),

                    // Status + percentage row
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.statusText.value,
                              style:  TextStyle(
                                color: AppColors.cyan,
                                fontSize: 9,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${(controller.progress.value * 100).toInt()}%',
                              style:  TextStyle(
                                color: AppColors.cyan,
                                fontSize: 9,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )).animate().fadeIn(delay: 600.ms),
                  ],
                ),
              ),

              // ── Bottom version tag ──────────────────────────────────────
              Expanded(
                flex: 15,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(Icons.science_outlined,
                            color: AppColors.textMuted, size: 12),
                        const SizedBox(width: 8),
                        Text(
                          'MOLECULAR INTELLIGENCE PLATFORM V4.0.2',
                          style:  TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 9,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 800.ms),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Glowing app icon ─────────────────────────────────────────────────────────
class _GlowingLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.35),
            blurRadius: 40,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dark gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFF0A2040), Color(0xFF050C18)],
                  radius: 0.8,
                ),
              ),
            ),
            // Center glow
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withOpacity(0.25),
                    blurRadius: 40,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
            // Logo text
            RichText(
              text:  TextSpan(
                children: [
                  TextSpan(
                    text: 'C',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: ' EMI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Cyan progress bar ─────────────────────────────────────────────────────────
class _NeuralProgressBar extends StatelessWidget {
  final double value;
  const _NeuralProgressBar({required this.value});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: 3,
        width: constraints.maxWidth,
        decoration: BoxDecoration(
          color: AppColors.borderDefault,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            width: constraints.maxWidth * value.clamp(0.0, 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient:  LinearGradient(
                colors: [AppColors.cyan, AppColors.purple],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/mission_success_controller.dart';

class MissionSuccessView extends GetView<MissionSuccessController> {
  const MissionSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                // Green checkmark circle
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green.withOpacity(0.15),
                    border: Border.all(
                        color: AppColors.green.withOpacity(0.5), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.green.withOpacity(0.5),
                        blurRadius: 50,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.green,
                    size: 60,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 400.ms),

                const SizedBox(height: 24),

                // Mission name label
                Obx(
                  () => Text(
                    controller.missionName.value.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate(delay: 300.ms).fadeIn(duration: 300.ms),

                const SizedBox(height: 8),

                // Title
                Text(
                  'MISSION COMPLETE!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.3, end: 0, duration: 400.ms),

                const SizedBox(height: 28),

                // Stars row
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          Icons.star_rounded,
                          size: 44,
                          color: i < controller.starsEarned.value
                              ? AppColors.amber
                              : AppColors.textMuted.withOpacity(0.3),
                        )
                            .animate(
                                delay: Duration(milliseconds: 600 + i * 150))
                            .scale(
                              begin: const Offset(0.4, 0.4),
                              end: const Offset(1.0, 1.0),
                              duration: 400.ms,
                              curve: Curves.elasticOut,
                            )
                            .fadeIn(duration: 300.ms),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Stats row
                Obx(
                  () => Row(
                    children: [
                      _StatTile(
                        label: 'SCORE',
                        value: controller.score.value.toString(),
                        color: AppColors.purple,
                      ),
                      const SizedBox(width: 12),
                      _StatTile(
                        label: 'TIME',
                        value: controller.formattedTime,
                        color: AppColors.cyan,
                      ),
                      const SizedBox(width: 12),
                      _StatTile(
                        label: 'ACCURACY',
                        value: '${controller.accuracy.value}%',
                        color: AppColors.green,
                      ),
                    ],
                  ),
                ).animate(delay: 900.ms).fadeIn(duration: 400.ms).slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 400.ms,
                    ),

                const SizedBox(height: 20),

                // XP earned
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: AppColors.amber.withOpacity(0.4)),
                    ),
                    child: Text(
                      '+${controller.xpEarned.value} XP',
                      style: const TextStyle(
                        color: AppColors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                )
                    .animate(delay: 1100.ms)
                    .fadeIn(duration: 400.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.0, 1.0),
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 36),

                // Buttons
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.green, const Color(0xFF10B981)],
                      ),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: ElevatedButton(
                      onPressed: controller.claimReward,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: Text(
                        'CLAIM REWARD',
                        style: TextStyle(
                          color: AppColors.bgDeep,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ).animate(delay: 1300.ms).fadeIn(duration: 400.ms).slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 400.ms,
                    ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: controller.nextMission,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: AppColors.purple.withOpacity(0.6), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: Text(
                      'NEXT MISSION',
                      style: TextStyle(
                        color: AppColors.purple,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ).animate(delay: 1400.ms).fadeIn(duration: 400.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stat tile ─────────────────────────────────────────────────────────────────
class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatTile(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

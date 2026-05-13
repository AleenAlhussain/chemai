import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/mentor_controller.dart';
import 'widgets/mentor_card.dart';

class MentorView extends GetView<MentorController> {
  const MentorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: _buildAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Padding(
            padding:  EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Choose Your Mentor',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2),
                 SizedBox(height: 6),
                 Text(
                  'Select a teaching style that fits your vibe.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              ],
            ),
          ),

           SizedBox(height: 20),

          // ── Mentor grid ──────────────────────────────────────────────────
          Expanded(
            child: Obx(() => Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    itemCount: controller.mentors.length,
                    gridDelegate:
                         SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.92,
                    ),
                    itemBuilder: (_, i) {
                      final m = controller.mentors[i];
                      return Obx(() => MentorCard(
                            mentor: m,
                            isSelected: controller.isSelected(m.id),
                            onTap: () => controller.select(m.id),
                            index: i,
                          ));
                    },
                  ),
                )),
          ),

          // ── CTA ──────────────────────────────────────────────────────────
          Padding(
            padding:
                 EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.initializeSession,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          padding:
                               EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: controller.isLoading.value
                            ?  SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            :  Text(
                                'Initialize Session',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      )),
                ),
                 SizedBox(height: 10),
                 Text(
                  'QUANTUM ENGINE ONLINE',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bgBase,
      titleSpacing: 16,
      title: Row(
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgCard,
              border:
                  Border.all(color: AppColors.borderDefault, width: 1),
            ),
            child:  Icon(Icons.person_outline,
                color: AppColors.textSecondary, size: 18),
          ),
           SizedBox(width: 10),
           Text(
            'QUANTUM CHEMISTRY',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon:  Icon(Icons.settings_outlined,
              color: AppColors.textSecondary, size: 20),
          onPressed: () {},
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/lessons_controller.dart';
import 'widgets/chapter_card.dart';

class LessonsView extends GetView<LessonsController> {
  const LessonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
             Text(
              'Master the Elements',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ).animate().fadeIn(duration: 400.ms),

             SizedBox(height: 6),

             Text(
              'Continue your journey through the quantum realm of chemical interactions.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

             SizedBox(height: 24),

            // Chapter list
            Obx(() => ListView.separated(
                  shrinkWrap: true,
                  physics:  NeverScrollableScrollPhysics(),
                  itemCount: controller.chapters.length,
                  separatorBuilder: (_, __) =>  SizedBox(height: 14),
                  itemBuilder: (_, i) {
                    final c = controller.chapters[i];
                    return ChapterCard(
                      chapter: c,
                      index: i,
                      onResume: () => controller.resumeChapter(c),
                    );
                  },
                )),

             SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgBase,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgCard,
              border: Border.all(color: AppColors.borderDefault),
            ),
            child:  Icon(Icons.person_outline,
                color: AppColors.textSecondary, size: 18),
          ),
           SizedBox(width: 10),
           Text(
            'CURRICULUM',
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

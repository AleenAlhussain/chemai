import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/home_controller.dart';
import 'widgets/level_card.dart';
import 'widgets/mission_card.dart';
import 'widgets/quick_action_grid.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: _buildAppBar(),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return  Center(
              child: CircularProgressIndicator(color: AppColors.purple));
        }

        return SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // STATUS: ONLINE
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin:  EdgeInsets.only(right: 6),
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.online,
                    ),
                  ),
                   Text(
                    'STATUS: ONLINE',
                    style: TextStyle(
                      color: AppColors.online,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms),

               SizedBox(height: 6),

              // Heading
              RichText(
                text: TextSpan(
                  children: [
                     TextSpan(
                      text: 'Systems Active, ',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: user.name,
                      style:  TextStyle(
                        color: AppColors.cyan,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 80.ms, duration: 400.ms),

               SizedBox(height: 20),

              // Level card
              LevelCard(user: user)
                  .animate()
                  .fadeIn(delay: 150.ms, duration: 400.ms)
                  .slideY(begin: 0.1),

               SizedBox(height: 16),

              // Mission card
              const MissionCard()
                  .animate()
                  .fadeIn(delay: 250.ms, duration: 400.ms)
                  .slideY(begin: 0.1),

              const SizedBox(height: 24),

              // Quick actions
              const QuickActionGrid(),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgBase,
      titleSpacing: 16,
      title: Row(
        children: [
          Obx(() {
            final avatarUrl = controller.user.value?.avatarUrl ?? '';
            return Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgCard,
                border: Border.all(color: AppColors.borderDefault),
                image: avatarUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl), fit: BoxFit.cover)
                    : null,
              ),
              child: avatarUrl.isEmpty
                  ?  Icon(Icons.person_outline,
                      color: AppColors.textSecondary, size: 18)
                  : null,
            );
          }),
          const SizedBox(width: 10),
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

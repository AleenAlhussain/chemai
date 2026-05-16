import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../../widgets/app_drawer.dart';
import '../../ask_ai/views/ask_ai_view.dart';
import '../../home/views/home_view.dart';
import '../../lessons/views/lessons_view.dart';
import '../../pilot_profile/views/pilot_profile_view.dart';
import '../../schedule/views/schedule_view.dart';
import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  static List<Widget> get _pages => [
        HomeView(),
        LessonsView(),
        AskAiView(),
        ScheduleView(),
        PilotProfileView(),
      ];

  @override
  Widget build(BuildContext context) {
    final tc = Get.find<ThemeController>();
    return Obx(() {
      tc.isDark.value; // subscribe for theme rebuilds
      return Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: AppColors.bgBase,
        drawer: const AppDrawer(),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: _QuantumNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        ),
      );
    });
  }
}

// ── Bottom navigation bar ─────────────────────────────────────────────────────
class _QuantumNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _QuantumNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.home_outlined, label: 'HOME'),
    (icon: Icons.school_outlined, label: 'LESSONS'),
    (icon: Icons.psychology_outlined, label: 'ASK AI'),
    (icon: Icons.calendar_today_outlined, label: 'SCHEDULE'),
    (icon: Icons.person_outline, label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      height: 72 + bottomPad,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: 22,
                    color: isActive ? AppColors.purple : AppColors.textMuted,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isActive ? AppColors.purple : AppColors.textMuted,
                      fontSize: 8,
                      letterSpacing: 0.8,
                      fontWeight:
                          isActive ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

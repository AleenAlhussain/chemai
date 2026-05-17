import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/user_model.dart';
import '../../main_nav/controllers/main_nav_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020408),
      appBar: _HomeAppBar(controller: controller),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return Center(child: CircularProgressIndicator(color: AppColors.purple));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatusRow()
                  .animate().fadeIn(duration: 300.ms),
              const SizedBox(height: 12),
              _GreetingSection(name: user.name)
                  .animate().fadeIn(delay: 80.ms, duration: 300.ms),
              const SizedBox(height: 16),
              _PilotStatsCard(user: user)
                  .animate().fadeIn(delay: 150.ms, duration: 400.ms).slideY(begin: 0.08),
              const SizedBox(height: 14),
              _ActiveMissionCard()
                  .animate().fadeIn(delay: 220.ms, duration: 400.ms).slideY(begin: 0.08),
              const SizedBox(height: 22),
              _SectionHeader('QUICK ACTIONS')
                  .animate().fadeIn(delay: 280.ms, duration: 300.ms),
              const SizedBox(height: 12),
              _QuickActionsGrid()
                  .animate().fadeIn(delay: 320.ms, duration: 400.ms),
              const SizedBox(height: 22),
              _SectionHeader("TODAY'S INTEL")
                  .animate().fadeIn(delay: 380.ms, duration: 300.ms),
              const SizedBox(height: 12),
              _TodayIntelRow()
                  .animate().fadeIn(delay: 420.ms, duration: 400.ms),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────
class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;
  const _HomeAppBar({required this.controller});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF020408),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: GestureDetector(
          onTap: () => Get.find<MainNavController>().openDrawer(),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Icon(Icons.menu_rounded, color: AppColors.textSecondary, size: 18),
          ),
        ),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => AppColors.gradientPurple.createShader(bounds),
        child: const Text(
          'ChemAI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Obx(() {
            final avatarUrl = controller.user.value?.avatarUrl ?? '';
            return Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgCard,
                border: Border.all(color: AppColors.borderDefault),
                image: avatarUrl.isNotEmpty
                    ? DecorationImage(image: NetworkImage(avatarUrl), fit: BoxFit.cover)
                    : null,
              ),
              child: avatarUrl.isEmpty
                  ? Icon(Icons.account_circle_outlined, color: AppColors.purple, size: 22)
                  : null,
            );
          }),
        ),
      ],
    );
  }
}

// ── Status row ────────────────────────────────────────────────────────────────
class _StatusRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'STATUS: ONLINE',
                style: TextStyle(
                  color: const Color(0xFF22C55E),
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt, color: AppColors.amber, size: 13),
              const SizedBox(width: 4),
              Text(
                'DAILY STREAK: 7',
                style: TextStyle(
                  color: AppColors.amber,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Greeting ──────────────────────────────────────────────────────────────────
class _GreetingSection extends StatelessWidget {
  final String name;
  const _GreetingSection({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Systems Active, ',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              TextSpan(
                text: name,
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Grade 9 · Quantum Chemistry Protocol',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

// ── Pilot stats card ──────────────────────────────────────────────────────────
class _PilotStatsCard extends StatelessWidget {
  final UserModel user;
  const _PilotStatsCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // Top row: avatar + info + level badge
          Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.gradientPurple,
                ),
                child: const Center(
                  child: Text('⚗️', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Quantum Operative',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Level badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.purple.withOpacity(0.4)),
                ),
                child: Text(
                  'LVL ${user.level}',
                  style: TextStyle(
                    color: AppColors.purple,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // XP bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'XP PROGRESS',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${user.xp} / ${user.xpToNextLevel} XP',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: user.progressToNextLevel,
                  minHeight: 6,
                  backgroundColor: AppColors.borderDefault,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyan),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${user.xpRemaining} XP to Level ${user.level + 1}',
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _StatPill('STREAK', '7 days', AppColors.amber),
              const SizedBox(width: 8),
              _StatPill('ACCURACY', '84%', AppColors.green),
              const SizedBox(width: 8),
              _StatPill('TOTAL XP', '${user.xp}', AppColors.purple),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatPill(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Active mission card ───────────────────────────────────────────────────────
class _ActiveMissionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cyan.withOpacity(0.25)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0E2A3A), Color(0xFF081520)],
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.cyan.withOpacity(0.35)),
                ),
                child: Text(
                  'ACTIVE PROTOCOL',
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'IN PROGRESS',
                style: TextStyle(
                  color: const Color(0xFF22C55E),
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            'Chapter 3: Chemical Bonding',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lesson 4 of 8 · Ionic vs Covalent Bonds',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),

          const SizedBox(height: 14),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LESSON PROGRESS',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 9,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '62%',
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.62,
              minHeight: 5,
              backgroundColor: AppColors.borderDefault,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyan),
            ),
          ),

          const SizedBox(height: 16),

          // Resume button
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.lessonDetail),
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                gradient: AppColors.gradientPurple,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.purple.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                '▶  RESUME LESSON',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            gradient: AppColors.gradientPurple,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Quick actions grid ────────────────────────────────────────────────────────
class _QuickActionsGrid extends StatelessWidget {
  static const _actions = [
    _QAction(Icons.science_outlined, 'VIRTUAL LAB', route: AppRoutes.virtualLab),
    _QAction(Icons.grid_view_outlined, 'PERIODIC TABLE', route: AppRoutes.periodicTable),
    _QAction(Icons.sports_esports_outlined, 'BOSS BATTLE', route: AppRoutes.bossBattle),
    _QAction(Icons.style_outlined, 'FLASHCARDS', route: AppRoutes.flashcards),
    _QAction(Icons.bolt_outlined, 'CHALLENGES', route: AppRoutes.dailyChallenges),
    _QAction(Icons.smart_toy_outlined, 'AI CHAT', navTab: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: _actions.length,
      itemBuilder: (_, i) => _QuickActionItem(action: _actions[i], index: i),
    );
  }
}

class _QAction {
  final IconData icon;
  final String label;
  final String? route;
  final int? navTab;
  const _QAction(this.icon, this.label, {this.route, this.navTab});
}

class _QuickActionItem extends StatelessWidget {
  final _QAction action;
  final int index;
  const _QuickActionItem({required this.action, required this.index});

  static const _colors = [
    Color(0xFF7C3AED),
    Color(0xFF0EA5E9),
    Color(0xFFEF4444),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF8B5CF6),
  ];

  void _onTap() {
    if (action.navTab != null) {
      Get.find<MainNavController>().changeTab(action.navTab!);
    } else if (action.route != null) {
      Get.toNamed(action.route!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colors[index % _colors.length];
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              action.label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 8,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.9, 0.9), duration: 300.ms, curve: Curves.easeOut);
  }
}

// ── Today's intel row ─────────────────────────────────────────────────────────
class _TodayIntelRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _IntelCard('LESSONS', '3', 'completed today', Icons.book_outlined, AppColors.purple),
        const SizedBox(width: 10),
        _IntelCard('TIME', '42m', 'studied today', Icons.timer_outlined, AppColors.cyan),
        const SizedBox(width: 10),
        _IntelCard('XP EARNED', '+240', 'today', Icons.star_border_rounded, AppColors.amber),
      ],
    );
  }
}

class _IntelCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _IntelCard(this.label, this.value, this.subtitle, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 8,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: AppColors.textMuted, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

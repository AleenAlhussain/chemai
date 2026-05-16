import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../app/theme/app_colors.dart';
import '../core/controllers/theme_controller.dart';
import '../modules/main_nav/controllers/main_nav_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.bgDeep,
      width: 290,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DrawerHeader(),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Main navigation ──────────────────────────────
                    _SectionLabel('NAVIGATION'),
                    _NavItem(Icons.person_outline, 'Profile', () => _goTab(0)),
                    _NavItem(Icons.book_outlined, 'Lessons', () => _goTab(1)),
                    _NavItem(Icons.video_library_outlined, 'Reels', () => _goTab(2)),
                    _NavItem(Icons.smart_toy_outlined, 'Chat / Ask AI', () => _goTab(3)),
                    _NavItem(Icons.home_outlined, 'Home', () => _goTab(4)),
                    _NavItem(Icons.trending_up_outlined, 'Progress', () => _push(AppRoutes.profile)),
                    _NavItem(Icons.calendar_today_outlined, 'Schedule', () => _push(AppRoutes.schedule)),

                    const SizedBox(height: 4),

                    // ── Tools ─────────────────────────────────────────
                    _SectionLabel('TOOLS'),
                    _NavItem(Icons.science_outlined, 'Virtual Lab',
                        () => _push(AppRoutes.virtualLab)),
                    _NavItem(Icons.grid_view_outlined, 'Periodic Table',
                        () => _push(AppRoutes.periodicTable)),
                    _NavItem(Icons.biotech_outlined, 'Research Lab',
                        () => _push(AppRoutes.researchLab)),
                    _NavItem(Icons.backpack_outlined, 'Alchemist\'s Armory',
                        () => _push(AppRoutes.inventory)),

                    const SizedBox(height: 4),

                    // ── Games ─────────────────────────────────────────
                    _SectionLabel('GAMES'),
                    _NavItem(Icons.bolt_outlined, 'Daily Challenges',
                        () => _push(AppRoutes.dailyChallenges)),
                    _NavItem(Icons.sports_esports_outlined, 'Boss Battle',
                        () => _push(AppRoutes.bossBattle)),
                    _NavItem(Icons.extension_outlined, 'Formula Synthesis',
                        () => _push(AppRoutes.formulaGame)),
                    _NavItem(Icons.style_outlined, 'Flashcards',
                        () => _push(AppRoutes.flashcards)),
                    _NavItem(Icons.quiz_outlined, 'Daily Quiz',
                        () => _push(AppRoutes.quiz)),

                    const SizedBox(height: 4),

                    // ── Social ────────────────────────────────────────
                    _SectionLabel('SOCIAL'),
                    _NavItem(Icons.emoji_events_outlined, 'Leaderboard',
                        () => _push(AppRoutes.leaderboard)),
                    _NavItem(Icons.map_outlined, 'Global Mission Map',
                        () => _push(AppRoutes.globalMap)),
                    _NavItem(Icons.group_outlined, 'Squad Comms',
                        () => _push(AppRoutes.squadComms)),
                    _NavItem(Icons.handshake_outlined, 'Collaboration Quest',
                        () => _push(AppRoutes.collaboration)),
                    _NavItem(Icons.share_outlined, 'Social Showcase',
                        () => _push(AppRoutes.social)),
                    _NavItem(Icons.flash_on_outlined, 'Synergy Sparks',
                        () => _push(AppRoutes.synergySparks)),

                    const SizedBox(height: 4),

                    // ── Plan & Account ────────────────────────────────
                    _SectionLabel('PLAN & ACCOUNT'),
                    _PlanCard(),
                    const SizedBox(height: 8),
                    _NavItem(Icons.workspace_premium_outlined, 'Upgrade Plan',
                        () => _push(AppRoutes.plan)),
                    _NavItem(Icons.card_giftcard_outlined, 'Rewards',
                        () => _push(AppRoutes.rewards)),
                    _NavItem(Icons.bar_chart_outlined, 'Study Plan',
                        () => _push(AppRoutes.studyPlan)),

                    const SizedBox(height: 4),

                    // ── Settings ──────────────────────────────────────
                    _SectionLabel('SETTINGS'),
                    _NavItem(Icons.manage_accounts_outlined, 'Account',
                        () => _push(AppRoutes.account)),
                    _NavItem(Icons.palette_outlined, 'Interface Theme',
                        () => Get.find<ThemeController>().toggle()),
                    _NavItem(Icons.shield_outlined, 'Privacy & Security',
                        () => _push(AppRoutes.privacy)),
                    _NavItem(Icons.notifications_outlined, 'Notifications',
                        () {}),
                    _NavItem(Icons.help_outline_rounded, 'Support', () {}),

                    const SizedBox(height: 16),

                    // ── Disconnect ────────────────────────────────────
                    _DisconnectButton(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goTab(int index) {
    Get.back(); // close drawer
    try {
      Get.find<MainNavController>().changeTab(index);
    } catch (_) {
      Get.offAllNamed(AppRoutes.mainNav);
    }
  }

  void _push(String route) {
    Get.back();
    Get.toNamed(route);
  }
}

// ── Drawer header ─────────────────────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderDefault),
        ),
      ),
      child: Row(
        children: [
          // App logo / avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.gradientPurple,
              boxShadow: [
                BoxShadow(
                  color: AppColors.purple.withOpacity(0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Center(
              child: Text('⚗️', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CHEMAI',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'QUANTUM ENGINE v4.9',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.close, color: AppColors.textMuted, size: 20),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms);
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 0, 6),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 9,
          letterSpacing: 2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Navigation item ───────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavItem(this.icon, this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 14),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Plan card ─────────────────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFBBF24).withOpacity(0.4),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bgCard,
            const Color(0xFFFBBF24).withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium_rounded,
              color: Color(0xFFFBBF24), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ChemAI Pro',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Elite access until Oct 2025',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
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

// ── Disconnect button ─────────────────────────────────────────────────────────
class _DisconnectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.offAllNamed(AppRoutes.splash);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.danger.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.danger.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.danger, size: 18),
            const SizedBox(width: 10),
            Text(
              'DISCONNECT SESSION',
              style: TextStyle(
                color: AppColors.danger,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

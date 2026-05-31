import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 16),
              // _UserHeroCard(controller: controller),
              // const SizedBox(height: 20),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: _StatsGrid(),
              // ),
              // const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _WeeklyActivitySection(controller: controller),
              ),
              const SizedBox(height: 24),
              _AchievementsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// class _UserHeroCard extends StatelessWidget {
//   final ProfileController controller;
//
//   const _UserHeroCard({required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.bgCard,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.borderDefault),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Ahmad Kamal',
//                       style: TextStyle(
//                         color: AppColors.textPrimary,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${'profile_chemistry_student'.tr} ⭐  —  ${'profile_level'.tr} 6',
//                       style: TextStyle(
//                         color: AppColors.cyan,
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       'profile_progress_to_level'.tr,
//                       style: TextStyle(
//                         color: AppColors.textMuted,
//                         fontSize: 10,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: LinearProgressIndicator(
//                         value: 0.7,
//                         minHeight: 6,
//                         backgroundColor: AppColors.borderDefault,
//                         valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyan),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Stack(
//                 children: [
//                   Container(
//                     width: 72,
//                     height: 72,
//                     decoration: BoxDecoration(
//                       color: AppColors.bgCardAlt,
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(
//                         color: AppColors.purple,
//                         width: 2,
//                       ),
//                     ),
//                     child: Icon(
//                       Icons.smart_toy_outlined,
//                       size: 40,
//                       color: AppColors.purple,
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                       decoration: BoxDecoration(
//                         color: AppColors.purple,
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(6),
//                           bottomRight: Radius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'PRO',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w800,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           Text(
//             '🤖 1,500 / 1,240 XP',
//             style: TextStyle(
//               color: AppColors.textMuted,
//               fontSize: 11,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _StatsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData('32 ${'nav_lessons'.tr}', 'profile_lessons_completed'.tr, const Color(0xFFF472B6)),
      _StatData('14 Days', 'profile_streak'.tr, const Color(0xFFF97316)),
      _StatData('24.5 h', 'profile_study_time'.tr, const Color(0xFFFBBF24)),
      _StatData('482', 'profile_questions'.tr, AppColors.cyan),
      _StatData('18', 'profile_badges'.tr, AppColors.purple),
      _StatData('92%', 'profile_accuracy'.tr, AppColors.green),
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: stats.map((s) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 42) / 2,
          child: _StatCard(data: s),
        );
      }).toList(),
    );
  }
}

class _StatData {
  final String value;
  final String label;
  final Color color;

  _StatData(this.value, this.label, this.color);
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: data.color, width: 4),
          top: BorderSide(color: AppColors.borderDefault),
          right: BorderSide(color: AppColors.borderDefault),
          bottom: BorderSide(color: AppColors.borderDefault),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyActivitySection extends StatelessWidget {
  final ProfileController controller;

  const _WeeklyActivitySection({required this.controller});

  List<String> get _days => [
    'profile_sun'.tr, 'profile_mon'.tr, 'profile_tue'.tr, 'profile_wed'.tr,
    'profile_thu'.tr, 'profile_fri'.tr, 'profile_sat'.tr,
  ];

  static const _activity = [
    [0, 1, 2, 1, 0, 2, 1],
    [1, 2, 2, 0, 1, 1, 2],
    [2, 1, 0, 2, 2, 1, 0],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile_last_week'.tr,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _days.map((d) {
            return Expanded(
              child: Text(
                d,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 6),
        for (final row in _activity) ...[
          Row(
            children: List.generate(7, (i) {
              final val = row[i];
              return Expanded(
                child: Container(
                  height: 28,
                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: BoxDecoration(
                    color: _heatColor(val),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            }),
          ),
        ],
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'profile_less'.tr,
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
            const SizedBox(width: 6),
            ...[0, 1, 2].map((v) => Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: _heatColor(v),
                    borderRadius: BorderRadius.circular(3),
                  ),
                )),
            Text(
              'profile_more'.tr,
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Color _heatColor(int v) {
    switch (v) {
      case 0:
        return AppColors.borderDefault;
      case 1:
        return AppColors.cyan.withOpacity(0.35);
      case 2:
        return AppColors.cyan;
      default:
        return AppColors.borderDefault;
    }
  }
}

class _AchievementsSection extends StatelessWidget {
  static const _badges = [
    _BadgeData('🚀', 'Explorer', false),
    _BadgeData('🎓', 'Graduate', false),
    _BadgeData('⭐', 'Star Lvl 5', true, Color(0xFFF97316)),
    _BadgeData('🔬', 'Scientist', true, Color(0xFF22D3EE)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'profile_achievements'.tr,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'profile_view_all'.tr,
                  style: TextStyle(
                    color: AppColors.purple,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _badges.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => _AchievementBadge(data: _badges[i]),
          ),
        ),
      ],
    );
  }
}

class _BadgeData {
  final String icon;
  final String label;
  final bool earned;
  final Color? glowColor;

  const _BadgeData(this.icon, this.label, this.earned, [this.glowColor]);
}

class _AchievementBadge extends StatelessWidget {
  final _BadgeData data;

  const _AchievementBadge({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: data.earned
                ? data.glowColor?.withOpacity(0.15) ?? AppColors.bgCard
                : AppColors.bgCard,
            border: Border.all(
              color: data.earned
                  ? data.glowColor ?? AppColors.borderDefault
                  : AppColors.borderDefault,
              width: data.earned ? 2 : 1,
            ),
            boxShadow: data.earned && data.glowColor != null
                ? [
                    BoxShadow(
                      color: data.glowColor!.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              data.icon,
              style: TextStyle(
                fontSize: 26,
                color: data.earned ? null : AppColors.textMuted,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 64,
          child: Text(
            data.label,
            style: TextStyle(
              color: data.earned ? AppColors.textSecondary : AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

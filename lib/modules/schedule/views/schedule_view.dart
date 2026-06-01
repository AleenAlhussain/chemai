import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0D1E),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'schedule_mission_roadmap'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  'schedule_october_2024'.tr,
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Day card (horizontally scrollable)
            SizedBox(
              height: 72,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [_DayCard(dayLabel: 'MON', dayNumber: '14')],
              ),
            ),
            const SizedBox(height: 24),
            // Section header
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'schedule_todays_agenda'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  'schedule_tasks_remaining'.trParams({'count': '3'}),
                  style: TextStyle(
                    color: AppColors.amber,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Card 1 – Critical Challenge
            _CriticalChallengeCard(),
            const SizedBox(height: 12),
            // Card 2 – Visual Log
            _VisualLogCard(),
            const SizedBox(height: 12),
            // Card 3 – AI Consultation
            _AIConsultationCard(),
            const SizedBox(height: 20),
            // Bottom stats row
            Row(
              children: [
                Expanded(child: _StreakCard()),
                const SizedBox(width: 12),
                Expanded(child: _WeeklyGoalCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0A0D1E),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Text(
            'KIMO AI',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.psychology_rounded, color: AppColors.cyan, size: 20),
        ],
      ),
    );
  }
}

// ─── Day Card ──────────────────────────────────────────────────────────────────

class _DayCard extends StatelessWidget {
  final String dayLabel;
  final String dayNumber;

  const _DayCard({required this.dayLabel, required this.dayNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cyan, width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayLabel,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            dayNumber,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Card 1: Critical Challenge ────────────────────────────────────────────────

class _CriticalChallengeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.amber,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'schedule_critical_challenge'.tr,
                          style: TextStyle(
                            color: AppColors.amber,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.amber.withOpacity(0.4)),
                          ),
                          child: Text(
                            '+500 XP',
                            style: TextStyle(
                              color: AppColors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'schedule_quiz_title'.tr,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '25 mins',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(width: 14),
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: AppColors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'schedule_upcoming'.tr,
                          style: TextStyle(
                              color: AppColors.amber, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card 2: Visual Log ────────────────────────────────────────────────────────

class _VisualLogCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.cyan,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'schedule_visual_log'.tr,
                          style: TextStyle(
                            color: AppColors.cyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.play_circle_outline_rounded,
                            color: AppColors.cyan, size: 22),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'schedule_reel_title'.tr,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'schedule_mission_progress'.tr,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          '65%',
                          style: TextStyle(
                            color: AppColors.cyan,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.65,
                        backgroundColor: AppColors.borderDefault,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.cyan),
                        minHeight: 5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '8 mins',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(width: 14),
                        Icon(Icons.sync_rounded,
                            color: AppColors.cyan, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'schedule_in_progress'.tr,
                          style: TextStyle(
                              color: AppColors.cyan, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Card 3: AI Consultation ───────────────────────────────────────────────────

class _AIConsultationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnail
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.bgCardAlt,
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(color: AppColors.borderDefault),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'schedule_ai_consultation'.tr,
                                style: TextStyle(
                                  color: AppColors.purple,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'schedule_ai_title'.tr,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'schedule_ai_desc'.tr,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '15 mins',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.radio_button_unchecked_rounded,
                            color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'schedule_upcoming'.tr,
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 12),
                        ),
                        const Spacer(),
                        // Reschedule button
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textSecondary,
                            side: BorderSide(
                                color: AppColors.borderDefault, width: 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'schedule_reschedule'.tr,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Start Mission button
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: AppColors.gradientCyan,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'schedule_start_mission'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Streak Card ───────────────────────────────────────────────────────────────

class _StreakCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'schedule_current_streak'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '12',
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'schedule_days'.tr,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: AppColors.borderDefault,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyan),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Weekly Goal Card ──────────────────────────────────────────────────────────

class _WeeklyGoalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'schedule_weekly_goal'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '85%',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: LinearProgressIndicator(
              value: 0.85,
              backgroundColor: AppColors.borderDefault,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyan),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../data/models/schedule_model.dart';
import '../controllers/schedule_controller.dart';

class ScheduleView extends GetView<ScheduleController> {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        titleSpacing: 16,
        title:  Text(
          'STUDY PROTOCOL',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        actions: [
          IconButton(
            icon:  Icon(Icons.settings_outlined,
                color: AppColors.textSecondary, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Mission + efficiency ──────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        'CURRENT MISSION',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                       SizedBox(height: 4),
                       Text(
                        'Quantum Chemistry',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                 SizedBox(width: 12),
                _EfficiencyRing(
                  percent: controller.efficiency,
                  label: controller.efficiencyLabel,
                ),
              ],
            ),

             SizedBox(height: 20),

            // ── Calendar ──────────────────────────────────────────────────
            Container(
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Obx(() => _Calendar(
                    month: controller.currentMonth.value,
                    selectedDay: controller.selectedDay.value,
                    onPrev: controller.previousMonth,
                    onNext: controller.nextMonth,
                    onSelectDay: controller.selectDay,
                    daysInMonth: controller.daysInMonth(
                        controller.currentMonth.value),
                    firstWeekday: controller.firstWeekday(
                        controller.currentMonth.value),
                    monthName:
                        controller.monthName(controller.currentMonth.value),
                  )),
            ),

             SizedBox(height: 20),

            // ── Protocol status ───────────────────────────────────────────
             Text(
              'PROTOCOL STATUS',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 10),
            Container(
              padding:  EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Column(
                children: [
                  _StatusRow(
                      color: AppColors.green,
                      label: 'Completed',
                      count: controller.completed),
                   Divider(
                      color: AppColors.borderDefault, height: 16),
                  _StatusRow(
                      color: AppColors.purple,
                      label: 'Upcoming',
                      count: controller.upcoming),
                   Divider(
                      color: AppColors.borderDefault, height: 16),
                  _StatusRow(
                      color:  Color(0xFFEF4444),
                      label: 'Missed',
                      count: controller.missed),
                ],
              ),
            ),

             SizedBox(height: 20),

            // ── Session timeline ──────────────────────────────────────────
            ...controller.sessions.map((s) => _SessionCard(session: s)),

             SizedBox(height: 16),

            // ── Interruption warning ──────────────────────────────────────
            Container(
              padding:  EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:  Color(0xFF2A1500),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.warning.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                       Icon(Icons.warning_amber_rounded,
                          color: AppColors.warning, size: 16),
                       SizedBox(width: 8),
                       Text(
                        'PROTOCOL INTERRUPTION DETECTED',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                   SizedBox(height: 8),
                   Text(
                    "You missed 'Lab Simulation: Titration' yesterday. AI suggests rescheduling to 21:00 tonight to maintain streak.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                   SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.warning.withOpacity(0.4)),
                      ),
                      child:  Text(
                        'Approve Reschedule',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

             SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ── Efficiency ring ───────────────────────────────────────────────────────────
class _EfficiencyRing extends StatelessWidget {
  final double percent;
  final String label;
  const _EfficiencyRing({required this.percent, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: CustomPaint(
            painter: _RingPainter(percent: percent),
            child: Center(
              child: Text(
                '${(percent * 100).toInt()}%',
                style:  TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
         SizedBox(height: 4),
         Text(
          'Daily Efficiency',
          style: TextStyle(color: AppColors.textMuted, fontSize: 10),
        ),
        Text(
          label,
          style:  TextStyle(
            color: AppColors.green,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  const _RingPainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 5;

    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = AppColors.borderDefault
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      2 * pi * percent,
      false,
      Paint()
        ..color = AppColors.purple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.percent != percent;
}

// ── Calendar ──────────────────────────────────────────────────────────────────
class _Calendar extends StatelessWidget {
  final DateTime month;
  final int selectedDay;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final ValueChanged<int> onSelectDay;
  final int daysInMonth;
  final int firstWeekday;
  final String monthName;

  const _Calendar({
    required this.month,
    required this.selectedDay,
    required this.onPrev,
    required this.onNext,
    required this.onSelectDay,
    required this.daysInMonth,
    required this.firstWeekday,
    required this.monthName,
  });

  @override
  Widget build(BuildContext context) {
    const dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final cells = <Widget>[];
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int d = 1; d <= daysInMonth; d++) {
      final isSelected = d == selectedDay;
      cells.add(GestureDetector(
        onTap: () => onSelectDay(d),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.purple : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            '$d',
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : AppColors.textSecondary,
              fontSize: 12,
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ));
    }

    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              monthName,
              style:  TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: onPrev,
                  child:  Icon(Icons.chevron_left,
                      color: AppColors.textSecondary, size: 20),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onNext,
                  child:  Icon(Icons.chevron_right,
                      color: AppColors.textSecondary, size: 20),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Day labels
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: 1.2,
          children: dayLabels
              .map((d) => Center(
                    child: Text(d,
                        style:  TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        )),
                  ))
              .toList(),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          childAspectRatio: 1.2,
          children: cells,
        ),
      ],
    );
  }
}

// ── Protocol status row ───────────────────────────────────────────────────────
class _StatusRow extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  const _StatusRow(
      {required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style:  TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ),
        Text(
          count.toString().padLeft(2, '0'),
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Session card ──────────────────────────────────────────────────────────────
class _SessionCard extends StatelessWidget {
  final ScheduleSession session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = switch (session.status) {
      SessionStatus.completed => AppColors.green,
      SessionStatus.active => AppColors.purple,
      SessionStatus.upcoming => AppColors.textMuted,
    };

    final String statusLabel = switch (session.status) {
      SessionStatus.completed => 'Completed',
      SessionStatus.active => 'Active',
      SessionStatus.upcoming => 'Upcoming',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: session.status == SessionStatus.active
              ? AppColors.purple.withOpacity(0.4)
              : AppColors.borderDefault,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time + status column
          SizedBox(
            width: 68,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.time,
                  style:  TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                 SizedBox(height: 3),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Vertical divider line
          Container(
            width: 1,
            height: null,
            constraints: const BoxConstraints(minHeight: 50),
            color: AppColors.borderDefault,
            margin: const EdgeInsets.only(right: 12),
          ),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (session.status == SessionStatus.active)
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.purple,
                        ),
                      ),
                       Text(
                        'AI Tutoring Session',
                        style: TextStyle(
                          color: AppColors.purple,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                if (session.status == SessionStatus.active)
                   SizedBox(height: 4),
                Text(
                  session.status == SessionStatus.active
                      ? session.title
                      : session.title,
                  style:  TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                 SizedBox(height: 4),
                Text(
                  session.description,
                  style:  TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                if (session.extra != null) ...[
                   SizedBox(height: 4),
                  Text(
                    session.extra!,
                    style:  TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
                if (session.hasAction) ...[
                   SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding:  EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child:  Text(
                            'Connect Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                       SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {},
                        child:  Text(
                          'View Assets',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (session.isVerified) ...[
                   SizedBox(height: 8),
                  Container(
                    padding:  EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: AppColors.green.withOpacity(0.3)),
                    ),
                    child:  Text(
                      '✓ Verified',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

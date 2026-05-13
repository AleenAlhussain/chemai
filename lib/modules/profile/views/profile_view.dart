import 'dart:math';

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
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        titleSpacing: 16,
        leading: Padding(
          padding:  EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgCard,
              border: Border.all(color: AppColors.borderDefault),
            ),
            child:  Icon(Icons.person_outline,
                color: AppColors.textSecondary, size: 18),
          ),
        ),
        title:  Text(
          'PERFORMANCE DATA',
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
        padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Three stat rings ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatRing(
                  percent: controller.xpPercent,
                  color: AppColors.purple,
                  label: '${controller.xp ~/ 1000},${(controller.xp % 1000).toString().padLeft(3, '0')} XP',
                  sub: 'Level ${controller.level} ${controller.levelTitle}',
                ),
                _StatRing(
                  percent: controller.lessonsPercent,
                  color:  Color(0xFFFBBF24),
                  label: '${controller.lessonsCompleted}/${controller.lessonsTotal}',
                  sub: controller.lessonsCourse,
                ),
                _StatRing(
                  percent: controller.accuracyPercent,
                  color: AppColors.green,
                  label: controller.rankLabel,
                  sub: controller.rankSub,
                ),
              ],
            ),

             SizedBox(height: 24),

            // ── Study Consistency ─────────────────────────────────────────
            _SectionTitle('Study Consistency'),
             SizedBox(height: 4),
             Text(
              'Daily interaction map for the last 12 weeks',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
             SizedBox(height: 10),
            _HeatmapLegend(),
             SizedBox(height: 8),
            _Heatmap(data: controller.heatmap),

             SizedBox(height: 24),

            // ── Scientific Milestones ────────────────────────────────────
            _SectionTitle('Scientific Milestones'),
             SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              physics:  NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.0,
              children: controller.milestones
                  .map((m) => _MilestoneBadge(milestone: m))
                  .toList(),
            ),

             SizedBox(height: 24),

            // ── Learning Speed ────────────────────────────────────────────
            _SectionTitle('Learning Speed'),
             SizedBox(height: 14),
            Container(
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Column(
                children: List.generate(controller.learningSpeed.length, (i) {
                  final (subject, pct) = controller.learningSpeed[i];
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: i < controller.learningSpeed.length - 1 ? 16 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(subject,
                                style:  TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                            Text(controller.speedLabels[i],
                                style:  TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                         SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 5,
                            backgroundColor: AppColors.borderDefault,
                            valueColor:  AlwaysStoppedAnimation<Color>(
                                AppColors.purple),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

             SizedBox(height: 24),

            // ── AI Assistance Rate ────────────────────────────────────────
            _SectionTitle('AI Assistance Rate'),
             SizedBox(height: 14),
            Container(
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.aiRate}%',
                          style:  TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                         SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              '${controller.aiTrend}% from last week',
                              style:  TextStyle(
                                color: AppColors.green,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: 2),
                         Text(
                          'Reliance on AI',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 11),
                        ),
                         Text(
                          'Independence is growing up',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                   SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding:  EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgCardAlt,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: Text(
                        controller.aiQuote,
                        style:  TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
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

// ── Section title ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
   _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:  TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ── Circular stat ring ────────────────────────────────────────────────────────
class _StatRing extends StatelessWidget {
  final double percent;
  final Color color;
  final String label;
  final String sub;

  const _StatRing({
    required this.percent,
    required this.color,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: _ArcPainter(percent: percent, color: color),
            child: Center(
              child: Text(
                '${(percent * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
         SizedBox(height: 8),
        Text(
          label,
          style:  TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
         SizedBox(height: 2),
        Text(
          sub,
          style:  TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double percent;
  final Color color;
  const _ArcPainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2 - 6;

    final track = Paint()
      ..color = AppColors.borderDefault
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawCircle(Offset(cx, cy), r, track);

    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      2 * pi * percent,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.percent != percent || old.color != color;
}

// ── Heatmap ───────────────────────────────────────────────────────────────────
class _HeatmapLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Text('Less',
            style:
                TextStyle(color: AppColors.textMuted, fontSize: 10)),
         SizedBox(width: 6),
        ...[0, 1, 2, 3].map((v) => Container(
              width: 10,
              height: 10,
              margin:  EdgeInsets.only(right: 3),
              decoration: BoxDecoration(
                color: _cellColor(v),
                borderRadius: BorderRadius.circular(2),
              ),
            )),
         SizedBox(width: 4),
         Text('More',
            style:
                TextStyle(color: AppColors.textMuted, fontSize: 10)),
      ],
    );
  }
}

class _Heatmap extends StatelessWidget {
  final List<List<int>> data;
  const _Heatmap({required this.data});

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day labels
        Row(
          children: [
             SizedBox(width: 4),
            ...days.map((d) => SizedBox(
                  width: 14,
                  child: Text(d,
                      style:  TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 9),
                      textAlign: TextAlign.center),
                )),
          ],
        ),
        const SizedBox(height: 4),
        // Weeks
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.map((week) {
            return Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Column(
                children: week.map((v) {
                  return Container(
                    width: 11,
                    height: 11,
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      color: _cellColor(v),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

Color _cellColor(int v) {
  switch (v) {
    case 0:
      return AppColors.borderDefault;
    case 1:
      return AppColors.purpleDim;
    case 2:
      return AppColors.purple.withOpacity(0.6);
    case 3:
      return AppColors.purple;
    default:
      return AppColors.borderDefault;
  }
}

// ── Milestone badge ───────────────────────────────────────────────────────────
class _MilestoneBadge extends StatelessWidget {
  final dynamic milestone;
  const _MilestoneBadge({required this.milestone});

  @override
  Widget build(BuildContext context) {
    final bool unlocked = milestone.unlocked as bool;
    return Container(
      decoration: BoxDecoration(
        color: unlocked
            ? const Color(0xFF1A1830)
            : AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: unlocked
              ? const Color(0xFFFBBF24).withOpacity(0.35)
              : AppColors.borderDefault,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            unlocked ? milestone.icon as String : '🔒',
            style: TextStyle(
                fontSize: unlocked ? 22 : 18,
                color: unlocked ? null : AppColors.textMuted),
          ),
          const SizedBox(height: 6),
          Text(
            milestone.label as String,
            style: TextStyle(
              color: unlocked
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

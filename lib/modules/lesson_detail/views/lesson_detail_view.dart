import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/lesson_detail_controller.dart';

class LessonDetailView extends GetView<LessonDetailController> {
  const LessonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        leading: Padding(
          padding:  EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
              border: Border.all(color: Colors.white24),
            ),
            child:  Icon(Icons.person_outline,
                color: Colors.white70, size: 18),
          ),
        ),
        title:  Text(
          'QUANTUM CHEMISTRY',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        actions: [
          IconButton(
            icon:  Icon(Icons.settings_outlined,
                color: Colors.white70, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Full-screen molecular visualization ──────────────────────
          SizedBox.expand(
            child: CustomPaint(
              painter: _MolecularFieldPainter(),
            ),
          ),

          // ── Right sidebar actions ────────────────────────────────────
          Positioned(
            right: 12,
            bottom: 140,
            child: Column(
              children: [
                // Creator avatar
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purple,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child:  Icon(Icons.school_outlined,
                      color: Colors.white, size: 22),
                ),

                 SizedBox(height: 20),

                _SideAction(
                  icon: Icons.favorite_rounded,
                  label: controller.formatCount(controller.likes),
                  onTap: controller.toggleLike,
                ),
                 SizedBox(height: 18),
                _SideAction(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: controller.formatCount(controller.comments),
                  onTap: () {},
                ),
                 SizedBox(height: 18),
                _SideAction(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  onTap: () {},
                ),
                 SizedBox(height: 18),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white12,
                    border: Border.all(color: Colors.white24),
                  ),
                  child:  Icon(Icons.science_outlined,
                      color: Colors.white70, size: 18),
                ),
              ],
            ),
          ),

          // ── Bottom info overlay ──────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.85),
                    Colors.black,
                  ],
                  stops:  [0.0, 0.4, 1.0],
                ),
              ),
              padding:  EdgeInsets.fromLTRB(16, 40, 60, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Chapter badge
                  Container(
                    padding:  EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Text('⚗️',
                            style: TextStyle(fontSize: 12)),
                         SizedBox(width: 6),
                        Text(
                          controller.chapterLabel,
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                   SizedBox(height: 10),

                  Text(
                    controller.title,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                   SizedBox(height: 6),

                  Text(
                    controller.description,
                    style:  TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                   SizedBox(height: 12),

                  // Duration + difficulty
                  Obx(() => Row(
                        children: [
                          _TagPill(
                            icon: Icons.timer_outlined,
                            text:
                                '${controller.currentTime} / ${controller.totalTime}',
                          ),
                           SizedBox(width: 8),
                          _TagPill(
                            icon: Icons.bolt_outlined,
                            text: controller.difficulty,
                          ),
                        ],
                      )),

                   SizedBox(height: 10),

                  // Progress bar
                  Obx(() => LinearProgressIndicator(
                        value: controller.progress,
                        minHeight: 2,
                        backgroundColor: Colors.white24,
                        valueColor:  AlwaysStoppedAnimation<Color>(
                            AppColors.purple),
                      )),

                  const SizedBox(height: 56),
                ],
              ),
            ),
          ),

          // ── Minimal bottom nav ───────────────────────────────────────
          Positioned(
            left: 16,
            right: 16,
            bottom: 12,
            child: _BottomNavBar(activeIndex: 1),
          ),
        ],
      ),
    );
  }
}

// ── Side action button ────────────────────────────────────────────────────────
class _SideAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SideAction(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Duration / difficulty pill ────────────────────────────────────────────────
class _TagPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _TagPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 12),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── Minimal bottom nav bar ────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int activeIndex;
  const _BottomNavBar({required this.activeIndex});

  static const _items = [
    (icon: Icons.home_outlined, label: 'HOME'),
    (icon: Icons.school_outlined, label: 'LESSONS'),
    (icon: Icons.psychology_outlined, label: 'ASK AI'),
    (icon: Icons.science_outlined, label: 'LAB'),
    (icon: Icons.person_outline, label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.bgCard.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == activeIndex;
          return GestureDetector(
            onTap: () => Get.back(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon,
                      size: 20,
                      color: isActive
                          ? AppColors.purple
                          : AppColors.textMuted),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: isActive
                          ? AppColors.purple
                          : AppColors.textMuted,
                      fontSize: 7,
                      letterSpacing: 0.5,
                      fontWeight: isActive
                          ? FontWeight.w700
                          : FontWeight.w400,
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

// ── Dense molecular field painter ─────────────────────────────────────────────
class _MolecularFieldPainter extends CustomPainter {
  static final _rng = Random(42);

  static final _nodes = List.generate(80, (_) {
    return Offset(
      _rng.nextDouble(),
      _rng.nextDouble(),
    );
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Black background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.black);

    final scaledNodes =
        _nodes.map((n) => Offset(n.dx * size.width, n.dy * size.height))
            .toList();

    // Draw edges between nearby nodes
    final edgePaint = Paint()
      ..color = const Color(0xFF00AACC).withOpacity(0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < scaledNodes.length; i++) {
      for (int j = i + 1; j < scaledNodes.length; j++) {
        final d = (scaledNodes[i] - scaledNodes[j]).distance;
        if (d < size.width * 0.18) {
          canvas.drawLine(scaledNodes[i], scaledNodes[j], edgePaint);
        }
      }
    }

    // Draw spheres (nodes) with radial gradient
    for (final n in scaledNodes) {
      final r = size.width * 0.028;
      final rect = Rect.fromCircle(center: n, radius: r);

      canvas.drawCircle(
        n,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFF00DDFF),
              const Color(0xFF007ACC),
              const Color(0xFF004466),
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(rect),
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

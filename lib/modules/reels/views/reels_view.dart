import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/reels_controller.dart';

class ReelsView extends GetView<ReelsController> {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: const Icon(Icons.bolt, color: Colors.white, size: 20),
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
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgCard,
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Icon(Icons.account_circle_outlined, color: AppColors.purple, size: 22),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _MolecularBackground(controller: controller),
          _TopOverlay(controller: controller),
          _RightSidebar(controller: controller),
          _BottomCard(controller: controller),
        ],
      ),
    );
  }
}

class _MolecularBackground extends StatelessWidget {
  final ReelsController controller;
  const _MolecularBackground({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            controller.nextReel();
          } else if (details.primaryVelocity! > 0) {
            controller.previousReel();
          }
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF020408),
        child: Center(
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.cyan.withOpacity(0.15), Colors.transparent],
              ),
            ),
            child: CustomPaint(
              painter: _AtomPainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class _AtomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final orbitPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final dotPaint = Paint()
      ..color = AppColors.cyan
      ..style = PaintingStyle.fill;
    final corePaint = Paint()
      ..color = AppColors.cyan
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 18, Paint()..color = AppColors.cyan.withOpacity(0.3)..style = PaintingStyle.fill);
    canvas.drawCircle(center, 10, corePaint);

    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(i * pi / 3);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: size.width * 0.75, height: size.height * 0.3), orbitPaint);
      canvas.drawCircle(Offset(size.width * 0.375, 0), 6, dotPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

class _TopOverlay extends StatelessWidget {
  final ReelsController controller;
  const _TopOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top + kToolbarHeight;
    return Positioned(
      top: topPad + 8,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Obx(() => Text(
                        controller.timeLabel,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Obx(() => Text(
                        controller.current.chapter,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RightSidebar extends StatelessWidget {
  final ReelsController controller;
  const _RightSidebar({required this.controller});

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 12,
      bottom: 160,
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.toggleLike,
            child: Column(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: Obx(() => Icon(
                        controller.isLiked.value ? Icons.favorite : Icons.favorite_border,
                        color: controller.isLiked.value ? Colors.red : Colors.white,
                        size: 22,
                      )),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      _formatCount(controller.current.likes + (controller.isLiked.value ? 1 : 0)),
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: controller.toggleSave,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.bgCard,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Obx(() => Icon(
                    controller.isSaved.value ? Icons.bookmark : Icons.bookmark_border,
                    color: controller.isSaved.value ? Colors.amber : Colors.white,
                    size: 22,
                  )),
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: const Icon(Icons.share_outlined, color: Colors.white, size: 22),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.gradientPurple,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: const Icon(Icons.link, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}

class _BottomCard extends StatelessWidget {
  final ReelsController controller;
  const _BottomCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Obx(() => Text(
                          controller.current.description,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        )),
                  ),
                  const SizedBox(width: 8),
                  const Text('✏️', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => Text(
                  controller.current.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            const SizedBox(height: 10),
            Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: controller.progress,
                    color: AppColors.cyan,
                    backgroundColor: Colors.white24,
                    minHeight: 3,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

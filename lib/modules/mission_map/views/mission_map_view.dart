import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/mission_map_controller.dart';

class MissionMapView extends GetView<MissionMapController> {
  const MissionMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070A1E),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Main scrollable content
          Obx(() => ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  // Stats row
                  _StatsRow(controller: controller),
                  const SizedBox(height: 24),

                  // Sectors
                  ...controller.sectors.map(
                    (sector) => _SectorWidget(sector: sector),
                  ),
                ],
              )),

          // Floating transmission bubble
          Obx(() {
            if (!controller.showTransmission.value) return const SizedBox.shrink();
            return Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _TransmissionBubble(controller: controller),
            );
          }),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0C0F2A),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textSecondary),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'mission_map_title'.tr,
        style: TextStyle(
          color: AppColors.cyan,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
        ),
      ),
      actions: [
        Obx(() => Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cyan, width: 1),
              ),
              child: Text(
                'mission_map_xp'.trParams({'xp': _formatXP(controller.xp.value)}),
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            )),
      ],
    );
  }

  String _formatXP(int xp) {
    if (xp >= 1000) {
      final s = xp.toString();
      return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
    }
    return xp.toString();
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final MissionMapController controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Obx(() => Row(
            children: [
              _StatCell(
                icon: Icons.public,
                label: 'mission_map_planets'.tr,
                value: controller.planetsConquered.value
                    .toString()
                    .padLeft(2, '0'),
                valueColor: AppColors.cyan,
              ),
              _VerticalDivider(),
              _StatCell(
                icon: Icons.hub,
                label: 'mission_map_nodes'.tr,
                value: controller.nodesSynced.value,
                valueColor: AppColors.textPrimary,
              ),
              _VerticalDivider(),
              _StatCell(
                icon: Icons.military_tech,
                label: 'mission_map_rank'.tr,
                value: controller.currentRank.value,
                valueColor: AppColors.textPrimary,
              ),
            ],
          )),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.borderDefault,
    );
  }
}

class _StatCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 14),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sector widget ─────────────────────────────────────────────────────────────
class _SectorWidget extends StatelessWidget {
  final MissionSector sector;
  const _SectorWidget({required this.sector});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sector header
          _SectorHeader(sector: sector),
          const SizedBox(height: 12),

          // Nodes
          ...sector.nodes.map(
            (node) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _NodeCard(node: node, sectorNumber: sector.number),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectorHeader extends StatelessWidget {
  final MissionSector sector;
  const _SectorHeader({required this.sector});

  Color get _iconColor {
    switch (sector.status) {
      case SectorStatus.completed:
        return AppColors.green;
      case SectorStatus.active:
        return AppColors.cyan;
      case SectorStatus.locked:
        return AppColors.textMuted;
    }
  }

  IconData get _icon {
    switch (sector.status) {
      case SectorStatus.completed:
        return Icons.check_circle;
      case SectorStatus.active:
        return Icons.radio_button_checked;
      case SectorStatus.locked:
        return Icons.lock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _iconColor.withOpacity(0.15),
            border: Border.all(color: _iconColor.withOpacity(0.4)),
          ),
          child: Icon(_icon, color: _iconColor, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          '${'mission_map_sector'.tr} ${sector.number}: ${sector.title}',
          style: TextStyle(
            color: sector.status == SectorStatus.locked
                ? AppColors.textMuted
                : AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── Node cards ────────────────────────────────────────────────────────────────
class _NodeCard extends StatelessWidget {
  final MissionNode node;
  final int sectorNumber;
  const _NodeCard({required this.node, required this.sectorNumber});

  @override
  Widget build(BuildContext context) {
    switch (node.status) {
      case NodeStatus.completed:
        return _CompletedNode(node: node, sectorNumber: sectorNumber);
      case NodeStatus.active:
        return _ActiveNode(node: node, sectorNumber: sectorNumber);
      case NodeStatus.locked:
        return _LockedNode(node: node, sectorNumber: sectorNumber);
    }
  }
}

class _CompletedNode extends StatelessWidget {
  final MissionNode node;
  final int sectorNumber;
  const _CompletedNode({required this.node, required this.sectorNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.green.withOpacity(0.15),
              border: Border.all(color: AppColors.green.withOpacity(0.4)),
            ),
            child: Icon(Icons.check, color: AppColors.green, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${'mission_map_lesson'.tr} ${node.id}',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  node.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.green.withOpacity(0.3)),
            ),
            child: Text(
              'mission_map_completed'.tr,
              style: TextStyle(
                color: AppColors.green,
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveNode extends StatelessWidget {
  final MissionNode node;
  final int sectorNumber;
  const _ActiveNode({required this.node, required this.sectorNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cyan.withOpacity(0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.cyan.withOpacity(0.12),
            blurRadius: 16,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Circle icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyan.withOpacity(0.15),
                  border: Border.all(color: AppColors.cyan.withOpacity(0.5), width: 1.5),
                ),
                child: Icon(Icons.play_arrow_rounded, color: AppColors.cyan, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'mission_map_current_focus'.tr,
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 9,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      node.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // ACTIVE badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cyan.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cyan.withOpacity(0.5)),
                ),
                child: Text(
                  'mission_map_active'.tr,
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: node.progress,
              backgroundColor: AppColors.borderDefault,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyan),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(node.progress * 100).toInt()}%',
              style: TextStyle(
                color: AppColors.cyan,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedNode extends StatelessWidget {
  final MissionNode node;
  final int sectorNumber;
  const _LockedNode({required this.node, required this.sectorNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.textMuted.withOpacity(0.1),
              border: Border.all(color: AppColors.textMuted.withOpacity(0.2)),
            ),
            child: Icon(Icons.lock_outline, color: AppColors.textMuted, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'mission_map_up_next'.tr,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  node.title,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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

// ── Transmission bubble ───────────────────────────────────────────────────────
class _TransmissionBubble extends StatelessWidget {
  final MissionMapController controller;
  const _TransmissionBubble({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.dismissTransmission,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.cyan.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'mission_map_transmission'.tr,
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 9,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Icon(Icons.close, color: AppColors.textMuted, size: 14),
              ],
            ),
            const SizedBox(height: 6),
            Obx(() => Text(
                  controller.transmissionText.value,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

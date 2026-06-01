import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/periodic_table_controller.dart';

String _periodicCategoryLabel(String key) {
  switch (key) {
    case 'Non-metal':
      return 'periodic_table_cat_nonmetal'.tr;
    case 'Noble Gas':
      return 'periodic_table_cat_noble_gas'.tr;
    case 'Alkali Metal':
      return 'periodic_table_cat_alkali'.tr;
    case 'Transition Metal':
      return 'periodic_table_cat_transition'.tr;
    case 'Halogen':
      return 'periodic_table_cat_halogen'.tr;
    case 'Alkaline Earth':
      return 'periodic_table_cat_alkaline'.tr;
    default:
      return key;
  }
}

class PeriodicTableView extends GetView<PeriodicTableController> {
  const PeriodicTableView({super.key});

  static const _categories = {
    'Non-metal': Color(0xFF34D399),
    'Noble Gas': Color(0xFF22D3EE),
    'Alkali Metal': Color(0xFFEF4444),
    'Transition Metal': Color(0xFF8B7DF8),
    'Halogen': Color(0xFFA3E635),
    'Alkaline Earth': Color(0xFFF97316),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          // ── Search bar ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: TextField(
                  onChanged: controller.updateSearch,
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'periodic_table_search_hint'.tr,
                    hintStyle:
                        TextStyle(color: AppColors.textMuted, fontSize: 13),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: AppColors.textMuted, size: 20),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 350.ms),
          ),

          // ── State filter row ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  _StateFilterChip(
                    label: 'kimo_table_all_states'.tr,
                    value: 'all',
                    selected: controller.stateFilter.value == 'all',
                    onTap: () => controller.updateStateFilter('all'),
                  ),
                  const SizedBox(width: 8),
                  _StateFilterChip(
                    label: 'kimo_table_solid'.tr,
                    value: 'solid',
                    selected: controller.stateFilter.value == 'solid',
                    onTap: () => controller.updateStateFilter('solid'),
                  ),
                  const SizedBox(width: 8),
                  _StateFilterChip(
                    label: 'kimo_table_liquid'.tr,
                    value: 'liquid',
                    selected: controller.stateFilter.value == 'liquid',
                    onTap: () => controller.updateStateFilter('liquid'),
                  ),
                  const SizedBox(width: 8),
                  _StateFilterChip(
                    label: 'kimo_table_gas'.tr,
                    value: 'gas',
                    selected: controller.stateFilter.value == 'gas',
                    onTap: () => controller.updateStateFilter('gas'),
                  ),
                ],
              ),
            )),
          ),

          // ── Featured element card ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Obx(() {
              final el = controller.selected.value ??
                  (controller.elements.isNotEmpty
                      ? controller.elements.first
                      : null);
              if (el == null) return const SizedBox.shrink();
              return _FeaturedElementCard(element: el)
                  .animate()
                  .fadeIn(duration: 400.ms);
            }),
          ),

          // ── Element grid ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            sliver: Obx(() {
              final filtered = controller.filteredElements;
              if (filtered.isEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded,
                              color: AppColors.textMuted, size: 40),
                          const SizedBox(height: 12),
                          Text(
                            'periodic_table_empty'.tr,
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final el = filtered[i];
                    return GestureDetector(
                      onTap: () => controller.selectElement(el),
                      child: _ElementTile(element: el)
                          .animate(delay: (i * 40).ms)
                          .fadeIn(duration: 300.ms)
                          .scale(
                              begin: const Offset(0.85, 0.85),
                              end: const Offset(1, 1)),
                    );
                  },
                  childCount: filtered.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
              );
            }),
          ),

          // ── Virtual Lab banner ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: _VirtualLabBanner().animate().fadeIn(duration: 500.ms),
          ),

          // ── Current Mission banner ─────────────────────────────────────
          SliverToBoxAdapter(
            child: _CurrentMissionBanner().animate().fadeIn(duration: 550.ms),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgBase,
      elevation: 0,
      leading: IconButton(
        icon:
            Icon(Icons.menu_rounded, color: AppColors.textSecondary, size: 22),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'kimo_table_title'.tr,
        style: TextStyle(
          color: AppColors.cyan,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 3.0,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded,
              color: AppColors.textSecondary, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ── State filter chip ─────────────────────────────────────────────────────────
class _StateFilterChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _StateFilterChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.cyan.withOpacity(0.12)
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.cyan : AppColors.borderDefault,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.cyan : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

// ── Featured element card ─────────────────────────────────────────────────────
class _FeaturedElementCard extends StatelessWidget {
  final ElementData element;
  const _FeaturedElementCard({required this.element});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: element.color.withOpacity(0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: element.color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kimo AI tip bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cyan.withOpacity(0.08),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                border: Border(
                  bottom: BorderSide(
                      color: AppColors.cyan.withOpacity(0.2), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology_rounded,
                      color: AppColors.cyan, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${'kimo_table_kimo_tip'.tr} · ',
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      element.kimoTip,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Symbol area
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Big symbol with atomic number badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: element.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: element.color.withOpacity(0.4),
                                  width: 2),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              element.symbol,
                              style: TextStyle(
                                color: AppColors.cyan,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            left: 8,
                            child: Text(
                              element.number.toString(),
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              element.name,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: element.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _periodicCategoryLabel(element.category)
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: element.color,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 2x2 data grid
                  Row(
                    children: [
                      Expanded(
                        child: _DataCell(
                          label: 'kimo_table_atomic_mass'.tr,
                          value: '${element.mass.toStringAsFixed(3)} u',
                          color: element.color,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DataCell(
                          label: 'kimo_table_melting_point'.tr,
                          value: '${element.meltingPoint}°C',
                          color: AppColors.cyan,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _DataCell(
                          label: 'kimo_table_density'.tr,
                          value: '${element.density} g/cm³',
                          color: AppColors.purple,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DataCell(
                          label: 'kimo_table_config'.tr,
                          value: element.config,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _DataCell(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgCardAlt,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Element tile ──────────────────────────────────────────────────────────────
class _ElementTile extends StatelessWidget {
  final ElementData element;
  const _ElementTile({required this.element});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: element.color.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: element.color.withOpacity(0.08),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            element.number.toString(),
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              element.symbol,
              style: TextStyle(
                color: element.color,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              element.name,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Center(
            child: Text(
              element.mass.toStringAsFixed(2),
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Virtual Lab banner ────────────────────────────────────────────────────────
class _VirtualLabBanner extends StatelessWidget {
  const _VirtualLabBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.cyan.withOpacity(0.15),
              AppColors.bgCard,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cyan.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'kimo_table_virtual_lab'.tr,
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'kimo_table_simulate'.tr,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => Get.toNamed('/virtual-lab'),
              icon: Icon(Icons.science_rounded,
                  color: AppColors.cyan, size: 16),
              label: Text(
                'kimo_table_enter_lab'.tr,
                style: TextStyle(
                  color: AppColors.cyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.cyan, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Current Mission banner ────────────────────────────────────────────────────
class _CurrentMissionBanner extends StatelessWidget {
  const _CurrentMissionBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'kimo_table_current_mission'.tr,
                    style: TextStyle(
                      color: AppColors.cyan,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'kimo_table_mission_name'.tr,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Avatar circles
                      SizedBox(
                        width: 36,
                        height: 20,
                        child: Stack(
                          children: [
                            _AvatarCircle(offset: 0, color: AppColors.purple),
                            _AvatarCircle(
                                offset: 14, color: AppColors.cyan),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'kimo_table_students_online'
                            .trParams({'count': '8'}),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cyan,
                foregroundColor: AppColors.bgBase,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                'kimo_table_start'.tr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarCircle extends StatelessWidget {
  final double offset;
  final Color color;
  const _AvatarCircle({required this.offset, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.bgCard, width: 2),
        ),
        child: Icon(Icons.person_rounded, color: color, size: 10),
      ),
    );
  }
}

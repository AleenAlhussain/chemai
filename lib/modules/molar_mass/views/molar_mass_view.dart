import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/molar_mass_controller.dart';

// Distinct colors per element index for breakdown bars
const _elementColors = [
  Color(0xFF22D3EE),
  Color(0xFF34D399),
  Color(0xFF8B7DF8),
  Color(0xFFF97316),
  Color(0xFFEF4444),
  Color(0xFFFBBF24),
  Color(0xFFA3E635),
  Color(0xFFEC4899),
];

class MolarMassView extends GetView<MolarMassController> {
  const MolarMassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Input card ─────────────────────────────────────────────────
            _InputCard(controller: controller)
                .animate()
                .fadeIn(duration: 350.ms),

            const SizedBox(height: 16),

            // ── Result section ─────────────────────────────────────────────
            Obx(() {
              if (!controller.hasResult.value) return const SizedBox.shrink();
              return _ResultSection(controller: controller)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.05, end: 0);
            }),

            const SizedBox(height: 20),

            // ── Educational tip ────────────────────────────────────────────
            _TipBar().animate().fadeIn(duration: 600.ms, delay: 200.ms),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.bgBase,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded,
            color: AppColors.textSecondary, size: 22),
        onPressed: () => Get.back(),
      ),
      title: Text(
        'molar_mass_title'.tr,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

// ── Input card ────────────────────────────────────────────────────────────────
class _InputCard extends StatelessWidget {
  final MolarMassController controller;
  const _InputCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'molar_mass_formula_label'.tr,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgCardAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: TextField(
              controller: controller.inputController,
              onChanged: (v) => controller.formula.value = v,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
              cursorColor: AppColors.cyan,
              decoration: InputDecoration(
                hintText: 'molar_mass_hint'.tr,
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // EXAMPLE button
              OutlinedButton(
                onPressed: controller.loadExample,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.cyan, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text(
                  'molar_mass_example'.tr,
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // CALCULATE button
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientCyan,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: controller.calculate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'molar_mass_calculate'.tr,
                      style: TextStyle(
                        color: AppColors.bgBase,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // CLEAR button
              TextButton(
                onPressed: controller.clear,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                child: Text(
                  'molar_mass_clear'.tr,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Result section ────────────────────────────────────────────────────────────
class _ResultSection extends StatelessWidget {
  final MolarMassController controller;
  const _ResultSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Big result card
        Obx(() {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cyan.withOpacity(0.12),
                  AppColors.bgCard,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.cyan.withOpacity(0.35), width: 1.5),
            ),
            child: Column(
              children: [
                Text(
                  controller.formula.value,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '= ${controller.totalMolarMass.value.toStringAsFixed(3)} ',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'molar_mass_unit'.tr,
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'molar_mass_label'.tr,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 20),

        // ELEMENT BREAKDOWN label
        Text(
          'molar_mass_breakdown'.tr,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),

        // Contribution rows
        Obx(() {
          final total = controller.totalMolarMass.value;
          return Column(
            children: controller.contributions.asMap().entries.map((entry) {
              final idx = entry.key;
              final contrib = entry.value;
              final color = _elementColors[idx % _elementColors.length];
              final proportion = total > 0 ? contrib.totalMass / total : 0.0;
              return _ContributionRow(
                contribution: contrib,
                color: color,
                proportion: proportion,
              )
                  .animate(delay: (idx * 80).ms)
                  .fadeIn(duration: 300.ms)
                  .slideX(begin: -0.05, end: 0);
            }).toList(),
          );
        }),
      ],
    );
  }
}

// ── Contribution row ──────────────────────────────────────────────────────────
class _ContributionRow extends StatelessWidget {
  final ElementContribution contribution;
  final Color color;
  final double proportion;
  const _ContributionRow({
    required this.contribution,
    required this.color,
    required this.proportion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Symbol circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.4), width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  contribution.symbol,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${contribution.count} × ${contribution.atomicMass.toStringAsFixed(3)} = ${contribution.totalMass.toStringAsFixed(3)} g/mol',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(proportion * 100).toStringAsFixed(1)}% of total mass',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: proportion,
              minHeight: 5,
              backgroundColor: AppColors.bgCardAlt,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tip bar ───────────────────────────────────────────────────────────────────
class _TipBar extends StatelessWidget {
  const _TipBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Text(
        'molar_mass_tip'.tr,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

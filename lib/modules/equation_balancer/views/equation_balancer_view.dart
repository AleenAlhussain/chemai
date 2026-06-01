import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/equation_balancer_controller.dart';

class EquationBalancerView extends GetView<EquationBalancerController> {
  const EquationBalancerView({super.key});

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

            // ── Loading indicator ──────────────────────────────────────────
            Obx(() {
              if (!controller.isLoading.value) return const SizedBox.shrink();
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(
                    color: AppColors.cyan,
                    strokeWidth: 2.5,
                  ),
                ),
              ).animate().fadeIn(duration: 250.ms);
            }),

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
        'eq_balancer_title'.tr,
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
  final EquationBalancerController controller;
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
            'eq_balancer_input_label'.tr,
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
              onChanged: (v) => controller.inputText.value = v,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
              cursorColor: AppColors.cyan,
              decoration: InputDecoration(
                hintText: 'eq_balancer_hint'.tr,
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
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
              // LOAD EXAMPLE button
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
                  'eq_balancer_load_example'.tr,
                  style: TextStyle(
                    color: AppColors.cyan,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // BALANCE button
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientCyan,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: controller.balance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'eq_balancer_balance'.tr,
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
              OutlinedButton(
                onPressed: controller.clear,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.danger, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Text(
                  'eq_balancer_clear'.tr,
                  style: const TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
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
  final EquationBalancerController controller;
  const _ResultSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // BALANCED EQUATION label
        Text(
          'eq_balancer_result'.tr,
          style: TextStyle(
            color: AppColors.green,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        // Big green result card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.green.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: AppColors.green.withOpacity(0.4), width: 1.5),
          ),
          child: Obx(() => Text(
                controller.balancedEquation.value,
                style: TextStyle(
                  color: AppColors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                ),
                textAlign: TextAlign.center,
              )),
        ),

        const SizedBox(height: 20),

        // STEP-BY-STEP SOLUTION label
        Text(
          'eq_balancer_steps'.tr,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),

        // Steps list
        Obx(() => Column(
              children: controller.steps.asMap().entries.map((entry) {
                final idx = entry.key;
                final step = entry.value;
                return _StepCard(index: idx + 1, step: step)
                    .animate(delay: (idx * 80).ms)
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: -0.05, end: 0);
              }).toList(),
            )),
      ],
    );
  }
}

// ── Step card ─────────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final int index;
  final BalancerStep step;
  const _StepCard({required this.index, required this.step});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.cyan.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cyan.withOpacity(0.4)),
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: TextStyle(
                color: AppColors.cyan,
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              step.text,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontFamily: 'monospace',
                height: 1.4,
              ),
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
        'eq_balancer_tip'.tr,
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

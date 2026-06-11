import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.bgDeep,
        title: Text('account_title'.tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.user.value == null) {
          return Center(child: CircularProgressIndicator(color: AppColors.purple));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UserCard(controller: controller),
              const SizedBox(height: 24),
              _SectionCard(
                title: 'account_edit_profile'.tr,
                icon: Icons.person_outline,
                child: _EditProfileForm(controller: controller),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'account_learning_prefs'.tr,
                icon: Icons.school_outlined,
                child: _LearningPrefsForm(controller: controller),
              ),
              const SizedBox(height: 16),
              _SectionCard(
                title: 'account_change_password'.tr,
                icon: Icons.lock_outline,
                child: _ChangePasswordForm(controller: controller),
              ),
              const SizedBox(height: 16),
              _DeleteAccountButton(controller: controller),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}

// ── User info card ─────────────────────────────────────────────────────────────
class _UserCard extends StatelessWidget {
  final AccountController controller;
  const _UserCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final u = controller.user.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.gradientCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.gradientPurple,
              ),
              child: Center(
                child: Text(
                  u != null && u.fullName.isNotEmpty ? u.fullName[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    u?.fullName ?? '—',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    u?.email ?? '—',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (u?.gender.isNotEmpty == true)
                        _InfoBadge(u!.gender.toUpperCase(), AppColors.purple),
                      const SizedBox(width: 6),
                      Obx(() {
                        final grade = controller.studentProfile.value?.grade;
                        return grade != null
                            ? _InfoBadge('Grade $grade', AppColors.cyan)
                            : const SizedBox.shrink();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── Section card wrapper ───────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.purple, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ── Edit profile form ─────────────────────────────────────────────────────────
class _EditProfileForm extends StatelessWidget {
  final AccountController controller;
  const _EditProfileForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Field(
          label: 'auth_fullname'.tr,
          controller: controller.nameController,
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        Text('auth_gender'.tr,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Row(
              children: [
                _GenderChip(
                  label: 'auth_gender_male'.tr,
                  icon: Icons.male_rounded,
                  selected: controller.selectedGender.value == 'male',
                  onTap: () => controller.selectedGender.value = 'male',
                ),
                const SizedBox(width: 10),
                _GenderChip(
                  label: 'auth_gender_female'.tr,
                  icon: Icons.female_rounded,
                  selected: controller.selectedGender.value == 'female',
                  onTap: () => controller.selectedGender.value = 'female',
                ),
              ],
            )),
        const SizedBox(height: 16),

        // ── Grade ────────────────────────────────────────────────────────────
        Text('account_grade'.tr,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Row(
              children: [9, 10, 11, 12].map((g) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _SelectChip(
                      label: 'Grade $g',
                      selected: controller.selectedGrade.value == g,
                      color: AppColors.amber,
                      onTap: () => controller.selectedGrade.value = g,
                    ),
                  )).toList(),
            )),

        const SizedBox(height: 16),

        // ── Preferred language ────────────────────────────────────────────────
        Text('account_language'.tr,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Row(
              children: [
                _SelectChip(
                  label: 'العربية',
                  selected: controller.selectedLanguage.value == 'ar',
                  color: AppColors.green,
                  onTap: () => controller.selectedLanguage.value = 'ar',
                ),
                const SizedBox(width: 8),
                _SelectChip(
                  label: 'English',
                  selected: controller.selectedLanguage.value == 'en',
                  color: AppColors.green,
                  onTap: () => controller.selectedLanguage.value = 'en',
                ),
              ],
            )),

        const SizedBox(height: 20),
        Obx(() => _ActionButton(
          label: 'account_save'.tr,
          isLoading: controller.isLoading.value,
          onTap: controller.updateProfile,
        )),
      ],
    );
  }
}

// ── Learning preferences form ─────────────────────────────────────────────────
class _LearningPrefsForm extends StatelessWidget {
  final AccountController controller;
  const _LearningPrefsForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Teaching style
        Text('account_teaching_style'.tr,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              children: ['beginner', 'visual', 'text'].map((s) => _SelectChip(
                    label: s,
                    selected: controller.selectedTeachingStyle.value == s,
                    color: AppColors.purple,
                    onTap: () => controller.selectedTeachingStyle.value = s,
                  )).toList(),
            )),

        const SizedBox(height: 16),

        // Learning mode
        Text('account_learning_mode'.tr,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              children: ['text', 'interactive', 'audio'].map((m) => _SelectChip(
                    label: m,
                    selected: controller.selectedLearningMode.value == m,
                    color: AppColors.cyan,
                    onTap: () => controller.selectedLearningMode.value = m,
                  )).toList(),
            )),

        const SizedBox(height: 20),
        Obx(() => _ActionButton(
          label: 'account_save_prefs'.tr,
          isLoading: controller.isLoading.value,
          onTap: controller.updatePreferences,
          color: AppColors.cyan,
        )),
      ],
    );
  }
}

// ── Info badge ─────────────────────────────────────────────────────────────────
class _InfoBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _InfoBadge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

// ── Select chip ────────────────────────────────────────────────────────────────
class _SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _SelectChip({required this.label, required this.selected, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : AppColors.bgCardAlt,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : AppColors.borderDefault,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ── Gender chip ────────────────────────────────────────────────────────────────
class _GenderChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _GenderChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.purple.withOpacity(0.15) : AppColors.bgCardAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.purple.withOpacity(0.6) : AppColors.borderDefault,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: selected ? AppColors.purple : AppColors.textSecondary, size: 18),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                    color: selected ? AppColors.purple : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Delete account button ──────────────────────────────────────────────────────
class _DeleteAccountButton extends StatelessWidget {
  final AccountController controller;
  const _DeleteAccountButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: controller.isLoading.value ? null : controller.deleteAccount,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.danger.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever_outlined, color: AppColors.danger, size: 18),
                const SizedBox(width: 10),
                Text(
                  'account_delete_title'.tr,
                  style: TextStyle(
                    color: AppColors.danger,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// ── Change password form ──────────────────────────────────────────────────────
class _ChangePasswordForm extends StatelessWidget {
  final AccountController controller;
  const _ChangePasswordForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => _Field(
          label: 'account_old_password'.tr,
          controller: controller.oldPasswordController,
          icon: Icons.lock_outline,
          obscure: !controller.isOldPassVisible.value,
          suffix: GestureDetector(
            onTap: controller.toggleOldPassVisibility,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                controller.isOldPassVisible.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        )),
        const SizedBox(height: 12),
        Obx(() => _Field(
          label: 'account_new_password'.tr,
          controller: controller.newPasswordController,
          icon: Icons.lock_reset_outlined,
          obscure: !controller.isNewPassVisible.value,
          suffix: GestureDetector(
            onTap: controller.toggleNewPassVisibility,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                controller.isNewPassVisible.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        )),
        const SizedBox(height: 12),
        _Field(
          label: 'account_confirm_password'.tr,
          controller: controller.confirmPasswordController,
          icon: Icons.check_circle_outline,
          obscure: true,
        ),
        const SizedBox(height: 16),
        Obx(() => _ActionButton(
          label: 'account_change_password'.tr,
          isLoading: controller.isLoading.value,
          onTap: controller.changePassword,
          color: AppColors.cyan,
        )),
      ],
    );
  }
}

// ── Shared field widget ────────────────────────────────────────────────────────
class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;

  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bgCardAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
              suffixIcon: suffix,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Action button ──────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onTap;
  final Color? color;

  const _ActionButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.purple;
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: bg.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: bg.withOpacity(0.6)),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
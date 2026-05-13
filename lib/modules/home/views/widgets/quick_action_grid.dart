import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';

class _Action {
  final IconData icon;
  final String label;
  final String? route;
  const _Action(this.icon, this.label, this.route);
}

const _actions = [
  _Action(Icons.quiz_outlined, 'DAILY QUIZ', AppRoutes.quiz),
  _Action(Icons.science_outlined, 'LAB', AppRoutes.lab),
  _Action(Icons.style_outlined, 'CARDS', AppRoutes.flashcards),
  _Action(Icons.psychology_outlined, 'AI HELP', null),
];

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        _actions.length,
        (i) => _ActionItem(action: _actions[i], index: i),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final _Action action;
  final int index;
  const _ActionItem({required this.action, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => action.route != null ? Get.toNamed(action.route!) : null,
          child: Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Icon(action.icon,
                color: AppColors.textSecondary, size: 22),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          action.label,
          style:  TextStyle(
            color: AppColors.textMuted,
            fontSize: 9,
            letterSpacing: 0.8,
          ),
        ),
      ],
    )
        .animate(delay: Duration(milliseconds: 60 * index))
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, duration: 300.ms);
  }
}

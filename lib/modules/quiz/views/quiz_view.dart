import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/quiz_controller.dart';

class QuizView extends GetView<QuizController> {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: _buildAppBar(context),
      body: Obx(() {
        final q = controller.current;
        return SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress + timer row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'QUESTION ${q.number} OF ${q.total}',
                    style:  TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx(() => Container(
                        padding:  EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderDefault),
                        ),
                        child: Row(
                          children: [
                             Icon(Icons.timer_outlined,
                                color: AppColors.textSecondary, size: 14),
                             SizedBox(width: 5),
                            Text(
                              controller.timerLabel,
                              style: TextStyle(
                                color: controller.secondsRemaining.value < 10
                                    ? AppColors.warning
                                    : AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),

               SizedBox(height: 20),

              // Question
              RichText(
                text: TextSpan(
                  style:  TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  children: _buildQuestionSpans(q.question),
                ),
              ),

               SizedBox(height: 16),

              // Hint card
              Container(
                padding:  EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color:  Color(0xFF0D2035),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.cyan.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.bgCardAlt,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.borderDefault),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        q.hintSymbol,
                        style:  TextStyle(
                          color: AppColors.cyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                     SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            'PERIODIC HINT',
                            style: TextStyle(
                              color: AppColors.cyan,
                              fontSize: 9,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                           SizedBox(height: 3),
                          Text(
                            q.hint,
                            style:  TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

               SizedBox(height: 18),

              // 2x2 answer grid
              Obx(() => GridView.count(
                    shrinkWrap: true,
                    physics:  NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.45,
                    children: q.options.map((opt) {
                      final selected =
                          controller.selectedOption.value == opt.letter;
                      final answered =
                          controller.selectedOption.value != null;
                      final correct =
                          opt.letter == q.correctLetter;

                      Color borderColor;
                      Color bgColor;
                      if (!answered) {
                        borderColor = AppColors.borderDefault;
                        bgColor = AppColors.bgCard;
                      } else if (correct) {
                        borderColor = AppColors.green;
                        bgColor =
                            AppColors.green.withOpacity(0.12);
                      } else if (selected) {
                        borderColor = Colors.red.shade400;
                        bgColor =
                            Colors.red.shade400.withOpacity(0.12);
                      } else {
                        borderColor = AppColors.borderDefault;
                        bgColor = AppColors.bgCard;
                      }

                      return GestureDetector(
                        onTap: () => controller.selectOption(opt.letter),
                        child: AnimatedContainer(
                          duration:  Duration(milliseconds: 300),
                          padding:  EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(14),
                            border:
                                Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selected && !correct
                                          ? Colors.red.shade400
                                              .withOpacity(0.2)
                                          : correct && answered
                                              ? AppColors.green
                                                  .withOpacity(0.2)
                                              : AppColors.bgCardAlt,
                                      border: Border.all(
                                          color: borderColor
                                              .withOpacity(0.5)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      opt.letter,
                                      style: TextStyle(
                                        color: correct && answered
                                            ? AppColors.green
                                            : AppColors.textSecondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                   Spacer(),
                                  if (correct && answered)
                                     Icon(Icons.check_circle,
                                        color: AppColors.green, size: 18),
                                ],
                              ),
                               SizedBox(height: 8),
                              Text(
                                opt.name,
                                style:  TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                               SizedBox(height: 2),
                              Text(
                                opt.detail,
                                style:  TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )),

               SizedBox(height: 18),

              // Molecular visualization
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color:  Color(0xFF080C1A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Faint molecular lines
                    CustomPaint(
                      size: Size.infinite,
                      painter: _MolecularPainter(),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 14,
                      child: Text(
                        q.configLabel,
                        style:  TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

               SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  List<TextSpan> _buildQuestionSpans(String q) {
    // Bold the keyword "atomic number" if present
    const keyword = 'atomic number';
    final idx = q.toLowerCase().indexOf(keyword);
    if (idx == -1) return [TextSpan(text: q)];
    return [
      TextSpan(text: q.substring(0, idx)),
      TextSpan(
        text: q.substring(idx, idx + keyword.length),
        style:  TextStyle(
          fontWeight: FontWeight.w800,
          decoration: TextDecoration.underline,
        ),
      ),
      TextSpan(text: q.substring(idx + keyword.length)),
    ];
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bgBase,
      titleSpacing: 16,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      title: Row(
        children: [
           Icon(Icons.science_outlined,
              color: AppColors.purple, size: 18),
           SizedBox(width: 6),
           Text(
            'QUANTUM CHEMISTRY',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
           SizedBox(width: 16),
          GestureDetector(
            onTap: () {},
            child:  Text('Lab',
                style: TextStyle(
                    color: AppColors.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
           SizedBox(width: 12),
          GestureDetector(
            onTap: () {},
            child:  Text('Lessons',
                style: TextStyle(
                    color: AppColors.purple,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon:  Icon(Icons.settings_outlined,
              color: AppColors.textSecondary, size: 20),
          onPressed: () {},
        ),
        Padding(
          padding:  EdgeInsets.only(right: 12),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgCard,
              border: Border.all(color: AppColors.borderDefault),
            ),
            child:  Icon(Icons.person_outline,
                color: AppColors.textSecondary, size: 16),
          ),
        ),
      ],
    );
  }
}

class _MolecularPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.purple.withOpacity(0.25)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final nodes = [
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.45, size.height * 0.55),
      Offset(size.width * 0.60, size.height * 0.30),
      Offset(size.width * 0.75, size.height * 0.60),
      Offset(size.width * 0.35, size.height * 0.70),
    ];
    final edges = [
      [0, 1], [1, 2], [2, 3], [1, 4], [0, 2]
    ];

    for (final e in edges) {
      canvas.drawLine(nodes[e[0]], nodes[e[1]], paint);
    }
    for (final n in nodes) {
      canvas.drawCircle(n, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/onboarding_controller.dart';
import 'widgets/atom_illustration.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          // Background radial glow (purple/blue from top)
          Positioned(
            top: -80,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.65,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.4),
                  radius: 0.8,
                  colors: [
                     Color(0xFF2A1F6A).withOpacity(0.7),
                    AppColors.bgDeep.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          Column(
            children: [
              // ── Illustration area (top 60%) ─────────────────────────────
              SizedBox(
                height: size.height * 0.60,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (i) => controller.pageIndex.value = i,
                  itemCount: controller.pages.length,
                  itemBuilder: (_, i) => Center(
                    child: _buildIllustration(i, size),
                  ),
                ),
              ),

              // ── Bottom sheet ────────────────────────────────────────────
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration:  BoxDecoration(
                    color: Color(0xFF11152E),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  padding:  EdgeInsets.symmetric(
                      horizontal: 28, vertical: 32),
                  child: Column(
                    children: [
                      // Title
                      Obx(() => AnimatedSwitcher(
                            duration:  Duration(milliseconds: 300),
                            child: Text(
                              controller.pages[controller.pageIndex.value].title,
                              key: ValueKey(controller.pageIndex.value),
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                          )),

                       SizedBox(height: 12),

                      // Subtitle
                      Obx(() => AnimatedSwitcher(
                            duration:  Duration(milliseconds: 300),
                            child: Text(
                              controller.pages[controller.pageIndex.value]
                                  .subtitle,
                              key: ValueKey(
                                  '${controller.pageIndex.value}_sub'),
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                          )),

                       SizedBox(height: 24),

                      // Page indicator
                      Obx(() => SmoothPageIndicator(
                            controller: controller.pageController,
                            count: controller.pages.length,
                            effect:  ExpandingDotsEffect(
                              dotHeight: 6,
                              dotWidth: 6,
                              expansionFactor: 4,
                              activeDotColor: AppColors.purple,
                              dotColor: AppColors.borderDefault,
                              spacing: 6,
                            ),
                          )),

                       SizedBox(height: 28),

                      // NEXT button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            foregroundColor: Colors.white,
                            padding:
                                 EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Obx(() => Text(
                                controller.pageIndex.value ==
                                        controller.pages.length - 1
                                    ? 'GET STARTED'
                                    : 'NEXT',
                                style:  TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              )),
                        ),
                      ),

                       SizedBox(height: 16),

                      // Skip
                      GestureDetector(
                        onTap: controller.skip,
                        child:  Text(
                          'SKIP ONBOARDING',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration(int index, Size size) {
    // All pages show the atom for now — swap per index for production assets
    return AtomIllustration(size: size.width * 0.70);
  }
}

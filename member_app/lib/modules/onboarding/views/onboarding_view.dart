import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_colors_context.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../routes/app_routes.dart';

class _OnboardingSlide {
  final IconData icon;
  final String titleKey;
  final String descKey;
  final Gradient gradient;

  const _OnboardingSlide({
    required this.icon,
    required this.titleKey,
    required this.descKey,
    required this.gradient,
  });
}

const _slides = [
  _OnboardingSlide(
    icon: Icons.fitness_center_rounded,
    titleKey: 'onboarding_title_1',
    descKey: 'onboarding_desc_1',
    gradient: AppColors.primaryGradient,
  ),
  _OnboardingSlide(
    icon: Icons.calendar_month_rounded,
    titleKey: 'onboarding_title_2',
    descKey: 'onboarding_desc_2',
    gradient: AppColors.accentGradient,
  ),
  _OnboardingSlide(
    icon: Icons.restaurant_menu_rounded,
    titleKey: 'onboarding_title_3',
    descKey: 'onboarding_desc_3',
    gradient: AppColors.greenGradient,
  ),
  _OnboardingSlide(
    icon: Icons.qr_code_2_rounded,
    titleKey: 'onboarding_title_4',
    descKey: 'onboarding_desc_4',
    gradient: AppColors.primaryGradient,
  ),
];

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();
  int _index = 0;

  bool get _isLast => _index == _slides.length - 1;

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _finish() {
    // شاشات التعريف بتظهر مرة وحدة بس لكل حساب جديد — بعدها منروح
    // مباشرة لواجهات المستخدم الرئيسية وما في رجوع لهاي الشاشة.
    Get.offAllNamed(AppRoutes.main);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextButton(
                  onPressed: _isLast ? null : _finish,
                  child: Opacity(
                    opacity: _isLast ? 0 : 1,
                    child: Text('onboarding_skip'.tr,
                        style: TextStyle(color: context.textSecondary, fontSize: 14)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _SlideContent(slide: _slides[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final active = i == _index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : context.borderColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: _isLast ? 'onboarding_start'.tr : 'onboarding_next'.tr,
                    onPressed: _next,
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

class _SlideContent extends StatelessWidget {
  final _OnboardingSlide slide;
  const _SlideContent({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeSlideIn(
            child: Container(
              width: 148,
              height: 148,
              decoration: BoxDecoration(
                gradient: slide.gradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.28),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(slide.icon, size: 64, color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: Text(
              slide.titleKey.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 14),
          FadeSlideIn(
            delay: const Duration(milliseconds: 140),
            child: Text(
              slide.descKey.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

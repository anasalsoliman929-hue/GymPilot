import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _barCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<double> _textSlide;
  late Animation<double> _barWidth;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _barCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _logoScale = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoFade  = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.4)));
    _textFade  = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _textSlide = Tween(begin: 20.0, end: 0.0).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _barWidth  = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _barCtrl, curve: Curves.easeInOut));

    _logoCtrl.forward().then((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) _textCtrl.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) _barCtrl.repeat(reverse: true);
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      Get.delete<SplashController>(force: true);
      if (mounted) Get.put(SplashController());
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoCtrl,
              builder: (_, child) => Opacity(
                opacity: _logoFade.value,
                child: Transform.scale(scale: _logoScale.value, child: child),
              ),
              child: Container(
                width: 110, height: 110,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 30, spreadRadius: 4,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.sports_gymnastics, color: Colors.white, size: 56),
              ),
            ),
            const SizedBox(height: 28),
            AnimatedBuilder(
              animation: _textCtrl,
              builder: (_, child) => Opacity(
                opacity: _textFade.value,
                child: Transform.translate(offset: Offset(0, _textSlide.value), child: child),
              ),
              child: Column(
                children: [
                  Text('GymPilot Trainer',
                      style: TextStyle(
                          color: Colors.white, fontSize: 30,
                          fontWeight: FontWeight.w800, letterSpacing: 1)),
                  SizedBox(height: 6),
                  Text('trainer_dashboard_tagline'.tr,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 56),
            AnimatedBuilder(
              animation: _barCtrl,
              builder: (_, __) => Container(
                width: 120, height: 3,
                decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(2)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: _barWidth.value,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(color: AppColors.primary.withOpacity(0.6), blurRadius: 6)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../core/theme/app_colors_context.dart';

class QrCodeView extends StatefulWidget {
  const QrCodeView({super.key});
  @override
  State<QrCodeView> createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> with TickerProviderStateMixin {
  static const _channel = MethodChannel('gymflow/secure_screen');

  late AnimationController _qrCtrl;
  late AnimationController _pulseCtrl;
  late Animation<double> _qrScale;
  late Animation<double> _qrFade;
  late Animation<double> _pulseAnim;

  int _secondsLeft = 60;
  Timer? _timer;

  String? _qrToken;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _setSecure(true);

    _qrCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);

    _qrScale  = Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _qrCtrl, curve: Curves.easeOutBack));
    _qrFade   = CurvedAnimation(parent: _qrCtrl, curve: Curves.easeOut);
    _pulseAnim = Tween(begin: 1.0, end: 1.04).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _loadQrToken();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) { _secondsLeft = 60; _loadQrToken(); }
      });
    });
  }

  Future<void> _loadQrToken() async {
    try {
      final token = await Get.find<MemberRepository>().getQrToken();
      if (mounted) {
        setState(() { _qrToken = token; _isLoading = false; _error = null; });
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _qrCtrl.forward(from: 0);
        });
      }
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _error = 'failed_load_qr2'.tr; });
    }
  }

  Future<void> _setSecure(bool secure) async {
    try { await _channel.invokeMethod('setSecure', {'secure': secure}); } catch (_) {}
  }

  @override
  void dispose() {
    _setSecure(false);
    _qrCtrl.dispose();
    _pulseCtrl.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Color get _timerColor {
    if (_secondsLeft > 30) return AppColors.success;
    if (_secondsLeft > 10) return const Color(0xFFFF9800);
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('my_qr_code'.tr)),
      body: _isLoading
          ? const _QrLoadingSkeleton()
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.danger, size: 48),
                      const SizedBox(height: 12),
                      Text(_error!, style: TextStyle(color: context.textSecondary)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () { setState(() { _isLoading = true; }); _loadQrToken(); },
                        child: Text('retry'.tr),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // QR Code
                      AnimatedBuilder(
                        animation: _qrCtrl,
                        builder: (_, child) => Opacity(
                          opacity: _qrFade.value,
                          child: Transform.scale(scale: _qrScale.value, child: child),
                        ),
                        child: AnimatedBuilder(
                          animation: _pulseCtrl,
                          builder: (_, child) => Transform.scale(scale: _pulseAnim.value, child: child),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: context.textPrimary,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.25),
                                  blurRadius: 32, spreadRadius: 4, offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: _qrToken!,
                              version: QrVersions.auto,
                              size: 200,
                              backgroundColor: context.textPrimary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Timer
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 300),
                              style: TextStyle(color: _timerColor, fontSize: 13, fontWeight: FontWeight.w500),
                              child: Text('refreshes_in_seconds'.trParams({'s': '$_secondsLeft'})),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: _secondsLeft / 60,
                                backgroundColor: context.borderColor,
                                color: _timerColor,
                                minHeight: 4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      FadeSlideIn(
                        delay: const Duration(milliseconds: 380),
                        child: Text(
                          'qr_gate_instructions'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.textSecondary, fontSize: 13, height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

// ─── هيكل تحميل شيمر لشاشة QR ─────────────────────────────────
class _QrLoadingSkeleton extends StatelessWidget {
  const _QrLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ShimmerBox(width: 240, height: 240, radius: 20),
          const SizedBox(height: 24),
          const ShimmerBox(width: 160, height: 16, radius: 6),
          const SizedBox(height: 10),
          const ShimmerBox(width: 100, height: 12, radius: 6),
        ],
      ),
    );
  }
}

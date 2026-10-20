import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/wallet_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});
  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView>
    with SingleTickerProviderStateMixin {
  final _phoneCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _transactionCtrl = TextEditingController(); // ← أضف هذا
  late AnimationController _balanceCtrl;
  late Animation<double> _balanceFade;
  late Animation<double> _balanceScale;
  late final WalletController _c;

// في الـ State
  String? _receiptPath;
  final _picker = ImagePicker();
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    _c = Get.put(WalletController());
    _balanceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _balanceFade = CurvedAnimation(parent: _balanceCtrl, curve: Curves.easeOut);
    _balanceScale = Tween(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _balanceCtrl, curve: Curves.easeOutBack));
    _balanceCtrl.forward();
  }

  @override
  void dispose() {
    _balanceCtrl.dispose();
    _phoneCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  void _sendRequest() {
    if (_amountCtrl.text.isEmpty || _transactionCtrl.text.isEmpty) {
      Get.showSnackbar(GetSnackBar(
        message: 'fill_amount_transaction'.tr,
        backgroundColor: AppColors.danger,
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    _c.sendTopupRequest(
      amount: _amountCtrl.text.replaceAll(',', ''),
      transactionNumber: _transactionCtrl.text.trim(),
      receiptPath: _receiptPath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        title: Text('wallet'.tr),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _c.load,
          ),
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: Image.asset(
                    'assets/qr_code.png',
                    width: 250,
                    height: 250,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_c.isLoading.value) {
          return const AppLoading();
        }
        if (_c.error != null) {
          return AppErrorView(message: _c.error!, onRetry: _c.load);
        }
        return RefreshIndicator(
          onRefresh: _c.load,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Balance card ──────────────────────────
              AnimatedBuilder(
                animation: _balanceCtrl,
                builder: (_, child) => Opacity(
                  opacity: _balanceFade.value,
                  child:
                      Transform.scale(scale: _balanceScale.value, child: child),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: context.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('available_balance'.tr,
                          style: TextStyle(
                              color: context.textSecondary, fontSize: 12)),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Obx(() => AnimatedCounter(
                                end: _c.balance.value.toInt(),
                                style: TextStyle(
                                    color: context.textPrimary,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800),
                                duration: const Duration(milliseconds: 1400),
                              )),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text('currency_syp'.tr,
                                style: TextStyle(
                                    color: context.textSecondary,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ─── Payments history ──────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: SectionLabel('recent_transactions'.tr),
              ),

              Obx(() {
                if (_c.payments.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text('no_transactions_yet'.tr,
                          style: TextStyle(color: context.textSecondary)),
                    ),
                  );
                }
                return Column(
                  children: _c.payments.asMap().entries.map((e) {
                    final p = e.value as Map;
                    final amount =
                        double.tryParse(p['amount']?.toString() ?? '0') ?? 0.0;
                    final isCredit = p['type'] == 'credit' || amount > 0;
                    final label = p['description']?.toString() ??
                        p['label']?.toString() ??
                        '—';
                    final date =
                        p['created_at']?.toString().split('T').first ?? '';
                    return FadeSlideIn(
                      delay: Duration(milliseconds: 60 * e.key),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isCredit
                                    ? const Color(0xFF1a3a1a)
                                    : const Color(0xFF3a1a1a),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isCredit
                                    ? Icons.add_card_outlined
                                    : Icons.remove_circle_outline,
                                color: isCredit
                                    ? AppColors.success
                                    : AppColors.danger,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(label,
                                      style: TextStyle(
                                          color: context.textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  if (date.isNotEmpty)
                                    Text(date,
                                        style: TextStyle(
                                            color: context.textSecondary,
                                            fontSize: 11)),
                                ],
                              ),
                            ),
                            Text(
                              '${isCredit ? '+' : ''}${amount.toStringAsFixed(0)} ${'currency_syp'.tr}',
                              style: TextStyle(
                                color: isCredit
                                    ? AppColors.success
                                    : AppColors.danger,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 20),
              const SizedBox(height: 24),

              // ─── Topup requests history ─────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 240),
                child: SectionLabel('my_topup_requests'.tr),
              ),
              Obx(() {
                if (_c.topups.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text('no_topup_requests_yet'.tr,
                          style: TextStyle(color: context.textSecondary)),
                    ),
                  );
                }
                return Column(
                  children: _c.topups.asMap().entries.map((e) {
                    final t = e.value as Map;
                    final amount =
                        double.tryParse(t['amount']?.toString() ?? '0') ?? 0.0;
                    final status = t['status']?.toString() ?? 'pending';
                    final txNumber = t['transaction_number']?.toString() ?? '';
                    final rejectionReason = t['rejection_reason']?.toString();
                    final date =
                        t['created_at']?.toString().split('T').first ?? '';

                    Color statusColor;
                    String statusText;
                    switch (status) {
                      case 'approved':
                        statusColor = AppColors.success;
                        statusText = 'status_approved'.tr;
                        break;
                      case 'rejected':
                        statusColor = AppColors.danger;
                        statusText = 'status_rejected'.tr;
                        break;
                      default:
                        statusColor = AppColors.primary;
                        statusText = 'status_pending'.tr;
                    }

                    return FadeSlideIn(
                      delay: Duration(milliseconds: 60 * e.key),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      '${amount.toStringAsFixed(0)} ${'currency_syp'.tr}',
                                      style: TextStyle(
                                          color: context.textPrimary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(statusText,
                                      style: TextStyle(
                                          color: statusColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('#$txNumber · $date',
                                style: TextStyle(
                                    color: context.textSecondary,
                                    fontSize: 11)),
                            if (status == 'rejected' &&
                                rejectionReason != null &&
                                rejectionReason.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(rejectionReason,
                                  style: TextStyle(
                                      color: AppColors.danger, fontSize: 12)),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
              // ─── Top-up form ───────────────────────────
              FadeSlideIn(
                delay: const Duration(milliseconds: 400),
                child: SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.add_card_outlined,
                              color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('topup_via_shamcash'.tr,
                              style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () async {
                          if (_isPicking) return;

                          _isPicking = true;

                          try {
                            final img = await _picker.pickImage(
                              source: ImageSource.gallery,
                            );

                            if (img != null && mounted) {
                              setState(() => _receiptPath = img.path);
                            }
                          } finally {
                            _isPicking = false;
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _receiptPath != null
                                  ? AppColors.success
                                  : context.borderColor,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _receiptPath != null
                                    ? Icons.check_circle
                                    : Icons.upload_file,
                                color: _receiptPath != null
                                    ? AppColors.success
                                    : context.textSecondary,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _receiptPath != null
                                    ? 'receipt_selected'.tr
                                    : 'receipt_image'.tr,
                                style: TextStyle(
                                  color: _receiptPath != null
                                      ? AppColors.success
                                      : context.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'shamcash_wallet_number'.tr,
                        hint: '+963 9XX XXX XXX',
                        prefixIcon: Icons.phone_outlined,
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'amount_syp'.tr,
                        hint: '50000',
                        prefixIcon: Icons.attach_money,
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _sendRequest(),
                      ),
                      const SizedBox(height: 18),
                      AppTextField(
                        label: 'transaction_number'.tr,
                        hint: 'SH-2026-001',
                        prefixIcon: Icons.numbers,
                        controller: _transactionCtrl,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 18),
                      Obx(() => PrimaryButton(
                            label: 'send_topup_request'.tr,
                            icon: Icons.send_outlined,
                            isLoading: _c.isSending.value,
                            onPressed: _sendRequest,
                          )),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}

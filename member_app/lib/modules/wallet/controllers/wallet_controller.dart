import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/member_repository.dart';

class WalletController extends GetxController {
  final MemberRepository _repo = Get.find<MemberRepository>();

  RxBool isLoading    = true.obs;
  RxBool isSending    = false.obs;
  RxDouble balance    = 0.0.obs;
  RxInt pendingTopups = 0.obs;          // ← جديد
  RxList payments     = [].obs;
  RxList topups       = [].obs;          // ← جديد
  String? error;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error = null;
    try {
      final wallet    = await _repo.getWallet();
      final payList   = await _repo.getPayments();
      final topupList = await _repo.getTopupHistory();   // ← جديد

      balance.value = double.tryParse(wallet['balance'].toString()) ?? 0.0;
      pendingTopups.value = int.tryParse(wallet['pending_topups']?.toString() ?? '0') ?? 0; // ← جديد
      payments.assignAll(payList);

      final sortedTopups = List.from(topupList)
        ..sort((a, b) => (b['created_at'] ?? '').toString()
            .compareTo((a['created_at'] ?? '').toString()));
      topups.assignAll(sortedTopups);   // ← جديد
    } on ApiException catch (e) {
      error = e.firstError;
    } catch (_) {
      error = 'failed_load_wallet'.tr;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendTopupRequest({
    required String amount,
    required String transactionNumber,
    String? receiptPath,
  }) async {
    isSending.value = true;
    try {
      await _repo.requestTopup(
        amount:            amount,
        transactionNumber: transactionNumber,
        receiptPath:       receiptPath,
      );
      AppSnackbar.success('topup_request_sent'.tr);
      await load();
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('failed_send_request'.tr);
    } finally {
      isSending.value = false;
    }
  }
}
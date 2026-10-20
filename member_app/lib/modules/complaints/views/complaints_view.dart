import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_colors_context.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/models/complaint_model.dart';
import '../controllers/complaints_controller.dart';
import 'complaint_detail_view.dart';

class ComplaintsView extends StatelessWidget {
  const ComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ComplaintsController());

    return Scaffold(
      appBar: AppBar(title: Text('complaints_title'.tr)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => _openCreateSheet(context, c),
        icon: const Icon(Icons.add),
        label: Text('new_complaint'.tr),
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: List.generate(
              4,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ShimmerBox(height: 90, radius: 14),
              ),
            ),
          );
        }

        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }

        if (c.complaints.isEmpty) {
          return AppEmptyState(
            icon: Icons.report_gmailerrorred_outlined,
            message: 'no_complaints_yet'.tr,
          );
        }

        return RefreshIndicator(
          onRefresh: c.load,
          color: AppColors.primary,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: c.complaints.length,
            itemBuilder: (_, i) {
              final complaint = c.complaints[i];
              return FadeSlideIn(
                delay: Duration(milliseconds: 40 * i),
                child: _ComplaintTile(complaint: complaint),
              );
            },
          ),
        );
      }),
    );
  }

  void _openCreateSheet(BuildContext context, ComplaintsController c) {
    final subjectCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('new_complaint'.tr,
                    style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'complaint_subject_label'.tr,
                  hint: 'complaint_subject_hint'.tr,
                  controller: subjectCtrl,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'field_required'.tr : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'complaint_message_label'.tr,
                  hint: 'complaint_message_hint'.tr,
                  controller: messageCtrl,
                  maxLines: 4,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'field_required'.tr : null,
                ),
                const SizedBox(height: 20),
                Obx(() => PrimaryButton(
                      label: 'submit_complaint'.tr,
                      isLoading: c.isSending.value,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        final ok = await c.submit(
                          subject: subjectCtrl.text.trim(),
                          message: messageCtrl.text.trim(),
                        );
                        if (ok && sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                        }
                      },
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ComplaintTile extends StatelessWidget {
  final ComplaintModel complaint;
  const _ComplaintTile({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SurfaceCard(
        onTap: () => Get.to(() => ComplaintDetailView(complaint: complaint)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _statusColor(complaint.status).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.report_outlined, color: _statusColor(complaint.status), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(complaint.subject,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: context.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(complaint.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.textSecondary, fontSize: 12, height: 1.4)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _statusColor(complaint.status).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusLabel(complaint.status),
                      style: TextStyle(
                          color: _statusColor(complaint.status),
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: context.textSecondary),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'resolved':
        return AppColors.success;
      case 'reviewed':
      case 'in_progress':
        return const Color(0xFF74B9FF);
      default:
        return AppColors.primary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'resolved':
        return 'status_resolved'.tr;
      case 'reviewed':
        return 'status_reviewed'.tr;
      case 'in_progress':
        return 'status_in_progress'.tr;
      default:
        return 'status_pending'.tr;
    }
  }
}

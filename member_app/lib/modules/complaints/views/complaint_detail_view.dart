import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_colors_context.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/models/complaint_model.dart';

class ComplaintDetailView extends StatelessWidget {
  final ComplaintModel complaint;
  const ComplaintDetailView({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('complaint_details_title'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(complaint.subject,
                          style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor(complaint.status).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(_statusLabel(complaint.status),
                          style: TextStyle(
                              color: _statusColor(complaint.status),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(complaint.message,
                    style: TextStyle(color: context.textSecondary, fontSize: 14, height: 1.6)),
                if (complaint.createdAt != null) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: context.textSecondary),
                      const SizedBox(width: 4),
                      Text(_formatDate(complaint.createdAt!),
                          style: TextStyle(color: context.textSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ],
            ),
          ),

          if (complaint.adminResponse != null && complaint.adminResponse!.isNotEmpty) ...[
            const SizedBox(height: 16),
            SectionLabel('admin_response_title'.tr),
            SurfaceCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.support_agent, color: AppColors.primary, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(complaint.adminResponse!,
                        style: TextStyle(color: context.textPrimary, fontSize: 14, height: 1.6)),
                  ),
                ],
              ),
            ),
          ],
        ],
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

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year}';
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors_context.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../controllers/legal_document_controller.dart';

class LegalDocumentView extends StatelessWidget {
  /// المفتاح: 'privacy_policy' أو 'terms_of_use'
  final String documentKey;
  final String fallbackTitle;

  const LegalDocumentView({
    super.key,
    required this.documentKey,
    required this.fallbackTitle,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(
      LegalDocumentController(documentKey),
      tag: documentKey, // يسمح بوجود شاشتين (خصوصية/شروط) بنفس الوقت بالـ stack
    );

    return Scaffold(
      appBar: AppBar(title: Text(fallbackTitle)),
      body: Obx(() {
        if (c.isLoading.value) {
          return const AppLoading(itemCount: 6);
        }
        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }

        final doc = c.document.value;
        if (doc == null) {
          return AppEmptyState(
            icon: Icons.description_outlined,
            message: 'failed_load_document'.tr,
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            FadeSlideIn(
              child: Text(
                doc.title,
                style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 6),
            Text('v${doc.version}',
                style: TextStyle(color: context.textSecondary, fontSize: 12)),
            const SizedBox(height: 20),
            FadeSlideIn(
              delay: const Duration(milliseconds: 80),
              child: Text(
                doc.content,
                style: TextStyle(
                    color: context.textPrimary, fontSize: 14, height: 1.8),
              ),
            ),
            const SizedBox(height: 32),
          ],
        );
      }),
    );
  }
}

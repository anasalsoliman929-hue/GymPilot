import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChangePasswordController());

    return Scaffold(
      appBar: AppBar(title: Text('change_password_title'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: c.formKey,
          child: Column(
            children: [
              FadeSlideIn(
                child: Obx(() => TextFormField(
                  controller: c.currentPasswordController,
                  obscureText: c.hideCurrent.value,
                  decoration: InputDecoration(
                    labelText: 'current_password_label'.tr,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(c.hideCurrent.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () => c.hideCurrent.value = !c.hideCurrent.value,
                    ),
                  ),
                  validator: c.validateCurrent,
                )),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: Obx(() => TextFormField(
                  controller: c.newPasswordController,
                  obscureText: c.hideNew.value,
                  decoration: InputDecoration(
                    labelText: 'new_password_label'.tr,
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(c.hideNew.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () => c.hideNew.value = !c.hideNew.value,
                    ),
                  ),
                  validator: c.validateNew,
                )),
              ),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: Obx(() => TextFormField(
                  controller: c.confirmPasswordController,
                  obscureText: c.hideConfirm.value,
                  decoration: InputDecoration(
                    labelText: 'confirm_new_password_label'.tr,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(c.hideConfirm.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () => c.hideConfirm.value = !c.hideConfirm.value,
                    ),
                  ),
                  validator: c.validateConfirm,
                )),
              ),
              const SizedBox(height: 28),
              FadeSlideIn(
                delay: const Duration(milliseconds: 240),
                child: Obx(() => ElevatedButton(
                  onPressed: c.isLoading.value ? null : c.submit,
                  child: c.isLoading.value
                      ? const SizedBox(height: 22, width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                      : Text('change_password_title'.tr),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

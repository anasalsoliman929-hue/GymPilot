import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<EditProfileController>(force: true);
    final c = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(title: Text('edit_my_profile'.tr)),
      body: Form(
        key: c.formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            FadeSlideIn(
              child: AppTextField(
                label: 'name'.tr,
                prefixIcon: Icons.person_outline,
                controller: c.nameController,
                validator: c.validateName,
              ),
            ),
            const SizedBox(height: 16),
            FadeSlideIn(
              delay: const Duration(milliseconds: 80),
              child: AppTextField(
                label: 'phone_number'.tr,
                prefixIcon: Icons.phone_outlined,
                controller: c.phoneController,
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(height: 28),
            FadeSlideIn(
              delay: const Duration(milliseconds: 140),
              child: Obx(() => PrimaryButton(
                    label: 'save_changes'.tr,
                    icon: Icons.check,
                    isLoading: c.isLoading.value,
                    onPressed: c.submit,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

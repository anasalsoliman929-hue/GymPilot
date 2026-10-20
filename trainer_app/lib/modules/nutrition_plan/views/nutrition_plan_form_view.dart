import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/nutrition_plan_form_controller.dart';

class NutritionPlanFormView extends StatelessWidget {
  const NutritionPlanFormView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<NutritionPlanFormController>(force: true);
    final c = Get.put(NutritionPlanFormController());

    return Scaffold(
      appBar: AppBar(title: Text('new_nutrition_plan'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FadeSlideIn(
            child: AppTextField(
              label: 'plan_title'.tr,
              hint: 'plan_title_hint'.tr,
              prefixIcon: Icons.title,
              controller: c.titleController,
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: AppTextField(
              label: 'target_calories_daily'.tr,
              hint: '2500',
              prefixIcon: Icons.local_fire_department_outlined,
              controller: c.targetCaloriesController,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 32),
          FadeSlideIn(
            delay: const Duration(milliseconds: 160),
            child: Obx(() => PrimaryButton(
                  label: 'create_plan'.tr,
                  icon: Icons.check,
                  isLoading: c.isLoading.value,
                  onPressed: c.submit,
                )),
          ),
        ],
      ),
    );
  }
}

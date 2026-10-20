import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/training_plan_form_controller.dart';

class TrainingPlanFormView extends StatelessWidget {
  const TrainingPlanFormView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<TrainingPlanFormController>(force: true);
    final c = Get.put(TrainingPlanFormController());

    return Scaffold(
      appBar: AppBar(title: Text('new_training_plan'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FadeSlideIn(
            child: AppTextField(
              label: 'plan_title'.tr,
              hint: 'training_plan_title_hint'.tr,
              prefixIcon: Icons.title,
              controller: c.titleController,
            ),
          ),
          const SizedBox(height: 20),
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: SectionLabel('training_days'.tr),
          ),
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: kWeekDays.entries.map((e) {
                    final selected = c.selectedDays.contains(e.key);
                    return GestureDetector(
                      onTap: () => c.toggleDay(e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: selected ? AppColors.primary : Theme.of(context).dividerColor),
                        ),
                        child: Text(
                          e.value,
                          style: TextStyle(
                            color: selected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
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

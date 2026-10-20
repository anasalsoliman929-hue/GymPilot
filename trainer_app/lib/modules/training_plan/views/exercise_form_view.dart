import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/exercise_form_controller.dart';

class ExerciseFormView extends StatelessWidget {
  const ExerciseFormView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<ExerciseFormController>(force: true);
    final c = Get.put(ExerciseFormController());

    return Scaffold(
      appBar: AppBar(title: Text(c.isEditing ? 'edit_exercise'.tr : 'add_exercise'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FadeSlideIn(
            child: AppTextField(
              label: 'exercise_name'.tr,
              hint: 'exercise_name_hint'.tr,
              prefixIcon: Icons.fitness_center,
              controller: c.nameController,
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 60),
            child: SectionLabel('day'.tr),
          ),
          FadeSlideIn(
            delay: const Duration(milliseconds: 80),
            child: Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: kWeekDays.entries.map((e) {
                    final selected = c.selectedDay.value == e.key;
                    return GestureDetector(
                      onTap: () => c.selectedDay.value = e.key,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: selected ? AppColors.primary : Theme.of(context).dividerColor),
                        ),
                        child: Text(e.value,
                            style: TextStyle(
                                color: selected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 13)),
                      ),
                    );
                  }).toList(),
                )),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 120),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'sets'.tr,
                    controller: c.setsController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    label: 'reps'.tr,
                    controller: c.repsController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 160),
            child: AppTextField(
              label: 'rest_seconds_label'.tr,
              controller: c.restController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.timer_outlined,
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: AppTextField(
              label: 'equipment_id_optional'.tr,
              hint: 'equipment_id_hint'.tr,
              controller: c.equipmentIdController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.settings_outlined,
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 240),
            child: AppTextField(
              label: 'notes_optional'.tr,
              controller: c.notesController,
              maxLines: 3,
              prefixIcon: Icons.notes,
            ),
          ),
          const SizedBox(height: 28),
          FadeSlideIn(
            delay: const Duration(milliseconds: 280),
            child: Obx(() => PrimaryButton(
                  label: c.isEditing ? 'save_changes'.tr : 'add_exercise'.tr,
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

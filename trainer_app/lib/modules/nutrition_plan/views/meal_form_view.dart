import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_animations.dart';
import '../controllers/meal_form_controller.dart';

class MealFormView extends StatelessWidget {
  const MealFormView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.delete<MealFormController>(force: true);
    final c = Get.put(MealFormController());

    return Scaffold(
      appBar: AppBar(title: Text(c.isEditing ? 'edit_meal'.tr : 'add_meal'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          FadeSlideIn(
            child: AppTextField(
              label: 'meal_name'.tr,
              hint: 'meal_name_hint'.tr,
              prefixIcon: Icons.restaurant_menu,
              controller: c.nameController,
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 60),
            child: AppTextField(
              label: 'meal_time'.tr,
              hint: 'tap_to_pick_time'.tr,
              prefixIcon: Icons.access_time,
              controller: c.timeController,
              suffix: IconButton(
                icon: const Icon(Icons.schedule),
                onPressed: () => c.pickTime(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: AppTextField(
              label: 'calories'.tr,
              controller: c.caloriesController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.local_fire_department_outlined,
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 140),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'protein_g'.tr,
                    controller: c.proteinController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    label: 'carbs_g'.tr,
                    controller: c.carbsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    label: 'fat_g'.tr,
                    controller: c.fatController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 180),
            child: AppTextField(
              label: 'notes_optional'.tr,
              controller: c.notesController,
              maxLines: 3,
              prefixIcon: Icons.notes,
            ),
          ),
          const SizedBox(height: 28),
          FadeSlideIn(
            delay: const Duration(milliseconds: 220),
            child: Obx(() => PrimaryButton(
                  label: c.isEditing ? 'save_changes'.tr : 'add_meal'.tr,
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/nutrition_plan_model.dart';
import '../../../data/repositories/nutrition_repository.dart';

class MealFormController extends GetxController {
  final NutritionRepository _repo = Get.find<NutritionRepository>();

  late final int planId;
  MealModel? editingMeal;
  bool get isEditing => editingMeal != null;

  final nameController = TextEditingController();
  final timeController = TextEditingController(); // HH:mm
  final caloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatController = TextEditingController();
  final notesController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    planId = args['planId'] as int;
    editingMeal = args['meal'] as MealModel?;

    if (editingMeal != null) {
      final m = editingMeal!;
      nameController.text = m.name;
      timeController.text =
          m.mealTime.length >= 5 ? m.mealTime.substring(0, 5) : m.mealTime;
      caloriesController.text = m.calories.toString();
      proteinController.text = m.proteinGrams.toString();
      carbsController.text = m.carbsGrams.toString();
      fatController.text = m.fatGrams.toString();
      notesController.text = m.notes ?? '';
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: now);
    if (picked != null) {
      timeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> submit() async {
    if (nameController.text.trim().isEmpty) {
      AppSnackbar.error('أدخل اسم الوجبة');
      return;
    }
    if (timeController.text.trim().isEmpty) {
      AppSnackbar.error('اختر وقت الوجبة');
      return;
    }
    final calories = int.tryParse(caloriesController.text.trim());
    final protein = double.tryParse(proteinController.text.trim());
    final carbs = double.tryParse(carbsController.text.trim());
    final fat = double.tryParse(fatController.text.trim());
    if (calories == null || protein == null || carbs == null || fat == null) {
      AppSnackbar.error('تأكد من صحة الأرقام المدخلة');
      return;
    }

    isLoading.value = true;
    try {
      if (isEditing) {
        await _repo.updateMeal(
          mealId: editingMeal!.id,
          name: nameController.text.trim(),
          mealTime: timeController.text.trim(),
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          notes: notesController.text.trim(),
        );
        Get.back(result: true);
        AppSnackbar.success('تم تحديث الوجبة');
      } else {
        await _repo.addMeal(
          planId: planId,
          name: nameController.text.trim(),
          mealTime: timeController.text.trim(),
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          notes: notesController.text.trim(),
        );
        Get.back(result: true);
        AppSnackbar.success('تمت إضافة الوجبة');
      }
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('تعذّر حفظ الوجبة');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    timeController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatController.dispose();
    notesController.dispose();
    super.onClose();
  }
}

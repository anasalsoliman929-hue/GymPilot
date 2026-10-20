import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/repositories/nutrition_repository.dart';
import '../../../routes/app_routes.dart';

class NutritionPlanFormController extends GetxController {
  final NutritionRepository _repo = Get.find<NutritionRepository>();

  late final int memberId;
  final titleController = TextEditingController();
  final targetCaloriesController = TextEditingController();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    memberId = Get.arguments as int;
  }

  Future<void> submit() async {
    if (titleController.text.trim().isEmpty) {
      AppSnackbar.error('أدخل عنوان الخطة');
      return;
    }
    final calories = int.tryParse(targetCaloriesController.text.trim());
    if (calories == null || calories <= 0) {
      AppSnackbar.error('أدخل عدد سعرات صحيح');
      return;
    }
    isLoading.value = true;
    try {
      final plan = await _repo.createPlan(
        memberId: memberId,
        title: titleController.text.trim(),
        targetCalories: calories,
      );
      AppSnackbar.success('تم إنشاء خطة التغذية');
      Get.offNamed(AppRoutes.nutritionPlanDetails, arguments: plan.id);
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('تعذّر إنشاء الخطة');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    targetCaloriesController.dispose();
    super.onClose();
  }
}

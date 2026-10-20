import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/training_plan_model.dart';
import '../../../data/repositories/training_plan_repository.dart';

class ExerciseFormController extends GetxController {
  final TrainingPlanRepository _repo = Get.find<TrainingPlanRepository>();

  late final int planId;
  ExerciseModel? editingExercise;
  bool get isEditing => editingExercise != null;

  final nameController = TextEditingController();
  final setsController = TextEditingController(text: '3');
  final repsController = TextEditingController(text: '10');
  final restController = TextEditingController(text: '60');
  final notesController = TextEditingController();
  final equipmentIdController = TextEditingController();

  RxInt selectedDay = 1.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    planId = args['planId'] as int;
    editingExercise = args['exercise'] as ExerciseModel?;

    if (editingExercise != null) {
      final ex = editingExercise!;
      nameController.text = ex.name;
      setsController.text = ex.sets.toString();
      repsController.text = ex.reps.toString();
      restController.text = ex.restSeconds.toString();
      notesController.text = ex.notes ?? '';
      if (ex.equipmentId != null) equipmentIdController.text = ex.equipmentId.toString();
      selectedDay.value = ex.dayOfWeek;
    }
  }

  Future<void> submit() async {
    if (nameController.text.trim().isEmpty) {
      AppSnackbar.error('أدخل اسم التمرين');
      return;
    }
    final sets = int.tryParse(setsController.text.trim());
    final reps = int.tryParse(repsController.text.trim());
    final rest = int.tryParse(restController.text.trim());
    if (sets == null || reps == null || rest == null) {
      AppSnackbar.error('تأكد من صحة الأرقام المدخلة');
      return;
    }

    final equipmentId = equipmentIdController.text.trim().isEmpty
        ? null
        : int.tryParse(equipmentIdController.text.trim());

    isLoading.value = true;
    try {
      if (isEditing) {
        await _repo.updateExercise(
          exerciseId: editingExercise!.id,
          name: nameController.text.trim(),
          equipmentId: equipmentId,
          dayOfWeek: selectedDay.value,
          sets: sets,
          reps: reps,
          restSeconds: rest,
          notes: notesController.text.trim(),
        );
         Get.back(result: true);
        AppSnackbar.success('تم تحديث التمرين');
      } else {
        await _repo.addExercise(
          planId: planId,
          name: nameController.text.trim(),
          equipmentId: equipmentId,
          dayOfWeek: selectedDay.value,
          sets: sets,
          reps: reps,
          restSeconds: rest,
          notes: notesController.text.trim(),
        );
         Get.back(result: true);
        AppSnackbar.success('تمت إضافة التمرين');
      }
      
     
    } on ApiException catch (e) {
      AppSnackbar.error(e.firstError);
    } catch (_) {
      AppSnackbar.error('تعذّر حفظ التمرين');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    setsController.dispose();
    repsController.dispose();
    restController.dispose();
    notesController.dispose();
    equipmentIdController.dispose();
    super.onClose();
  }
}

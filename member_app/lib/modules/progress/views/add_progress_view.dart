import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/models/progress_model.dart';
import '../controllers/progress_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class AddProgressView extends StatefulWidget {
  const AddProgressView({super.key});
  @override
  State<AddProgressView> createState() => _AddProgressViewState();
}

class _AddProgressViewState extends State<AddProgressView> {
  final _formKey   = GlobalKey<FormState>();
  final _weightCtrl = TextEditingController();
  final _fatCtrl    = TextEditingController();
  final _chestCtrl  = TextEditingController();
  final _waistCtrl  = TextEditingController();
  final _armCtrl    = TextEditingController();
  final _notesCtrl  = TextEditingController();

  String? _numValidator(String? v, {double min = 0, double max = 999}) {
    if (v == null || v.trim().isEmpty) return null;
    final n = double.tryParse(v.trim());
    if (n == null) return 'invalid_number'.tr;
    if (n < min || n > max) return 'value_between'.trParams({'min': '$min', 'max': '$max'});
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final hasAny = [_weightCtrl, _fatCtrl, _chestCtrl, _waistCtrl, _armCtrl]
        .any((c) => c.text.trim().isNotEmpty);
    if (!hasAny) {
      AppSnackbar.error('enter_at_least_one'.tr);
      return;
    }

    // الحقول تطابق ما يقبله الباك إند تماماً
    final entry = ProgressEntryModel(
      weight:             _weightCtrl.text.trim().isEmpty ? null : double.parse(_weightCtrl.text.trim()),
      bodyFatPercentage:  _fatCtrl.text.trim().isEmpty    ? null : double.parse(_fatCtrl.text.trim()),
      chestCircumference: _chestCtrl.text.trim().isEmpty  ? null : double.parse(_chestCtrl.text.trim()),
      waistCircumference: _waistCtrl.text.trim().isEmpty  ? null : double.parse(_waistCtrl.text.trim()),
      armCircumference:   _armCtrl.text.trim().isEmpty    ? null : double.parse(_armCtrl.text.trim()),
      notes:              _notesCtrl.text.trim().isEmpty  ? null : _notesCtrl.text.trim(),
    );

    final controller = Get.find<ProgressController>();
    final ok = await controller.addEntry(entry);
    if (ok && mounted) {
      Get.back(result: true);
      AppSnackbar.success('measurement_saved'.tr);
    }
  }

  @override
  void dispose() {
    _weightCtrl.dispose(); _fatCtrl.dispose(); _chestCtrl.dispose();
    _waistCtrl.dispose(); _armCtrl.dispose(); _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fields = [
      {'label': 'weight_field'.tr,           'hint': '82.5', 'suffix': 'kg', 'ctrl': _weightCtrl, 'min': 20.0,  'max': 300.0},
      {'label': 'body_fat_pct'.tr,     'hint': '18',   'suffix': 'percent_unit'.tr,  'ctrl': _fatCtrl,    'min': 1.0,   'max': 70.0},
      {'label': 'chest_circumference'.tr,      'hint': '98',   'suffix': 'cm', 'ctrl': _chestCtrl,  'min': 30.0,  'max': 200.0},
      {'label': 'waist_circumference'.tr,      'hint': '80',   'suffix': 'cm', 'ctrl': _waistCtrl,  'min': 30.0,  'max': 200.0},
      {'label': 'arm_circumference'.tr,     'hint': '36',   'suffix': 'cm', 'ctrl': _armCtrl,    'min': 10.0,  'max': 100.0},
    ];

    return Scaffold(
      appBar: AppBar(title: Text('log_new_measurement'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeSlideIn(
                child: Text(
                  'log_measurements_desc'.tr,
                  style: TextStyle(color: context.textSecondary, fontSize: 13),
                ),
              ),
              const SizedBox(height: 20),
              ...fields.asMap().entries.map((e) => FadeSlideIn(
                delay: Duration(milliseconds: 60 + e.key * 60),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextFormField(
                    controller: e.value['ctrl'] as TextEditingController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: e.value['label'] as String,
                      hintText:  e.value['hint'] as String,
                      suffixText: e.value['suffix'] as String,
                    ),
                    validator: (v) => _numValidator(v,
                      min: e.value['min'] as double,
                      max: e.value['max'] as double),
                  ),
                ),
              )),
              FadeSlideIn(
                delay: const Duration(milliseconds: 360),
                child: TextFormField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'notes_optional'.tr),
                ),
              ),
              const SizedBox(height: 24),
              FadeSlideIn(
                delay: const Duration(milliseconds: 420),
                child: Obx(() {
                  final controller = Get.find<ProgressController>();
                  return ElevatedButton(
                    onPressed: controller.isSaving.value ? null : _submit,
                    child: controller.isSaving.value
                        ? SizedBox(height: 22, width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.4, color: context.textPrimary))
                        : Text('save_measurements'.tr),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

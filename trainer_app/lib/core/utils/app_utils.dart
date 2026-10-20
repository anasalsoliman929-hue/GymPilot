/// أدوات مساعدة عامة تُستخدم بأكثر من موديول
import 'package:get/get.dart';

/// 1 = الأحد ... 7 = السبت (مطابق لما يرجعه الباك إند بحقل training_days / day_of_week)
/// Values are translation keys — use `weekDayLabel(day)` to get the localized text.
const Map<int, String> kWeekDayKeys = {
  1: 'day_sun',
  2: 'day_mon',
  3: 'day_tue',
  4: 'day_wed',
  5: 'day_thu',
  6: 'day_fri',
  7: 'day_sat',
};

/// Backward-compatible map of localized day labels (rebuilt fresh on each read
/// so it always reflects the currently selected language).
Map<int, String> get kWeekDays =>
    kWeekDayKeys.map((k, v) => MapEntry(k, v.tr));

String weekDayLabel(int day) => (kWeekDayKeys[day] ?? '').tr;

String weekDaysLabel(List<int> days) {
  if (days.isEmpty) return 'no_days_selected'.tr;
  final sorted = [...days]..sort();
  return sorted.map((d) => weekDayLabel(d)).join('، ');
}

String formatDate(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) return '—';
  try {
    final date = DateTime.parse(isoDate);
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  } catch (_) {
    return isoDate;
  }
}

const Map<String, String> kGoalLabelKeys = {
  'weight_loss': 'goal_weight_loss',
  'weight_gain': 'goal_weight_gain',
  'muscle_gain': 'goal_muscle_gain',
  'fitness': 'goal_fitness',
  'bodybuilding': 'goal_bodybuilding',
};

String goalLabel(String? goal) {
  if (goal == null) return '—';
  final key = kGoalLabelKeys[goal];
  return key != null ? key.tr : goal;
}

const Map<String, String> kGenderLabelKeys = {
  'male': 'gender_male',
  'female': 'gender_female',
};

String genderLabel(String? gender) {
  if (gender == null) return '—';
  final key = kGenderLabelKeys[gender];
  return key != null ? key.tr : gender;
}

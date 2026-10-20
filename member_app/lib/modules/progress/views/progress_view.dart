import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/models/progress_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/progress_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProgressController>();

    return Scaffold(
      appBar: AppBar(title: Text('my_measurements'.tr), automaticallyImplyLeading: false),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: context.textPrimary,
        onPressed: () async {
          final added = await Get.toNamed(AppRoutes.addProgress);
          if (added == true) c.load();
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (c.isLoading.value) return const AppLoading();
        if (c.error != null) {
          return AppErrorView(message: c.error!, onRetry: c.load);
        }

        return Column(
          children: [
            // Filter chips
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Obx(() => Row(
                children: [
                  _FilterChip(label: 'filter_all'.tr,   value: 'all',   current: c.filter.value, onTap: c.changeFilter),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'filter_month'.tr,    value: 'month', current: c.filter.value, onTap: c.changeFilter),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'filter_week'.tr,  value: 'week',  current: c.filter.value, onTap: c.changeFilter),
                ],
              )),
            ),

            Expanded(
              child: c.records.isEmpty
                  ? AppEmptyState(
                      icon: Icons.monitor_weight_outlined,
                      message: 'no_measurements_yet'.tr,
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      children: [
                        if (c.records.length >= 2)
                          FadeSlideIn(child: _WeightChart(records: c.records)),
                        const SizedBox(height: 14),
                        ...c.records.asMap().entries.map((e) => FadeSlideIn(
                          delay: Duration(milliseconds: 60 + e.key * 50),
                          child: _EntryCard(entry: e.value),
                        )),
                      ],
                    ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Weight Chart ────────────────────────────────────────────
class _WeightChart extends StatefulWidget {
  final List<ProgressEntryModel> records;
  const _WeightChart({required this.records});
  @override
  State<_WeightChart> createState() => _WeightChartState();
}

class _WeightChartState extends State<_WeightChart> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 200), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final weights = widget.records
        .where((r) => r.weight != null)
        .map((r) => r.weight!)
        .toList();
    if (weights.isEmpty) return const SizedBox.shrink();

    final maxW = weights.reduce((a, b) => a > b ? a : b);
    final minW = weights.reduce((a, b) => a < b ? a : b);
    final range = (maxW - minW) == 0 ? 1.0 : (maxW - minW);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text('weight_progress'.tr, style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 90,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (_, __) => Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: weights.reversed.toList().map((w) {
                  final pct = ((w - minW) / range).clamp(0.15, 1.0);
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('$w', style: const TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 3),
                          Container(
                            height: 70 * pct * _anim.value,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Entry Card ──────────────────────────────────────────────
class _EntryCard extends StatelessWidget {
  final ProgressEntryModel entry;
  const _EntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final date = entry.createdAt?.split('T').first ?? '--';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: context.textSecondary),
              const SizedBox(width: 6),
              Text(date, style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16, runSpacing: 8,
            children: [
              if (entry.weight            != null) MiniStat(value: 'kg_value'.trParams({'n': '${entry.weight}'}),              label: 'weight_label'.tr),
              if (entry.bodyFatPercentage != null) MiniStat(value: '${entry.bodyFatPercentage}٪',      label: 'fat_label'.tr),
              if (entry.chestCircumference!= null) MiniStat(value: 'cm_value'.trParams({'n': '${entry.chestCircumference}'}),  label: 'chest_label'.tr),
              if (entry.waistCircumference!= null) MiniStat(value: 'cm_value'.trParams({'n': '${entry.waistCircumference}'}),  label: 'waist_label'.tr),
              if (entry.armCircumference  != null) MiniStat(value: 'cm_value'.trParams({'n': '${entry.armCircumference}'}),    label: 'arm_label'.tr),
            ],
          ),
          if (entry.notes != null && entry.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(entry.notes!, style: TextStyle(color: context.textSecondary, fontSize: 12)),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label, value, current;
  final ValueChanged<String> onTap;
  const _FilterChip({required this.label, required this.value, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selected = value == current;
    return TapScale(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : context.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : context.borderColor),
        ),
        child: Text(label, style: TextStyle(color: selected ? context.textPrimary : context.textSecondary, fontSize: 12)),
      ),
    );
  }
}

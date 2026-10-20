import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_animations.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../data/models/workout_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/workout_controller.dart';
import '../../../core/theme/app_colors_context.dart';

class WorkoutView extends StatelessWidget {
  const WorkoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<WorkoutController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('today_workout'.tr),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Get.toNamed(AppRoutes.workoutPlanFull),
            child: Text('full_plan'.tr,
                style: const TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoadingToday.value) {
          return const AppLoading();
        }
        if (c.todayError != null) {
          return AppErrorView(message: c.todayError!, onRetry: c.loadToday);
        }
        final today = c.today.value;
        if (today == null) {
          return AppEmptyState(
              icon: Icons.fitness_center_outlined,
              message: 'no_training_plan_yet'.tr);
        }
        if (today.isRestDay) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bedtime_outlined,
                    size: 64, color: context.textSecondary),
                const SizedBox(height: 16),
                Text('rest_day'.tr,
                    style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('rest_well_message'.tr,
                    style: TextStyle(color: context.textSecondary)),
              ],
            ),
          );
        }
        return _WorkoutContent(today: today, c: c);
      }),
    );
  }
}

class _WorkoutContent extends StatefulWidget {
  final TodayWorkoutModel today;
  final WorkoutController c;
  const _WorkoutContent({required this.today, required this.c});

  @override
  State<_WorkoutContent> createState() => _WorkoutContentState();
}

class _WorkoutContentState extends State<_WorkoutContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<ExerciseModel> _exercises;

  int get _doneCount => _exercises.where((e) => e.completed).length;

  @override
  void initState() {
    super.initState();
    _exercises = List.from(widget.today.exercises);
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    Future.delayed(const Duration(milliseconds: 200),
        () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle(int index) {
    setState(() => _exercises[index].completed = !_exercises[index].completed);
  }

  @override
  Widget build(BuildContext context) {
    final planTitle = widget.today.plan?['title']?.toString() ?? 'training_plan_fallback'.tr;
    final progress  = _exercises.isEmpty ? 0.0 : _doneCount / _exercises.length;

    return Column(
      children: [
        // Header
        FadeSlideIn(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.flag_outlined,
                        color: context.textPrimary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(planTitle,
                          style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w600)),
                    ),
                    Text('$_doneCount / ${_exercises.length}',
                        style: TextStyle(
                            color: context.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white30,
                    color: context.textPrimary,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: RefreshIndicator(
            onRefresh: widget.c.loadToday,
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _exercises.length,
              itemBuilder: (_, i) => FadeSlideIn(
                delay: Duration(milliseconds: 60 + i * 50),
                child: _ExerciseTile(
                  exercise: _exercises[i],
                  onToggle: () => _toggle(i),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExerciseTile extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onToggle;
  const _ExerciseTile({required this.exercise, required this.onToggle});

  @override
  State<_ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<_ExerciseTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _checkScale = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
    if (widget.exercise.completed) _ctrl.value = 1.0;
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _toggle() {
    widget.onToggle();
    if (widget.exercise.completed) _ctrl.forward();
    else _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.exercise.completed;
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: done ? AppColors.primary.withOpacity(0.08) : context.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: done ? AppColors.primary.withOpacity(0.5) : context.borderColor,
          ),
        ),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: done ? AppColors.primary : context.borderColor,
                    width: 2,
                  ),
                ),
                child: done
                    ? ScaleTransition(
                        scale: _checkScale,
                        child: Icon(Icons.check,
                            color: context.textPrimary, size: 14))
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: done ? context.textSecondary : context.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: context.textSecondary,
                    ),
                    child: Text(widget.exercise.name),
                  ),
                  const SizedBox(height: 3),
                  Text(widget.exercise.details,
                      style: TextStyle(
                          fontSize: 11, color: context.textSecondary)),
                  if (widget.exercise.notes != null &&
                      widget.exercise.notes!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text('💡 ${widget.exercise.notes}',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
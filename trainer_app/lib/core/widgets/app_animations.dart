import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ─── FadeSlideIn ─────────────────────────────────────────────
class FadeSlideIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offsetY;

  const FadeSlideIn({
    super.key, required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 450),
    this.offsetY = 24,
  });

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade, _slide;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: widget.duration);
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(begin: widget.offsetY, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(
        opacity: _fade.value,
        child: Transform.translate(offset: Offset(0, _slide.value), child: child),
      ),
      child: widget.child,
    );
  }
}

// ─── PulseWidget ─────────────────────────────────────────────
class PulseWidget extends StatefulWidget {
  final Widget child;
  const PulseWidget({super.key, required this.child});
  @override
  State<PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _scale = Tween(begin: 1.0, end: 1.06).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _scale, child: widget.child);
}

// ─── TapScale ────────────────────────────────────────────────
class TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  const TapScale({super.key, required this.child, this.onTap, this.scale = 0.95});
  @override
  State<TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<TapScale> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween(begin: 1.0, end: widget.scale).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap?.call(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ─── ShimmerBox ──────────────────────────────────────────────
class ShimmerBox extends StatefulWidget {
  final double width, height, radius;
  const ShimmerBox({super.key, this.width = double.infinity, this.height = 16, this.radius = 8});
  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width, height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(-1.5 + _anim.value * 3, 0),
            end: Alignment(-0.5 + _anim.value * 3, 0),
            colors: const [Color(0xFF1A1A1A), Color(0xFF2C2C2E), Color(0xFF1A1A1A)],
          ),
        ),
      ),
    );
  }
}

// ─── AnimatedCounter ─────────────────────────────────────────
class AnimatedCounter extends StatefulWidget {
  final int end;
  final String suffix, prefix;
  final TextStyle? style;
  final Duration duration;
  const AnimatedCounter({
    super.key, required this.end,
    this.suffix = '', this.prefix = '',
    this.style, this.duration = const Duration(milliseconds: 1200),
  });
  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<int> _count;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: widget.duration);
    _count = IntTween(begin: 0, end: widget.end).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _count,
      builder: (_, __) => Text('${widget.prefix}${_count.value}${widget.suffix}', style: widget.style),
    );
  }
}

// ─── AnimatedProgressBar ─────────────────────────────────────
class AnimatedProgressBar extends StatefulWidget {
  final double value;
  final Color? color;
  final double height;
  const AnimatedProgressBar({super.key, required this.value, this.color, this.height = 7});
  @override
  State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = Tween(begin: 0.0, end: widget.value.clamp(0.0, 1.0)).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 200), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: _anim.value,
          backgroundColor: Theme.of(context).dividerColor,
          color: widget.color ?? AppColors.primary,
          minHeight: widget.height,
        ),
      ),
    );
  }
}

// ─── StaggeredList ───────────────────────────────────────────
class StaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration baseDelay, stepDelay;
  final EdgeInsets padding;
  const StaggeredList({
    super.key, required this.children,
    this.baseDelay = const Duration(milliseconds: 80),
    this.stepDelay = const Duration(milliseconds: 70),
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: children.length,
      itemBuilder: (_, i) => FadeSlideIn(delay: baseDelay + (stepDelay * i), child: children[i]),
    );
  }
}

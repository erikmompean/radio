import 'package:flutter/widgets.dart';

class SpeakerAnimation extends StatefulWidget {
  final Widget child;
  final bool on;
  const SpeakerAnimation({super.key, required this.child, required this.on});
  @override
  State<SpeakerAnimation> createState() => _SpeakerAnimationState();
}

class _SpeakerAnimationState extends State<SpeakerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    _animation = TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.05)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.05, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SpeakerAnimation oldWidget) {
    if (!widget.on) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
    
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';

class ScaleAnimationButton extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  const ScaleAnimationButton({super.key, required this.child, this.onTap});

  @override
  State<ScaleAnimationButton> createState() => _ScaleAnimationButtonState();
}

class _ScaleAnimationButtonState extends State<ScaleAnimationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.83).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _controller.forward();
        await Future.delayed(const Duration(milliseconds: 100));
        widget.onTap?.call();
      },
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

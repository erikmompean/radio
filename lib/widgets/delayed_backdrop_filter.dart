import 'dart:ui';

import 'package:flutter/material.dart';

class DelayedBackdropFilter extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final double sigmaX;
  final double sigmaY;

  const DelayedBackdropFilter({
    super.key,
    required this.child,
    this.delay = const Duration(seconds: 1),
    this.sigmaX = 5.0,
    this.sigmaY = 5.0,
  });

  @override
  State<DelayedBackdropFilter> createState() => _DelayedBackdropFilterState();
}

class _DelayedBackdropFilterState extends State<DelayedBackdropFilter>
    with SingleTickerProviderStateMixin {
  bool _showFilter = false;
  late AnimationController _controller;
  late Animation<double> _animationX;
  late Animation<double> _animationY;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationX = Tween<double>(begin: 0, end: widget.sigmaX).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _animationY = Tween<double>(begin: 0, end: widget.sigmaY).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _showFilter = true;
        });
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_showFilter)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _animationX.value,
                  sigmaY: _animationY.value,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              );
            },
          ),
        widget.child,
      ],
    );
  }
}

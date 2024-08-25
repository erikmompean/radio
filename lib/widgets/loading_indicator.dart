import 'package:flutter/widgets.dart';
import 'package:radio/utils/app_colors.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({
    super.key,
    this.size = 50.0,
    this.duration = const Duration(milliseconds: 2000),
    this.controller,
  });

  final double size;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..repeat(reverse: true);
    _animation = Tween(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: List.generate(2, (i) {
          return Transform.scale(
            scale: (1.0 - i - _animation.value.abs()).abs(),
            child: SizedBox.fromSize(
              size: Size.square(widget.size),
              child: _itemBuilder(i),
            ),
          );
        }),
      ),
    );
  }

  Widget _itemBuilder(int index) => DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withOpacity(0.6),
        ),
      );
}

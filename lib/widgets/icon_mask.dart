import 'package:flutter/widgets.dart';

class IconMask extends StatelessWidget {
  final Widget child;
  const IconMask({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => const LinearGradient(
        colors: [Color(0xffb5aeb8), Color(0xff6e5e72)],
        stops: [0.25, 0.5],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: child,
    );
  }
}

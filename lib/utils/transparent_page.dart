import 'package:flutter/material.dart';

class TransparentPage extends Page<void> {
  final WidgetBuilder builder;

  const TransparentPage({required this.builder, super.key});

  @override
  Route<void> createRoute(BuildContext context) {
    return TransparentPageRoute(builder: builder, settings: this);
  }
}

class TransparentPageRoute extends PageRoute {
  TransparentPageRoute({
    required this.builder,
    super.settings,
  }) : super(fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    const begin = Offset(0, -1);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(
      CurveTween(curve: curve),
    );

    var offsetAnimation = animation.drive(tween);
    final result = builder(context);

    return SlideTransition(
      position: offsetAnimation,
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}

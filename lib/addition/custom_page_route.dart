// ignore_for_file: avoid_renaming_method_parameters


import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder{
  final Widget child;
  final AxisDirection direction;

  CustomPageRoute({
    required this.child,
    this.direction = AxisDirection.right,
}) : super(
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, seconderyAnimation) => child,
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> seconderyAnimation, Widget child) =>

      // scale animation
      /*ScaleTransition(
        scale: animation,
        child: child,
      );*/

      // slide animation
      SlideTransition(
        position: Tween<Offset>(
          begin: getBeginOffset(),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  Offset getBeginOffset(){
    switch (direction){
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }

}
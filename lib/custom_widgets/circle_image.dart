import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final Color color;
  final Color backgroundColor;
  final Widget child;
  final Function() onTap;

  const CircleImage(
      {super.key, required this.color,
      required this.backgroundColor,
      required this.child,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            color: backgroundColor),
        child: child,
      ),
    );
  }
}

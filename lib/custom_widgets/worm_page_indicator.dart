import 'package:flutter/material.dart';

class WormIndicator extends StatelessWidget {
  final int count;
  final int current;

  const WormIndicator({
    super.key,
    required this.count,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) {
          final isActive = index == current;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4), // spacing
            height: 8,
            width: isActive ? 22 : 8,         // 🔥 expandable worm
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.indigo              // active color
                  : Colors.indigo.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          );
        },
      ),
    );
  }
}

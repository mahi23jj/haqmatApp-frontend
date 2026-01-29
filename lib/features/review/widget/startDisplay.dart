import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final int value; // 0..5
  final double size;
  const StarDisplay({
    Key? key, 
    this.value = 0,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Icon(
          i < value ? Icons.star : Icons.star_border,
          color: const Color(0xFFFFC107),
          size: size,
        ),
      ),
    );
  }
}
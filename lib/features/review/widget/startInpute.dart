// import 'dart:ui';

// import 'package:flutter/material.dart';

// class StarInput extends StatelessWidget {
//   final int value;
//   final ValueChanged<int> onChanged;
//   const StarInput({Key? key, required this.value, required this.onChanged})
//     : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(5, (i) {
//         final idx = i + 1;
//         final active = idx <= value;
//         return IconButton(
//           onPressed: () => onChanged(idx),
//           icon: Icon(
//             active ? Icons.star : Icons.star_border,
//             size: 34,
//             color: const Color(0xFFD8B384),
//           ),
//         );
//       }),
//     );
//   }
// }
import 'package:flutter/material.dart';

class StarInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const StarInput({
    Key? key, 
    required this.value, 
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final starValue = i + 1;
        final isActive = starValue <= value;
        
        return IconButton(
          onPressed: () => onChanged(starValue),
          icon: Icon(
            isActive ? Icons.star : Icons.star_border,
            size: 36,
            color: const Color(0xFFFFC107),
          ),
          padding: const EdgeInsets.all(4),
          tooltip: '$starValue ኮከቦች',
        );
      }),
    );
  }
}
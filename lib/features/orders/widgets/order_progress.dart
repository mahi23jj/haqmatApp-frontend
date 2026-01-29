// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';

// class OrderProgress extends StatelessWidget {
//   final String stage; // 1–4

//   const OrderProgress({required this.stage});

//   @override
//   Widget build(BuildContext context) {
//     final steps = ["pending", 'failed' , 'paid' , 'delivered' ,'completed', 'cancelled', 'refunded'];

//     // get index of steps where equal with stage
//     final index = steps.indexWhere((element) => element == stage);

//     return SingleChildScrollView(
//       // horizontal scroll
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: List.generate(7, (i) {
//           final completed = i < (index + 1);
      
//           return Row(
//             children: [
//               Column(
//                 children: [
//                   CircleAvatar(
//                     radius: 11,
//                     backgroundColor: completed
//                         ? AppColors.primary
//                         : Colors.grey.shade300,
//                     child: Icon(
//                       Icons.check,
//                       size: 14,
//                       color: completed ? Colors.white : Colors.grey.shade600,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(steps[i], style: TextStyle(fontSize: 11)),
//                 ],
//               ),
//               SizedBox(width: 3),
      
//               if (i < 6)
//                 Container(
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.all(10),
//                   width: 30,
//                   height: 2,
//                   color: Colors.grey.shade300,
//                 ),
//             ],
//           );
//           // add line between steps
//         }),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';

class OrderProgress extends StatelessWidget {
  final String stage; // English stage from backend

  const OrderProgress({required this.stage});

  // Map English stages to Amharic
  Map<String, String> get _stageTranslations => {
    'pending': 'በመጠባበቅ ላይ',
    'paid': 'ተከፍሏል',
    'processing': 'በማቀናበር ላይ',
    'shipped': 'ተላክቷል',
    'delivered': 'ደርሷል',
    'completed': 'ተጠናቋል',
    'cancelled': 'ተሰርዟል',
    'failed': 'አልተሳካም',
    'refunded': 'ተመላሽ ተደርጓል',
  };

  // Order of stages for display
  List<String> get _displayStages => [
    'pending',
    'paid',
    'processing',
    'shipped',
    'delivered',
    'completed',
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = _displayStages.indexWhere((s) => s == stage);
    final effectiveIndex = currentIndex == -1 ? 0 : currentIndex;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_displayStages.length, (i) {
          final stageKey = _displayStages[i];
          final isCompleted = i <= effectiveIndex;
          final stageLabel = _stageTranslations[stageKey] ?? stageKey;

          return Row(
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: isCompleted
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    child: Icon(
                      isCompleted ? Icons.check : Icons.circle,
                      size: isCompleted ? 14 : 8,
                      color: isCompleted ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stageLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: isCompleted ? AppColors.textDark : Colors.grey.shade600,
                      fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 3),

              if (i < _displayStages.length - 1)
                Container(
                  width: 30,
                  height: 2,
                  color: isCompleted ? AppColors.primary : Colors.grey.shade300,
                ),
            ],
          );
        }),
      ),
    );
  }
}
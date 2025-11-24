import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';

class OrderProgress extends StatelessWidget {
  final int stage; // 1–4

  const OrderProgress({required this.stage});

  @override
  Widget build(BuildContext context) {
    final steps = ["Ordered", "Packed", "Shipped", "Delivered"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(4, (i) {
        final completed = i < stage;

        return Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: completed
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: completed ? Colors.white : Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(steps[i], style: TextStyle(fontSize: 11)),
              ],
            ),
            SizedBox(width: 8),

            if (i < 3)
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                width: 70,
                height: 2,
                color: Colors.grey.shade300,
              ),
          ],
        );
        // add line between steps
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';

class OrderProgress extends StatelessWidget {
  final String stage; // 1–4

  const OrderProgress({required this.stage});

  @override
  Widget build(BuildContext context) {
    final steps = ["pending", 'failed' , 'paid' , 'delivered' ,'completed', 'cancelled', 'refunded'];

    // get index of steps where equal with stage
    final index = steps.indexWhere((element) => element == stage);

    return SingleChildScrollView(
      // horizontal scroll
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (i) {
          final completed = i < (index + 1);
      
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
              SizedBox(width: 3),
      
              if (i < 6)
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  width: 30,
                  height: 2,
                  color: Colors.grey.shade300,
                ),
            ],
          );
          // add line between steps
        }),
      ),
    );
  }
}

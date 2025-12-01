import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/startDisplay.dart';
import 'package:haqmate/features/review/widget/write_review.dart';
import 'package:provider/provider.dart';

class ReviewSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReviewViewModel>();
    final total = vm.reviews!.totalCount;
    final avg = vm.reviews!.averageRating;

    void _openWriteReviewSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        builder: (ctx) => Padding(
          padding: MediaQuery.of(ctx).viewInsets,
          child: const WriteReviewSheet(),
        ),
      );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            // Left big rating
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B4B27),
                    ),
                  ),
                  const SizedBox(height: 4),
                  StarDisplay(value: avg.round()),
                  const SizedBox(height: 4),
                  Text(
                    '\${total} reviews',
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => _openWriteReviewSheet(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 50,
                      ),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

        /*   const SizedBox(height: 10),

            
            ), */
        // Right rating bars
        // Expanded(
        //   flex: 6,
        //   child: Column(
        //     children: List.generate(5, (i) {
        //       final star = 5 - i; // 5..1
        //       final count = vm.ratingCounts[star] ?? 0;
        //       final percent = total == 0 ? 0.0 : count / total;
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 4),
        //         child: Row(
        //           children: [
        //             SizedBox(
        //               width: 28,
        //               child: Text(
        //                 '\${star}★',
        //                 style: const TextStyle(fontSize: 12),
        //               ),
        //             ),
        //             const SizedBox(width: 8),
        //             Expanded(
        //               child: Stack(
        //                 children: [
        //                   Container(
        //                     height: 8,
        //                     decoration: BoxDecoration(
        //                       color: const Color(0xFFF0F0F0),
        //                       borderRadius: BorderRadius.circular(8),
        //                     ),
        //                   ),
        //                   FractionallySizedBox(
        //                     widthFactor: percent,
        //                     child: Container(
        //                       height: 8,
        //                       decoration: BoxDecoration(
        //                         color: const Color(0xFFD8B384),
        //                         borderRadius: BorderRadius.circular(8),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             const SizedBox(width: 8),
        //             SizedBox(width: 24, child: Text('\${count}')),
        //           ],
        //         ),
        //       );
        //     }),
        //   ),
        // ),
      ),
    );
  }
}

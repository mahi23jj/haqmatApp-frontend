// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
// import 'package:haqmate/features/review/widget/startDisplay.dart';
// import 'package:haqmate/features/review/widget/write_review.dart';
// import 'package:provider/provider.dart';

// class ReviewSummaryCard extends StatelessWidget {
//   final String productId;
//   const ReviewSummaryCard({super.key , required this.productId});
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<ReviewViewModel>();
//     final total = vm.reviews!.totalCount;
//     final avg = vm.reviews!.averageRating;

//     void _openWriteReviewSheet(BuildContext context) {
//       showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
//         ),
//         builder: (ctx) => Padding(
//           padding: MediaQuery.of(ctx).viewInsets,
//           child:  WriteReviewSheet(productId: productId,),
//         ),
//       );
//     }

//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 3,

//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child:
//             // Left big rating
//             Expanded(
//               flex: 4,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     avg.toStringAsFixed(1),
//                     style: const TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF7B4B27),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   StarDisplay(value: avg.round()),
//                   const SizedBox(height: 4),
//                   Text(
//                     '$total reviews',
//                     style: const TextStyle(color: Colors.black54),
//                   ),
//                   const SizedBox(height: 10),
//                 /*   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primary,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     onPressed: () => _openWriteReviewSheet(context),
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 50,
//                       ),
//                       child: Text(
//                         "write a review",
//                         style: TextStyle(
//                           color: AppColors.background,
//                           fontSize: 17,
//                         ),
//                       ),
//                     ),
//                   ), */
//                 ],
//               ),
//             ),

//         /*   const SizedBox(height: 10),

            
//             ), */
//         // Right rating bars
//         // Expanded(
//         //   flex: 6,
//         //   child: Column(
//         //     children: List.generate(5, (i) {
//         //       final star = 5 - i; // 5..1
//         //       final count = vm.ratingCounts[star] ?? 0;
//         //       final percent = total == 0 ? 0.0 : count / total;
//         //       return Padding(
//         //         padding: const EdgeInsets.symmetric(vertical: 4),
//         //         child: Row(
//         //           children: [
//         //             SizedBox(
//         //               width: 28,
//         //               child: Text(
//         //                 '\${star}★',
//         //                 style: const TextStyle(fontSize: 12),
//         //               ),
//         //             ),
//         //             const SizedBox(width: 8),
//         //             Expanded(
//         //               child: Stack(
//         //                 children: [
//         //                   Container(
//         //                     height: 8,
//         //                     decoration: BoxDecoration(
//         //                       color: const Color(0xFFF0F0F0),
//         //                       borderRadius: BorderRadius.circular(8),
//         //                     ),
//         //                   ),
//         //                   FractionallySizedBox(
//         //                     widthFactor: percent,
//         //                     child: Container(
//         //                       height: 8,
//         //                       decoration: BoxDecoration(
//         //                         color: const Color(0xFFD8B384),
//         //                         borderRadius: BorderRadius.circular(8),
//         //                       ),
//         //                     ),
//         //                   ),
//         //                 ],
//         //               ),
//         //             ),
//         //             const SizedBox(width: 8),
//         //             SizedBox(width: 24, child: Text('\${count}')),
//         //           ],
//         //         ),
//         //       );
//         //     }),
//         //   ),
//         // ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/startDisplay.dart';
import 'package:haqmate/features/review/widget/write_review.dart';
import 'package:provider/provider.dart';

class ReviewSummaryCard extends StatelessWidget {
  final String productId;
  const ReviewSummaryCard({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReviewViewModel>();
    final total = vm.reviews?.totalCount ?? 0;
    final avg = vm.reviews?.averageRating ?? 0.0;
    final ratingCounts = vm.ratingCounts;

    void _openWriteReviewSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        builder: (ctx) => Padding(
          padding: MediaQuery.of(ctx).viewInsets,
          child: WriteReviewSheet(productId: productId),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Overall Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Big rating number
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    avg.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  StarDisplay(value: avg.round()),
                  const SizedBox(height: 8),
                  Text(
                    '$total ${total == 1 ? 'ግምገማ' : 'ግምገማዎች'}',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              
              // Rating bars
              Expanded(
                child: Column(
                  children: List.generate(5, (i) {
                    final star = 5 - i;
                    final count = ratingCounts[star] ?? 0;
                    final percent = total == 0 ? 0.0 : count / total;
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: Text(
                              '$star',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 8),
                          
                          // Progress bar
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: percent,
                                  child: Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 32,
                            child: Text(
                              count.toString(),
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Write Review Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openWriteReviewSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.edit_outlined, size: 20),
              label: const Text(
                'ግምገማ ይጻፉ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
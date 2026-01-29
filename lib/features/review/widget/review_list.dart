// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/review/model/review_model.dart';
// import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
// import 'package:haqmate/features/review/widget/startDisplay.dart';
// import 'package:provider/provider.dart';

// class ReviewsList extends StatelessWidget {
//   ReviewsList({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<ReviewViewModel>(context, listen: false);

//     List<Review> reviewlist = vm.reviews!.reviews;

//     if (vm.loading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (vm.error != null) {
//       return Center(child: Text('Error: ${vm.error}'));
//     }

//     if (reviewlist.isEmpty) {
//       return const Center(child: Text('No reviews yet'));
//     }

//     return ListView.separated(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: const EdgeInsets.only(bottom: 20),
//       itemBuilder: (ctx, index) {
//         final r = reviewlist[index];
//         return AnimatedReviewCard(review: r, index: index);
//       },
//       separatorBuilder: (_, __) => const SizedBox(height: 12),
//       itemCount: reviewlist.length,
//     );
//   }
// }

// class AnimatedReviewCard extends StatefulWidget {
//   final Review review;
//   final int index;
//   const AnimatedReviewCard({
//     Key? key,
//     required this.review,
//     required this.index,
//   }) : super(key: key);

//   @override
//   State<AnimatedReviewCard> createState() => _AnimatedReviewCardState();
// }

// class _AnimatedReviewCardState extends State<AnimatedReviewCard>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<Offset> _offset;
//   late final Animation<double> _opacity;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 450),
//     );
//     _offset = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//     _opacity = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//     // Staggered animation
//     Future.delayed(
//       Duration(milliseconds: 80 * widget.index),
//       () => _controller.forward(),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final r = widget.review;
//     return FadeTransition(
//       opacity: _opacity,
//       child: SlideTransition(
//         position: _offset,
//         child: Card(
//           color: const Color.fromARGB(255, 255, 255, 255),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(14.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       child: Text(r.author.isEmpty ? '?' : r.author[0]),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 r.author,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               if (r.verified) VerifiedBadge(),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             _formatDate(r.date),
//                             style: const TextStyle(
//                               color: Colors.black54,
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     StarDisplay(value: r.rating),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Text(r.text),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
//                     ),
//                     const SizedBox(width: 4),
//                     const Text('Helpful', style: TextStyle(fontSize: 13)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime d) {
//     final diff = DateTime.now().difference(d);
//     if (diff.inDays >= 365)
//       return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
//     if (diff.inDays >= 30) return '${d.month}-${d.day}-${d.year}';
//     if (diff.inDays >= 7) return '${diff.inDays ~/ 7}w ago';
//     if (diff.inDays > 0) return '${diff.inDays}d ago';
//     if (diff.inHours > 0) return '${diff.inHours}h ago';
//     return 'just now';
//   }
// }

// class VerifiedBadge extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.green.shade50,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: const Text(
//         'Verified',
//         style: TextStyle(color: Colors.green, fontSize: 12),
//       ),
//     );
//   }
// }


import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/review/model/review_model.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/startDisplay.dart';
import 'package:provider/provider.dart';

class ReviewsList extends StatelessWidget {
  const ReviewsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReviewViewModel>(context);
    final reviews = vm.reviews?.reviews ?? [];

    if (vm.loading && reviews.isEmpty) {
      return _buildLoadingShimmer();
    }

    if (vm.error != null && reviews.isEmpty) {
      return _buildErrorState(vm);
    }

    if (reviews.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (ctx, index) {
        final review = reviews[index];
        return AnimatedReviewCard(review: review, index: index);
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 16,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 12,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 16,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 14,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                height: 14,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildErrorState(ReviewViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade600,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'ግምገማዎችን መጫን አልተሳካም',
            style: TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vm.error!,
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              // textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Icon(
            Icons.reviews_outlined,
            color: AppColors.textLight,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'ምንም ግምገማ የለም',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ይህን ምርት የመጀመሪያው ግምገማ የምትሰጡ ይሁኑ!',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 14,
              // textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedReviewCard extends StatefulWidget {
  final Review review;
  final int index;
  const AnimatedReviewCard({
    Key? key,
    required this.review,
    required this.index,
  }) : super(key: key);

  @override
  State<AnimatedReviewCard> createState() => _AnimatedReviewCardState();
}

class _AnimatedReviewCardState extends State<AnimatedReviewCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(
      Duration(milliseconds: 80 * widget.index),
      () => _controller.forward(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.review;
    
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      review.author.isNotEmpty ? review.author[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              review.author,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (review.verified) VerifiedBadge(),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(review.date),
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StarDisplay(value: review.rating),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                review.text,
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.thumb_up_alt_outlined,
                      color: AppColors.textLight,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'ጠቃሚ',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 365) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
    if (difference.inDays >= 30) {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'ወር' : 'ወራት'} በፊት';
    }
    if (difference.inDays >= 7) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks ${weeks == 1 ? 'ሳምንት' : 'ሳምንታት'} በፊት';
    }
    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'ቀን' : 'ቀናት'} በፊት';
    }
    if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'ሰዓት' : 'ሰዓቶች'} በፊት';
    }
    if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'ደቂቃ' : 'ደቂቃዎች'} በፊት';
    }
    return 'አሁን';
  }
}

class VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: Colors.green.shade700, size: 12),
          const SizedBox(width: 4),
          Text(
            'ተረጋግጧል',
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
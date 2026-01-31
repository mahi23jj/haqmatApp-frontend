// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
// import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
// import 'package:haqmate/features/review/widget/startInpute.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:haqmate/core/widgets/custom_button.dart';

// class WriteReviewSheet extends StatefulWidget {
//   final String productId;
//   WriteReviewSheet({Key? key, required this.productId}) : super(key: key);

//   @override
//   State<WriteReviewSheet> createState() => _WriteReviewSheetState();
// }

// class _WriteReviewSheetState extends State<WriteReviewSheet> {
//   int _rating = 0;
//   final _controller = TextEditingController();
//   bool _submitting = false;

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height * 0.6;
//     return Container(
//       constraints: BoxConstraints(maxHeight: height),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 44,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//             ),
//           ),
//           const SizedBox(height: 18),
//           const Text(
//             'Write a Review',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF7B4B27),
//             ),
//           ),
//           const SizedBox(height: 14),
//           const Text('Your Rating', style: TextStyle(color: Colors.black54)),
//           const SizedBox(height: 8),
//           StarInput(
//             value: _rating,
//             onChanged: (v) => setState(() => _rating = v),
//           ),
//           const SizedBox(height: 12),
//           const Text('Your Review', style: TextStyle(color: Colors.black54)),
//           // const SizedBox(height: 8),
//           // inside Column of sheet
//           const SizedBox(height: 8),
//           TextField(
//             controller: _controller,
//             maxLines: 3, // or some reasonable number
//             decoration: InputDecoration(
//               hintText: 'Share your experience with this product...',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               fillColor: Colors.white,
//               filled: true,
//             ),
//           ),

//           // Expanded(
//           //   child: TextField(
//           //     controller: _controller,
//           //     maxLines: 3,
//           //     expands: true,
//           //     decoration: InputDecoration(
//           //       hintText: 'Share your experience with this product...',
//           //       border: OutlineInputBorder(
//           //         borderRadius: BorderRadius.circular(12),
//           //       ),
//           //       fillColor: Colors.white,
//           //       filled: true,
//           //     ),
//           //   ),
//           // ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: _submitting
//                       ? null
//                       : () => Navigator.of(context).pop(),
//                   child: const Text('Cancel'),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: CustomButton(
//                   onPressed: _submitting ? null : () => _submit(context),
//                   label: _submitting ? 'Submitting...' : 'Submit Review',
//                   backgroundColor: const Color(0xFFD8B384),
//                   loading: _submitting,
//                   loadingChild: Shimmer.fromColors(
//                     baseColor: Colors.white70,
//                     highlightColor: Colors.white,
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: const [
//                         Icon(Icons.auto_awesome, color: Colors.white),
//                         SizedBox(width: 8),
//                         Text('Submitting...', style: TextStyle(color: Colors.white)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _submit(BuildContext context) async {
//     if (_rating == 0) {
//       _showError('Please select a rating');
//       return;
//     }
//     if (_controller.text.trim().isEmpty) {
//       _showError('Please write your review');
//       return;
//     }

//     setState(() => _submitting = true);
//     final vm = context.read<ReviewViewModel>();

//     try {
//       await vm.submitReview(widget.productId, _controller.text.trim(), _rating);

//       // Refresh product detail so latest reviews/aggregates appear.
//       await context.read<ProductViewModel>().load(widget.productId);

//       if (!mounted) return;

//       // Close sheet with a success result; parent will show Flushbar
//       Navigator.of(context).pop('review_success');
//     } catch (e) {
//       if (!mounted) return;
//       _showFlushbar(
//         context,
//         message: e.toString(),
//         color: Colors.red.shade600,
//       );
//     } finally {
//       if (mounted) setState(() => _submitting = false);
//     }
//   }

//   // Future<void> _submit(BuildContext context) async {
//   //   if (_rating == 0) {
//   //     _showError('Please select a rating');
//   //     return;
//   //   }
//   //   if (_controller.text.trim().isEmpty) {
//   //     _showError('Please write your review');
//   //     return;
//   //   }

//   //   setState(() => _submitting = true);
//   //   final vm = context.read<ReviewViewModel>();
//   //   try {
//   //     await vm.submitReview(
//   //       vm.reviews!.reviews[0].productid,
//   //       _controller.text.trim(),
//   //       _rating,
//   //     );
//   //     // await vm.submitReview(_author, _controller.text.trim(), _rating);
//   //     Navigator.of(context).pop();
//   //     // show success snackbar
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(const SnackBar(content: Text('Review submitted')));
//   //   } catch (e) {
//   //     _showError(e.toString());
//   //   } finally {
//   //     if (mounted) setState(() => _submitting = false);
//   //   }
//   // }

//   void _showError(String msg) {
//     _showFlushbar(
//       context,
//       message: msg,
//       color: Colors.red.shade600,
//     );
//   }

//   void _showFlushbar(BuildContext context,
//       {required String message, required Color color}) {
//     Flushbar(
//       message: message,
//       backgroundColor: color,
//       duration: const Duration(seconds: 2),
//       margin: const EdgeInsets.all(12),
//       borderRadius: BorderRadius.circular(12),
//     ).show(context);
//   }
// }

import 'package:flutter/material.dart';
import 'package:haqmate/features/product_detail/viewmodel/product_viewmodel.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/startInpute.dart';
import 'package:provider/provider.dart';
import 'package:haqmate/core/widgets/custom_button.dart';
import 'package:haqmate/core/constants.dart';

class WriteReviewSheet extends StatefulWidget {
  final String productId;
  const WriteReviewSheet({Key? key, required this.productId}) : super(key: key);

  @override
  State<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends State<WriteReviewSheet> {
  int _rating = 0;
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            'ግምገማ ይጻፉ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),

          // Rating
          Text(
            'ደረጃ ይስጡ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          StarInput(
            value: _rating,
            onChanged: (v) => setState(() => _rating = v),
          ),
          const SizedBox(height: 20),

          // Review text
          Text(
            'ግምገማዎ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'ስለ ምርቱ አስተያየትዎን ይጻፉ...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _submitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: AppColors.primary),
                  ),
                  child: Text(
                    'ሰርዝ',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  onPressed: _submitting ? null : () => _submit(context),
                  label: _submitting ? 'በመላክ ላይ...' : 'ላክ',
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  loading: _submitting,
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  icon: _submitting
                      ? null
                      : const Icon(Icons.send_outlined, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    if (_rating == 0) {
      _showError('እባክዎ ደረጃ ይስጡ');
      return;
    }
    if (_controller.text.trim().isEmpty) {
      _showError('እባክዎ ግምገማዎን ይጻፉ');
      return;
    }

    setState(() => _submitting = true);
    final reviewVm = context.read<ReviewViewModel>();
    final productVm = context.read<ProductViewModel>();

    try {
      await reviewVm.submitReview(
        widget.productId,
        _controller.text.trim(),
        _rating,
      );

      // Refresh both product and reviews
      await Future.wait([
        productVm.load(widget.productId),
        reviewVm.loadReviews(widget.productId, refresh: true),
      ]);

      if (!mounted) return;
      Navigator.of(context).pop('review_success');
    } catch (e) {
      if (!mounted) return;
       Navigator.of(context).pop();
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

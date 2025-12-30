import 'package:flutter/material.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/review_list.dart';
import 'package:haqmate/features/review/widget/review_summery_card.dart';
import 'package:haqmate/features/review/widget/write_review.dart';
import 'package:provider/provider.dart';

class ReviewsPage extends StatefulWidget {
  final String productid;
  const ReviewsPage({super.key, required this.productid});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  void initState() {
    super.initState();
    print('product id in detail page in review : ${widget.productid}');
    // Run AFTER the first frame so notifyListeners is safe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewViewModel>().loadReviews(widget.productid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReviewViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7B4B27)),
          onPressed: () {
            // back
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Reviews & Ratings',
          style: TextStyle(color: Color(0xFF7B4B27)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: vm.loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // const SizedBox(height: 8),
                    ReviewSummaryCard(productId: widget.productid),
                    const SizedBox(height: 12),
                    Expanded(child: ReviewsList()),
                  ],
                ),
              ),
      ),
      /*   floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openWriteReviewSheet(context),
        backgroundColor: const Color(0xFFD8B384),
        label: const Text(
          'Write a Review',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ), */
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

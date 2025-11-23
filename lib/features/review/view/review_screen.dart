import 'package:flutter/material.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/review_list.dart';
import 'package:haqmate/features/review/widget/review_summery_card.dart';
import 'package:haqmate/features/review/widget/write_review.dart';
import 'package:provider/provider.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReviewViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7B4B27)),
          onPressed: () {},
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
                    const SizedBox(height: 8),
                    ReviewSummaryCard(),
                    const SizedBox(height: 12),
                    Expanded(child: ReviewsList()),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openWriteReviewSheet(context),
        backgroundColor: const Color(0xFFD8B384),
        label: const Text(
          'Write a Review',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

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
}

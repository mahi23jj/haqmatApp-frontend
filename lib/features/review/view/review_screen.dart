
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/loading_state.dart';
import 'package:haqmate/features/review/viewmodel/review_view_model.dart';
import 'package:haqmate/features/review/widget/review_list.dart';
import 'package:haqmate/features/review/widget/review_summery_card.dart';
import 'package:haqmate/features/review/widget/write_review.dart';
import 'package:provider/provider.dart';
import 'package:haqmate/core/widgets/custom_button.dart';

class ReviewsPage extends StatefulWidget {
  final String productId;
  const ReviewsPage({super.key, required this.productId});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late final ScrollController _scrollController;
  Timer? _scrollDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewViewModel>().loadReviews(widget.productId, refresh: true);
    });
  }

  @override
  void dispose() {
    _scrollDebounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _scrollDebounce?.cancel();
      _scrollDebounce = Timer(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        context.read<ReviewViewModel>().loadMoreReviews(widget.productId);
      });
    }
  }

  void _openWriteReviewSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (ctx) => Padding(
        padding: MediaQuery.of(ctx).viewInsets,
        child: WriteReviewSheet(productId: widget.productId),
      ),
    );

    if (result == 'review_success' && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ግምገማ ተልኳል!'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      // Reload reviews after submission
      context.read<ReviewViewModel>().loadReviews(widget.productId, refresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReviewViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'ግምገማዎች እና ደረጃዎች',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!vm.loading && vm.error == null)
            IconButton(
              icon: Icon(Icons.refresh, color: AppColors.primary),
              onPressed: () => vm.loadReviews(widget.productId, refresh: true),
            ),
        ],
      ),
      body: _buildBody(context, vm),
      floatingActionButton: !vm.loading && vm.error == null && vm.reviews != null
          ? FloatingActionButton.extended(
              onPressed: () => _openWriteReviewSheet(context),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('ግምገማ ይጻፉ'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(BuildContext context, ReviewViewModel vm) {
    if (vm.loading && vm.reviews == null) {
      return const LoadingState();
    }

    if (vm.error != null && vm.reviews == null) {
      return _buildErrorState(vm);
    }

    if (vm.reviews == null || vm.reviews!.reviews.isEmpty) {
      return _buildEmptyState(vm);
    }

    return _buildSuccessState(context, vm);
  }



  Widget _buildErrorState(ReviewViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.accent,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'አልተሳካም!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
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
            const SizedBox(height: 24),
            CustomButton(
              label: 'እንደገና ይሞክሩ',
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () => vm.loadReviews(widget.productId, refresh: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ReviewViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.reviews_outlined,
              color: AppColors.textLight,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              'ምንም ግምገማ የለም',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
            const SizedBox(height: 24),
            CustomButton(
              label: 'ግምገማ ይጻፉ',
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              onPressed: () => _openWriteReviewSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context, ReviewViewModel vm) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Review Summary Card
          ReviewSummaryCard(productId: widget.productId),
          
          const SizedBox(height: 12),
          
          // Review Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${vm.reviews!.reviews.length} ግምገማ${vm.reviews!.reviews.length == 1 ? '' : 'ዎች'}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const Spacer(),
                Text(
                  'አማካኝ: ${vm.reviews!.averageRating.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Reviews List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ReviewsList(),
          ),

          const SizedBox(height: 16),
          _buildLoadMoreSection(vm),
          
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildLoadMoreSection(ReviewViewModel vm) {
    if (vm.loadingMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      );
    }

    if (vm.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomButton(
          label: 'እንደገና ይሞክሩ',
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          onPressed: () => vm.loadMoreReviews(widget.productId),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
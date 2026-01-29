import 'package:flutter/material.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:haqmate/features/review/model/review_model.dart';
import 'package:haqmate/features/review/service/review_service.dart';

class ReviewViewModel extends ChangeNotifier {
  final ReviewService repository;
  ReviewList? reviews;
  String? successMessage;
  bool loading = false;
  String? error;

  Product? product;

  ReviewViewModel({required this.repository});

  Future<void> loadReviews(String productid) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final data = await repository.fetchReviews(productid);
      print('loaded reviews: $data');
      reviews = data;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      print('error in review viewmodel: $error');
    }
    loading = false;
    notifyListeners();
  }

  //rating counts
  Map<int, int> get ratingCounts {
    final Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    if (reviews != null) {
      for (var review in reviews!.reviews) {
        counts[review.rating] = (counts[review.rating] ?? 0) + 1;
      }
    }
    return counts;
  }

  Future<void> submitReview(String productid, String text, int rating) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      // Immediately add locally for instant UI update
      final newReview = Review(
        id: "local-${DateTime.now().millisecondsSinceEpoch}", // temporary ID
        productid: productid,
        author: 'you',
        text: text,
        rating: rating,
        date: DateTime.now(),
      );

      addMyReview(newReview);

      
      final data = await repository.submitReview(productid, text, rating);


      successMessage = data;
      print('submitted review: $successMessage');
      notifyListeners();
    } catch (e) {
      loading = false;
      notifyListeners();
      error = e.toString();
      print('error in submit review viewmodel: $error');
      throw e; // ← Let UI catch real message
    }

    loading = false;
    notifyListeners();
    // Basic validation
  }

  void addMyReview(Review review) {
    if (product == null) return;

    product = product!.copyWith(myReview: review);

    notifyListeners();
  }
}

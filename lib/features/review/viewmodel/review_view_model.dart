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

  int _currentPage = 1;
  final int _pageSize = 5;
  bool _hasMore = true;
  bool _loadingMore = false;
  String? _loadMoreError;

  Product? product;

  ReviewViewModel({required this.repository});

  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get loadingMore => _loadingMore;
  String? get loadMoreError => _loadMoreError;

  Future<void> loadReviews(String productid, {bool refresh = false}) async {
    loading = true;
    error = null;
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _loadMoreError = null;
    }
    notifyListeners();
    try {
      final data = await repository.fetchReviews(
        productid,
        page: 1,
        limit: _pageSize,
      );
      print('loaded reviews: $data');
      reviews = data;
      _currentPage = 1;
      if (data.totalCount > 0) {
        _hasMore = data.reviews.length < data.totalCount;
      } else {
        _hasMore = data.reviews.length == _pageSize;
      }
      notifyListeners();
    } catch (e) {
      error = e.toString();
      print('error in review viewmodel: $error');
    }
    loading = false;
    notifyListeners();
  }

  Future<void> loadMoreReviews(String productid) async {
    if (loading || _loadingMore || !_hasMore) return;
    _loadingMore = true;
    _loadMoreError = null;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final data = await repository.fetchReviews(
        productid,
        page: nextPage,
        limit: _pageSize,
      );
      final current = reviews?.reviews ?? [];
      final merged = [...current, ...data.reviews];
      reviews = ReviewList(
        reviews: merged,
        totalCount: data.totalCount,
        averageRating: data.averageRating,
      );
      _currentPage = nextPage;
      if (data.totalCount > 0) {
        _hasMore = merged.length < data.totalCount;
      } else {
        _hasMore = data.reviews.length == _pageSize;
      }
    } catch (e) {
      _loadMoreError = e.toString();
      print('error in load more reviews: $_loadMoreError');
    }

    _loadingMore = false;
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

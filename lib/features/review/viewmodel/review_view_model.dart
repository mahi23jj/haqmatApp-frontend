import 'package:flutter/material.dart';
import 'package:haqmate/features/review/model/review_model.dart';
import 'package:haqmate/features/review/service/review_service.dart';

class ReviewViewModel extends ChangeNotifier {
  final ReviewRepository repository;
  List<Review> reviews = [];
  bool loading = false;
  String? error;

  // For UI binding
  int averageRating = 0;
  Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  ReviewViewModel({required this.repository});

  Future<void> loadReviews() async {
    loading = true;
    notifyListeners();
    try {
      final data = await repository.getReviews();
      reviews = data;
      _recalculateStats();
      error = null;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> submitReview(String author, String text, int rating) async {
    // Basic validation
    if (text.trim().isEmpty) throw Exception('Review text is required');
    if (rating < 1 || rating > 5) throw Exception('Rating must be 1..5');

    // optimistic UI: add a temporary review to list
    final temp = Review(
      id: 'temp-\${DateTime.now().millisecondsSinceEpoch}',
      author: author,
      text: text,
      rating: rating,
      date: DateTime.now(),
      verified: false,
    );
    reviews.insert(0, temp);
    _recalculateStats();
    notifyListeners();

    try {
      final saved = await repository.addReview(author, text, rating);
      // replace temp with saved
      final idx = reviews.indexWhere((r) => r.id == temp.id);
      if (idx != -1) reviews[idx] = saved;
      _recalculateStats();
      notifyListeners();
    } catch (e) {
      // rollback optimistic update
      reviews.removeWhere((r) => r.id == temp.id);
      _recalculateStats();
      notifyListeners();
      rethrow;
    }
  }

  void _recalculateStats() {
    if (reviews.isEmpty) {
      averageRating = 0;
      ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      return;
    }
    int total = 0;
    int count = reviews.length;
    ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (var r in reviews) {
      total += r.rating;
      ratingCounts[r.rating] = (ratingCounts[r.rating] ?? 0) + 1;
    }
    averageRating = (total / count).round();
  }
}

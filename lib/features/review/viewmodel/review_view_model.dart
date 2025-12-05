import 'package:flutter/material.dart';
import 'package:haqmate/features/review/model/review_model.dart';
import 'package:haqmate/features/review/service/review_service.dart';

class ReviewViewModel extends ChangeNotifier {
  final ReviewService repository;
  ReviewList? reviews;
  String? successMessage;
  bool loading = false;
  String? error;

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

  Future<void> submitReview(String productid, String text, int rating) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
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
}

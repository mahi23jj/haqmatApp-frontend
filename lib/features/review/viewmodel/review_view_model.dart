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
    notifyListeners();
    try {
      final data = await repository.fetchReviews(productid);
      reviews = data;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<void> submitReview(String productid, String text, int rating) async {
    loading = true;
    notifyListeners();
    try {
      final data = await repository.submitReview(productid, text, rating);
      successMessage = data;
      error = null;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
    // Basic validation
  }
}

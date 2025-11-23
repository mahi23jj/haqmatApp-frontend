import 'dart:math';

import 'package:haqmate/features/review/model/review_model.dart';

abstract class ReviewService {
  Future<List<Review>> fetchReviews({int page = 1, int pageSize = 20});
  Future<Review> submitReview(String author, String text, int rating);
}

// Fake implementation for local testing. Replace with a real HTTP client later.
class FakeReviewService implements ReviewService {
  final Random _rnd = Random();
  final List<Review> _data = List.generate(
    4,
    (i) => Review(
      id: 'r\$i',
      author: ['Alem Tesfaye', 'Marta Kebede', 'Tsehay', 'Samuel'][i % 4],
      text: [
        'Excellent quality teff! The grain is very clean and makes perfect injera. Will definitely order again.',
        'Good price and fast delivery. Very satisfied.',
        'Nice grain, but packaging could be better.',
        'Perfect for family use.',
      ][i % 4],
      rating: [5, 5, 4, 5][i % 4],
      date: DateTime.now().subtract(Duration(days: i * 10)),
      verified: i % 2 == 0,
    ),
  );

  @override
  Future<List<Review>> fetchReviews({int page = 1, int pageSize = 20}) async {
    // Simulate network latency
    await Future.delayed(Duration(milliseconds: 500 + _rnd.nextInt(300)));
    return List<Review>.from(_data.reversed);
  }

  @override
  Future<Review> submitReview(String author, String text, int rating) async {
    await Future.delayed(Duration(milliseconds: 700));
    final review = Review(
      id: 'r\${DateTime.now().millisecondsSinceEpoch}',
      author: author,
      text: text,
      rating: rating,
      date: DateTime.now(),
      verified: true,
    );
    _data.add(review);
    return review;
  }
}

// -----------------------------
// Repository (thin wrapper in front of service)
// -----------------------------
class ReviewRepository {
  final ReviewService service;
  ReviewRepository({required this.service});

  Future<List<Review>> getReviews({int page = 1, int pageSize = 20}) =>
      service.fetchReviews(page: page, pageSize: pageSize);

  Future<Review> addReview(String author, String text, int rating) =>
      service.submitReview(author, text, rating);
}

import 'dart:convert';
import 'dart:math';

import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:haqmate/features/review/model/review_model.dart';
import 'package:http/http.dart' as Http;

// Fake implementation for local testing. Replace with a real HTTP client later.
class ReviewService {
  // get token from local storage

  Future<ReviewList> fetchReviews(String productid) async {
    String? token = await getToken();
    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}/api/feedback/$productid'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // If API returns { "data": [...] }
        final feedbacksJson = body["data"] ?? body;

        final feedbacks = ReviewList.fromJson(feedbacksJson);
        print('fetched reviews: $feedbacks');

        return feedbacks;
      } else {
        final body = jsonDecode(response.body);
        print('body: $body');
        final message = ErrorParser.parse(body);
        print(message);
        throw Exception(message);
      }
    } catch (e) {
      print('error in review service: $e');
      throw Exception('Login error: $e');
    }
  }


  Future<String> submitReview(String productid, String text, int rating) async {
    String? token = await getToken();

    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}/api/feedback'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "productId": productid,
          "message": text,
          "rating": rating,
        }),
      );

      if (response.statusCode == 201) {
        return 'Review submitted successfully';
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        print('message: $message');
        throw Exception(message);
      }
    } catch (e) {
      print('error in submit review service: $e');
      throw Exception(e.toString()); // ← correct
    }
  }
}

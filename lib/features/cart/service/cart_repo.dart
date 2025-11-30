import 'dart:convert';
import 'dart:math';

import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:haqmate/features/review/model/review_model.dart';
import 'package:http/http.dart' as Http;

// Fake implementation for local testing. Replace with a real HTTP client later.
class CartService {
  // get token from local storage

  Future<ReviewList> fetchs(String productid) async {
    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}api/feedback/$productid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // If API returns { "data": [...] }
        final feedbacksJson = body["data"] ?? body;

        final feedbacks = ReviewList.fromJson(feedbacksJson);

        return feedbacks;
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Simulate network latency
  /*  await Future.delayed(Duration(milliseconds: 500 + _rnd.nextInt(300)));
    return List<Review>.from(_data.reversed); */

  Future<String> submitReview(String productid, String text, int rating) async {
    String? token = await getToken();

    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}api/feedback'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        },
        body: jsonEncode({
          "productId": productid,
          "message": text,
          "rating": rating,
        }),
      );

      if (response.statusCode == 200) {
        // final body = jsonDecode(response.body);

        return 'Review submitted successfully';
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
}



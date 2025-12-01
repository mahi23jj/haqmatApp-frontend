import 'dart:convert';
import 'dart:math';

import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/review/model/review_model.dart';
import 'package:http/http.dart' as Http;

// Fake implementation for local testing. Replace with a real HTTP client later.
class CartService {
  // get token from local storage

  Future<CartModelList> fetchcart() async {
    String? token = await getToken();

    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}api/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        final cartJson = body["data"] ?? body;

        final carts = CartModelList.fromJson(cartJson);
            
        return carts;
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

  Future<String> addcart(String productid, int quantity , int packagingsize) async {
    String? token = await getToken();

    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}api/cart/add_update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "productId": productid,
          "quantity": quantity,
          "packagingsize": packagingsize,
        }),
      );

      if (response.statusCode == 200) {
        // final body = jsonDecode(response.body);

        return response.body;
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }



  Future<String> updatecartquanty(String productid, int quantity , int packagingsize) async {
    String? token = await getToken();

    try {
      final response = await Http.put(
        Uri.parse('${Constants.baseurl}api/cart/quantity_update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "productId": productid,
          "quantity": quantity,
          "packagingsize": packagingsize,
        }),
      );

      if (response.statusCode == 200) {
        // final body = jsonDecode(response.body);

        return response.body;
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

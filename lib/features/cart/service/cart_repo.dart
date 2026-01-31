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

  Future<CartModelList> fetchcart(
    {
    int page = 1,
    int limit = 10,
  }
  ) async {
    String? token = await getToken();

    print(token);

    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}/api/cart?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('Parsed body: $body');

        final cartJson = body["data"] ?? body;
        print('Cart JSON: $cartJson');

        final carts = CartModelList.fromJson(cartJson);
        return carts;
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e, stackTrace) {
      print('Error details: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Login error: $e');
    }

    // try {
    //   final response = await Http.get(
    //     Uri.parse('${Constants.baseurl}/api/cart'),
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Authorization': 'Bearer $token',
    //     },
    //   );

    //   print(response.body);

    //   if (response.statusCode == 200) {
    //     final body = jsonDecode(response.body);

    //     final cartJson = body["data"] ?? body;

    //     final carts = CartModelList.fromJson(cartJson);

    //     return carts;
    //   } else {
    //     final body = jsonDecode(response.body);
    //     final message = ErrorParser.parse(body);
    //     throw Exception(message);
    //   }
    // } catch (e) {
    //   throw Exception('Login error: $e');
    // }
  }

  // Simulate network latency
  /*  await Future.delayed(Duration(milliseconds: 500 + _rnd.nextInt(300)));
    return List<Review>.from(_data.reversed); */

  Future<String> addcart(
    String productid,
    int quantity,
    int packagingsize,
  ) async {
    String? token = await getToken();

    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}/api/cart/add'),
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

        print('cart: $response.body');

        return response.body;
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('error: $e');
    }
  }

  Future<String> updatecartquanty(
    String productid,
    int quantity,
    int packagingsize,
  ) async {
    String? token = await getToken();

    try {
      final response = await Http.put(
        Uri.parse('${Constants.baseurl}/api/cart/quantity_update'),
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

  Future<String> updatecart(
    String id,
    String? productid,
    int? quantity,
    int? packagingsize,
  ) async {
    String? token = await getToken();

    try {
      final response = await Http.put(
        Uri.parse('${Constants.baseurl}/api/cart/update/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "updatedproductid": productid,
          "updatedquantity": quantity,
          "updatedpackagingsize": packagingsize,
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

  Future<void> removeFromCart(String cartId) async {
    final token = await getToken();

    try {
      final response = await Http.delete(
        Uri.parse('${Constants.baseurl}/api/cart/$cartId/remove'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
}

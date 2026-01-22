// checkout_service.dart
import 'dart:convert';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/checkout/model/checkout_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as Http;

class CheckoutService {
  /// Search locations while typing: GET /locations?query=:q
  Future<List<LocationModel>> searchLocations(String query) async {
    print('searching locations for query: $query');
    final uri = Uri.parse(
      '${Constants.baseurl}/api/delivery/location?query=${Uri.encodeComponent(query)}',
    );

    print('uri $uri');

    final resp = await http.get(uri);

    if (resp.statusCode == 200) {
      final jsonBody = json.decode(resp.body);

      final list = jsonBody["data"] as List? ?? [];

      print('location $list');

      return list
          .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Location search failed: ${resp.statusCode}');
    }
  }

  Future<String> updateuserstatus(String locationid, String phoneNumber) async {
    String? token = await getToken();

    print(
      'updating user status with phone number: $phoneNumber and location id: $locationid',
    );

    try {
      final response = await Http.put(
        Uri.parse('${Constants.baseurl}/api/user/update-status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"phoneNumber": phoneNumber, "location": locationid}),
      );

      print('update user status ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('update error: $e');
    }
  }

  Future<PaymentIntentModel> pay({
    required List<Map<String, dynamic>> products,
    required String location,
    required String phoneNumber,
    required String orderReceived,
    required String paymentMethod,
  }) async {
    String? token = await getToken();

    // Generate an idempotency key per attempt to satisfy backend validation
    final idempotencyKey = DateTime.now().millisecondsSinceEpoch.toString();

    print(
      'created order 2 $products, $location, $phoneNumber, $orderReceived, $paymentMethod',
    );

    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}/api/pay'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "products": products,
          "location": location,
          "phoneNumber": phoneNumber,
          "orderRecived": orderReceived,
          "paymentMethod": paymentMethod,
          "idempotencyKey": idempotencyKey,
          "metadata": {"idempotencyKey": idempotencyKey},
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print("Full Response: $responseBody");

        // Check if response has status and data keys
        if (responseBody['status'] == 'success' &&
            responseBody['data'] != null) {
          // Extract the payment intent data from the 'data' field
          final paymentData = responseBody['data'];

          final paymentIntent = PaymentIntentModel.fromJson(paymentData);
          print("ORDER CREATED: ${paymentIntent}");
          return paymentIntent;
        } else {
          // If the structure is different, try to parse the whole response
          try {
            final paymentIntent = PaymentIntentModel.fromJson(responseBody);
            return paymentIntent;
          } catch (e) {
            throw Exception("Invalid response format: ${e.toString()}");
          }
        }
      } else {
        final body = jsonDecode(response.body);
        print("Error Response: $body");
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      print("Exception in pay method: $e");
      throw Exception("Order creation failed: $e");
    }
  }

  // Future<PaymentIntentModel> pay({
  //   required List<Map<String, dynamic>> products,
  //   required String location,
  //   required String phoneNumber,
  //   required String orderReceived,
  //   required String paymentMethod,
  // }) async {
  //   String? token = await getToken();

  //   print(
  //     'created order 2 $products, $location, $phoneNumber, $orderReceived, $paymentMethod',
  //   );

  //   try {
  //     final response = await Http.post(
  //       Uri.parse('${Constants.baseurl}/api/pay'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         "products": products,
  //         "location": location,
  //         "phoneNumber": phoneNumber,
  //         "orderRecived": orderReceived,
  //         "paymentMethod": paymentMethod,
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       final responseBody = jsonDecode(response.body);

  //      final responses = responseBody['data'];

  //       final paymentIntent = PaymentIntentModel.fromJson(responses);

  //       print("ORDER CREATED: ${paymentIntent}");
  //       return paymentIntent;
  //     } else {
  //       final body = jsonDecode(response.body);
  //       print(body);
  //       final message = ErrorParser.parse(body);
  //       throw Exception(message);
  //     }
  //   } catch (e) {
  //     throw Exception("Order creation failed: $e");
  //   }
  // }

  // Future<PaymentIntentResponse> createChapaIntent({
  //   required String orderId,
  //   required String currency,
  //   required String email,
  //   required String firstName,
  //   required String lastName,
  // }) async {
  //   final url = Uri.parse("${Constants.baseurl}/intents");

  //   final body = {
  //     "orderId": orderId,
  //     "currency": currency,
  //     "metadata": {
  //       "email": email,
  //       "firstName": firstName,
  //       "lastName": lastName,
  //     }
  //   };

  //   final res = await http.post(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //     },
  //     body: jsonEncode(body),
  //   );

  //   if (res.statusCode != 201) {
  //     throw Exception("Failed to create Chapa Intent: ${res.body}");
  //   }

  //   return PaymentIntentResponse.fromJson(jsonDecode(res.body));
  // }
  // u

  /// Place order: POST /orders/create
  /* Future<Map<String, dynamic>> placeOrder({
    required String userId,
    required LocationModel location,
    required String phoneNumber,
    required List<OrderItem> items,
    required int deliveryFee,
    required int subtotal,
    required int total,
    required bool saveAsDefault,
  }) async {
    final uri = Uri.parse('$baseUrl/orders/create');
    final body = {
      'userId': userId,
      'locationId': location.id,
      'phoneNumber': phoneNumber,
      'items': items.map((i) => i.toOrderJson()).toList(),
      'deliveryFee': deliveryFee,
      'subtotalPrice': subtotal,
      'totalPrice': total,
      'saveAsDefault': saveAsDefault,
    };

    final resp = await http.post(uri,
        headers: {'Content-Type': 'application/json'}, body: json.encode(body));

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return json.decode(resp.body) as Map<String, dynamic>;
    } else {
      final msg = resp.body.isNotEmpty ? resp.body : resp.statusCode.toString();
      throw Exception('Failed to create order: $msg');
    }
  } */
}

import 'dart:convert';

import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:http/http.dart' as Http;

class OrdersRepository {
  Future<void> cancelOrder(String orderId) async {
    final token = await getToken();
    try {
      final response = await Http.patch(
        Uri.parse('${Constants.baseurl}/api/order/$orderId/cancel'),
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
      throw Exception('Cancel error: $e');
    }
  }

  Future<void> requestRefund({
    required String orderId,
    required String accountName,
    required String accountNumber,
    required String reason,
  }) async {
    final token = await getToken();
    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}/api/pay/orders/$orderId/refund'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'accountName': accountName,
          'accountNumber': accountNumber,
          'reason': reason,
        }),
      );

      if (response.statusCode != 200) {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Refund error: $e');
    }
  }

  Future<List<OrderModel>> fetchOrders() async {
    String? token = await getToken();

    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}/api/order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(body);

        // If API returns { "data": [...] }
        final productsJson = body["data"] ?? body;

        if (productsJson is! List) {
          throw Exception("Invalid data format");
        }

        final orders = productsJson
            .map<OrderModel>((json) => OrderModel.fromJson(json))
            .toList();

        print(orders);

        return orders;
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

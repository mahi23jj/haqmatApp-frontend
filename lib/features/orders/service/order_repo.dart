import 'dart:convert';

import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:http/http.dart' as Http;

class OrdersRepository {
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



  /* Future<List<OrderItem>> fetchOrders() async {
    await Future.delayed(Duration(milliseconds: 800));

    return [
      OrderItem(
        id: "TF2024-1189",
        amount: 5400,
        stage: 4,
        status: "Delivered",
        date: DateTime(2025, 10, 28),
        imageUrls: [
          "assets/images/teff.jpg",
          "assets/images/injera.jpg",
        ],
      ),
      OrderItem(
        id: "TF2024-0945",
        amount: 2700,
        stage: 1,
        status: "Pending",
        date: DateTime(2025, 10, 2),
        imageUrls: [
          "assets/images/teff.jpg",
        ],
      )
    ];
  }
 */
}

// checkout_service.dart
import 'dart:convert';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:http/http.dart' as http;


class CheckoutService {


 

  /// Search locations while typing: GET /locations?query=:q
  Future<List<LocationModel>> searchLocations(String query) async {
    final uri = Uri.parse('${Constants.baseurl}/locations?query=${Uri.encodeComponent(query)}');
    final resp = await http.get(uri);

    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      if (data is List) {
        return data.map((e) => LocationModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        // handle object with items
        final list = data['results'] as List? ?? [];
        return list.map((e) => LocationModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } else {
      throw Exception('Failed to search locations: ${resp.statusCode}');
    }
  }

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

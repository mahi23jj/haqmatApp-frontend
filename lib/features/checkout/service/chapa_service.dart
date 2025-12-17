// import 'dart:convert';
// import 'package:haqmate/core/constants.dart';
// import 'package:haqmate/features/checkout/model/checkout_model.dart';
// import 'package:http/http.dart' as http;

// class PaymentService {
//   final String baseURL = "http://localhost:3000/api/payment";
  

//   Future<PaymentIntentResponse> createChapaIntent({
//     required String orderId,
//     required String currency,
//   }) async {
//     final url = Uri.parse("$baseURL/intents");
//      String? token = await getToken();
    

//     final body = {
//       "orderId": orderId,
//       "currency": currency,
//       "metadata": {
//       }
//     };

//     final res = await http.post(
//       url,
//       headers: {
//         "Content-Type": "application/json",
//          'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(body),
//     );

//     if (res.statusCode != 201) {
//       throw Exception("Failed to create Chapa Intent: ${res.body}");
//     }

//     return PaymentIntentResponse.fromJson(jsonDecode(res.body));
//   }
// }

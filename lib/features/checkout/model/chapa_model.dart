// class PaymentIntentResponse {
//   final String id;
//   final String clientSecret;
//   final String status;
//   final num amount;
//   final String currency;
//   final Map<String, dynamic> metadata;
//   final String createdAt;

//   PaymentIntentResponse({
//     required this.id,
//     required this.clientSecret,
//     required this.status,
//     required this.amount,
//     required this.currency,
//     required this.metadata,
//     required this.createdAt,
//   });

//   factory PaymentIntentResponse.fromJson(Map<String, dynamic> json) {
//     return PaymentIntentResponse(
//       id: json['id'],
//       clientSecret: json['clientSecret'] ?? "",
//       status: json['status'],
//       amount: json['amount'],
//       currency: json['currency'],
//       metadata: json['metadata'] ?? {},
//       createdAt: json['created_at'],
//     );
//   }
// }



// class PaymentResponse {
//   final String id;
//   final String orderId;
//   final String provider;
//   final String providerRef;
//   final num amount;
//   final String status;
//   final String type;
//   final String paymentIntentId;
//   final Map<String, dynamic> rawPayload;
//   final String createdAt;

//   PaymentResponse({
//     required this.id,
//     required this.orderId,
//     required this.provider,
//     required this.providerRef,
//     required this.amount,
//     required this.status,
//     required this.type,
//     required this.paymentIntentId,
//     required this.rawPayload,
//     required this.createdAt,
//   });

//   factory PaymentResponse.fromJson(Map<String, dynamic> json) {
//     return PaymentResponse(
//       id: json['id'],
//       orderId: json['orderId'],
//       provider: json['provider'],
//       providerRef: json['providerRef'],
//       amount: json['amount'],
//       status: json['status'],
//       type: json['type'],
//       paymentIntentId: json['paymentIntentId'],
//       rawPayload: json['rawPayload'] ?? {},
//       createdAt: json['createdAt'],
//     );
//   }
// }


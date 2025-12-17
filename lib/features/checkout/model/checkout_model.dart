class Address {
  final String location;
  final String detail;

  Address({required this.location, required this.detail});
}

class PaymentMethod {
  final String name;
  final String description;

  PaymentMethod({required this.name, required this.description});
}

class PaymentIntentModel {
  final String id;
  final String clientSecret;
  final String status;
  final double amount;
  final String currency;
  final PaymentMetadata metadata;
  final DateTime createdAt;

  PaymentIntentModel({
    required this.id,
    required this.clientSecret,
    required this.status,
    required this.amount,
    required this.currency,
    required this.metadata,
    required this.createdAt,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      id: json['id'] as String,
      clientSecret: json['clientSecret'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      metadata: PaymentMetadata.fromJson(json['metadata'] ?? {}),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientSecret': clientSecret,
      'status': status,
      'amount': amount,
      'currency': currency,
      'metadata': metadata.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}


class PaymentMetadata {
  final String txRef;
  final String idempotencyKey;

  PaymentMetadata({
    required this.txRef,
    required this.idempotencyKey,
  });

  factory PaymentMetadata.fromJson(Map<String, dynamic> json) {
    return PaymentMetadata(
      txRef: json['txRef'] ?? '',
      idempotencyKey: json['idempotencyKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txRef': txRef,
      'idempotencyKey': idempotencyKey,
    };
  }
}
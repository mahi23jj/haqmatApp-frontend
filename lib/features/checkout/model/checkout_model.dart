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

  final double amount;

  PaymentIntentModel({required this.id, required this.amount});

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    final dynamic totalAmount = json['totalAmount'];
    final dynamic amountField = json['amount'];

    double parsedAmount = 0.0;
    if (totalAmount is num) {
      parsedAmount = totalAmount.toDouble();
    } else if (amountField is num) {
      parsedAmount = amountField.toDouble();
    } else if (amountField is String) {
      parsedAmount = double.tryParse(amountField) ?? 0.0;
    } else if (totalAmount is String) {
      parsedAmount = double.tryParse(totalAmount) ?? 0.0;
    }

    DateTime parsedCreatedAt;
    final dynamic createdAtInput = json['created_at'] ?? json['createdAt'];
    if (createdAtInput is String) {
      parsedCreatedAt = DateTime.tryParse(createdAtInput) ?? DateTime.now();
    } else if (createdAtInput is int) {
      parsedCreatedAt = DateTime.fromMillisecondsSinceEpoch(createdAtInput);
    } else {
      parsedCreatedAt = DateTime.now();
    }

    return PaymentIntentModel(
      id: (json['id'] ?? '').toString(),
      amount: parsedAmount,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'totalAmount': amount};
  }
}

class PaymentMetadata {
  final String txRef;
  final String idempotencyKey;

  PaymentMetadata({required this.txRef, required this.idempotencyKey});

  factory PaymentMetadata.fromJson(Map<String, dynamic> json) {
    return PaymentMetadata(
      txRef: json['txRef'] ?? '',
      idempotencyKey: json['idempotencyKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'txRef': txRef, 'idempotencyKey': idempotencyKey};
  }
}

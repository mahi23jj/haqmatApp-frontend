class OrderItems {
  final String name;
  final int packagingSize;
  final String image;
  final int quantity;
  final double price;

  OrderItems({
    required this.name,
    required this.packagingSize,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    final product = json['product'] as Map<String, dynamic>? ?? {};
    final images = product['images'] as List? ?? [];
    String resolvedImage = '';
    if (images.isNotEmpty) {
      final first = images.first;
      if (first is Map<String, dynamic>) {
        resolvedImage = first['url']?.toString() ?? '';
      } else if (first != null) {
        resolvedImage = first.toString();
      }
    }

    return OrderItems(
      name: product['name']?.toString() ?? '',
      packagingSize: (json['packaging'] as num?)?.toInt() ?? 0,
      image: resolvedImage,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'packaging': packagingSize,
      'image': image,
      'quantity': quantity,
      'price': price,
    };
  }
}

class OrderTrackingStep {
  final String title;
  final String? date;
  final bool completed;

  OrderTrackingStep({
    required this.title,
    this.date,
    required this.completed,
  });

  factory OrderTrackingStep.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timestamp'];

    return OrderTrackingStep(
      title: json['status']?.toString() ?? '',
      date: timestamp?.toString(),
      completed: timestamp != null && timestamp.toString().isNotEmpty,
    );
  }
}


// order_data.dart
class OrderData {
  final String id;
  final String userId;
  final String phoneNumber;
  final String location;
  final int totalAmount;
  final String deliverystatus;
  final String idempotencyKey;
  final String paymentstatus;
  final String refundstatus;
  final String merchOrderId;
  final String orderrecived;
  final String paymentMethod;
  final String cancelReason;
  final String paymentProofUrl;
  final int deliveryFee;
  final String? deliveryDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItems> items;
  final List<OrderTrackingStep> tracking;

  OrderData({
    required this.id,
    required this.userId,
    required this.phoneNumber,
    required this.location,
    required this.totalAmount,
    required this.deliverystatus,
    required this.idempotencyKey,
    required this.paymentstatus,
    required this.refundstatus,
    required this.merchOrderId,
    required this.orderrecived,
    required this.paymentMethod,
    required this.cancelReason,
    required this.paymentProofUrl,
    required this.deliveryFee,
    this.deliveryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.tracking,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(dynamic input) {
      if (input == null) return DateTime.now();
      if (input is String) {
        return DateTime.tryParse(input) ?? DateTime.now();
      }
      if (input is int) {
        return DateTime.fromMillisecondsSinceEpoch(input);
      }
      return DateTime.now();
    }

    return OrderData(
      id: (json['id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      phoneNumber: (json['phoneNumber'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      totalAmount: (json['totalAmount'] as num?)?.toInt() ?? 0,
      deliverystatus: (json['deliverystatus'] ?? '').toString(),
      idempotencyKey: (json['idempotencyKey'] ?? '').toString(),
      paymentstatus: (json['paymentstatus'] ?? '').toString(),
      refundstatus: (json['refundstatus'] ?? '').toString(),
      merchOrderId: (json['merchOrderId'] ?? '').toString(),
      orderrecived: (json['orderrecived'] ?? '').toString(),
      paymentMethod: (json['paymentMethod'] ?? '').toString(),
      deliveryFee: (json['deliveryFee'] as num?)?.toInt() ?? 0,
      cancelReason: (json['cancelReason'] ?? '').toString(),
      paymentProofUrl: (json['paymentProofUrl'] ?? '').toString(),
      deliveryDate: json['deliveryDate']?.toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      items: (json['items'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(OrderItems.fromJson)
          .toList(),
      tracking: (json['tracking'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(OrderTrackingStep.fromJson)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'location': location,
      'totalAmount': totalAmount,
      'deliverystatus': deliverystatus,
      'idempotencyKey': idempotencyKey,
      'paymentstatus': paymentstatus,
      'refundstatus': refundstatus,
      'merchOrderId': merchOrderId,
      'orderrecived': orderrecived,
      'paymentMethod': paymentMethod,
      'deliveryFee': deliveryFee,
      'cancelReason': cancelReason,
      'paymentProofUrl': paymentProofUrl,
      'deliveryDate': deliveryDate,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'tracking': tracking
          .map((e) => {
                'status': e.title,
                'timestamp': e.date,
              })
          .toList(),
    };
  }
}

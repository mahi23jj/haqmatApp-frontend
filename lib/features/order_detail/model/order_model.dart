import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 10)
class OrderItems {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int packagingSize;
  @HiveField(2)
  final String image;
  @HiveField(3)
  final int quantity;
  @HiveField(4)
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

@HiveType(typeId: 11)
class OrderTrackingStep {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String? date;
  @HiveField(2)
  final bool completed;

  OrderTrackingStep({required this.title, this.date, required this.completed});

  factory OrderTrackingStep.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timestamp'];

    return OrderTrackingStep(
      title: json['status']?.toString() ?? '',
      date: timestamp?.toString(),
      completed: timestamp != null && timestamp.toString().isNotEmpty,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': title, 'timestamp': date};
  }
}

@HiveType(typeId: 12)
class OrderData {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final String location;
  @HiveField(4)
  final int totalAmount;
  @HiveField(5)
  final String deliverystatus;
  @HiveField(6)
  final String idempotencyKey;
  @HiveField(7)
  final String paymentstatus;
  @HiveField(8)
  final String refundstatus;
  @HiveField(9)
  final String merchOrderId;
  @HiveField(10)
  final String orderrecived;
  @HiveField(11)
  final String paymentMethod;
  @HiveField(12)
  final String cancelReason;
  @HiveField(13)
  final String paymentProofUrl;
  @HiveField(14)
  final int deliveryFee;
  @HiveField(15)
  final String? deliveryDate;
  @HiveField(16)
  final String status;
  @HiveField(17)
  final DateTime createdAt;
  @HiveField(18)
  final DateTime updatedAt;
  @HiveField(19)
  final List<OrderItems> items;
  @HiveField(20)
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
      'tracking': tracking.map((e) => e.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 13)
enum OrderStatus {
  @HiveField(0)
  PENDING_PAYMENT,
  @HiveField(1)
  TO_BE_DELIVERED,
  @HiveField(2)
  COMPLETED,
  @HiveField(3)
  CANCELLED,
  @HiveField(4)
  UNKNOWN,
}

@HiveType(typeId: 14)
enum PaymentStatus {
  @HiveField(0)
  PENDING,
  @HiveField(1)
  SCREENSHOT_SENT,
  @HiveField(2)
  FAILED,
  @HiveField(3)
  CONFIRMED,
  @HiveField(4)
  DECLINED,
  @HiveField(5)
  REFUNDED,
  @HiveField(6)
  UNKNOWN,
}

@HiveType(typeId: 15)
enum DeliveryStatus {
  @HiveField(0)
  NOT_SCHEDULED,
  @HiveField(1)
  SCHEDULED,
  @HiveField(2)
  DELIVERED,
  @HiveField(3)
  UNKNOWN,
}

@HiveType(typeId: 16)
enum RefundStatus {
  @HiveField(0)
  NOT_STARTED,
  @HiveField(1)
  PENDING,
  @HiveField(2)
  APPROVED,
  @HiveField(3)
  REJECTED,
  @HiveField(4)
  UNKNOWN,
}

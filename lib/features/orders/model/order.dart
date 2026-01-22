import 'package:flutter/foundation.dart';
import 'package:haqmate/features/order_detail/model/order_model.dart';

enum OrderStatus { pendingPayment, toBeDelivered, completed, cancelled, unknown }

enum PaymentStatus {
  pending,
  screenshotSent,
  failed,
  confirmed,
  declined,
  refunded,
  unknown,
}

enum DeliveryStatus { notScheduled, scheduled, delivered, unknown }

enum RefundStatus { notStarted, pending, approved, rejected, unknown }

enum TrackingType {
  paymentSubmitted,
  paymentConfirmed,
  deliveryScheduled,
  confirmed,
  cancelled,
  refunded,
  unknown,
}

class OrderModel {
  final String id;
  final String merchOrderId;
  final String idempotencyKey;
  final String userId;

  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final DeliveryStatus deliveryStatus;

  final double totalAmount;
  final String phoneNumber;

  final String orderReceived; // delivery | pickup
  final String paymentMethod; // chapa | telebirr | screenshot
  final String? paymentProofUrl;
  final String? paymentDeclineReason;

  // final String areaId;

  final int totalDeliveryFee;
  final int extraDeliveryFee;
  final String? extraDistanceLevel;

  final DateTime? deliveryDate;

  final RefundStatus refundStatus;
  final String? cancelReason;
  final double? refundAmount;

  final DateTime createdAt;
  final DateTime updatedAt;

  final List<OrderItems> items;
  final List<OrderTrackingModel> tracking;
  final RefundRequestModel? refundRequest;

  const OrderModel({
    required this.id,
    required this.merchOrderId,
    required this.idempotencyKey,
    required this.userId,
    required this.status,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.totalAmount,
    required this.phoneNumber,
    required this.orderReceived,
    required this.paymentMethod,
    required this.paymentProofUrl,
    required this.paymentDeclineReason,
    // required this.areaId,
    required this.totalDeliveryFee,
    required this.extraDeliveryFee,
    required this.extraDistanceLevel,
    required this.deliveryDate,
    required this.refundStatus,
    required this.cancelReason,
    required this.refundAmount,
    required this.createdAt,
    required this.updatedAt,
    this.items = const [],
    this.tracking = const [],
    this.refundRequest,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? const [];
    final trackingJson = json['tracking'] as List<dynamic>? ?? const [];

    return OrderModel(
      id: _readString(json, ['id']),
      merchOrderId: _readString(json, ['merchOrderId', 'merchantOrderId', 'orderid']),
      idempotencyKey: _readString(json, ['idempotencyKey']),
      userId: _readString(json, ['userId']),
      status: _orderStatusFromJson(json['status']),
      paymentStatus: _paymentStatusFromJson(json['paymentStatus'] ?? json['paymentstatus']),
      deliveryStatus: _deliveryStatusFromJson(json['deliveryStatus'] ?? json['deliverystatus']),
      totalAmount: _readDouble(json, 'totalAmount'),
      phoneNumber: _readString(json, ['phoneNumber', 'phonenumber']),
      orderReceived: _readString(json, ['orderrecived', 'orderReceived']),
      paymentMethod: _readString(json, ['paymentMethod', 'paymentmethod']),
      paymentProofUrl: _readNullableString(json, ['paymentProofUrl', 'paymentproofurl']),
      paymentDeclineReason: _readNullableString(json, ['paymentDeclineReason', 'paymentdeclinereason']),
      // areaId: _readString(json, ['areaId']),
      totalDeliveryFee: _readInt(json, 'totalDeliveryFee'),
      extraDeliveryFee: _readInt(json, 'extraDeliveryFee'),
      extraDistanceLevel: _readNullableString(json, ['extraDistanceLevel']),
      deliveryDate: _parseNullableDate(json['deliveryDate'] ?? json['deliverydate']),
      refundStatus: _refundStatusFromJson(json['refundStatus'] ?? json['refundstatus']),
      cancelReason: _readNullableString(json, ['cancelReason']),
      refundAmount: _readNullableDouble(json, 'refundAmount'),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updatedAt']) ?? DateTime.now(),
      items: itemsJson
          .whereType<Map<String, dynamic>>()
          .map(OrderItems.fromJson)
          .toList(),
      tracking: trackingJson
          .whereType<Map<String, dynamic>>()
          .map(OrderTrackingModel.fromJson)
          .toList(),
      refundRequest: json['refundRequest'] is Map<String, dynamic>
          ? RefundRequestModel.fromJson(json['refundRequest'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchOrderId': merchOrderId,
      'idempotencyKey': idempotencyKey,
      'userId': userId,
      'status': status.asApi,
      'paymentStatus': paymentStatus.asApi,
      'deliveryStatus': deliveryStatus.asApi,
      'totalAmount': totalAmount,
      'phoneNumber': phoneNumber,
      'orderrecived': orderReceived,
      'paymentMethod': paymentMethod,
      'paymentProofUrl': paymentProofUrl,
      'paymentDeclineReason': paymentDeclineReason,
      // 'areaId': areaId,
      'totalDeliveryFee': totalDeliveryFee,
      'extraDeliveryFee': extraDeliveryFee,
      'extraDistanceLevel': extraDistanceLevel,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'refundStatus': refundStatus.asApi,
      'cancelReason': cancelReason,
      'refundAmount': refundAmount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
      'tracking': tracking.map((e) => e.toJson()).toList(),
      'refundRequest': refundRequest?.toJson(),
    };
  }

  // List<String> get imageUrls => items
  //     .expand((e) => e.product.images)
  //     .where((url) => url.isNotEmpty)
  //     .toList();
}

// class OrderItemModel {
//   final String id;
//   final int quantity;
//   final double price;
//   final double packaging;
//   final ProductModel product;

//   const OrderItemModel({
//     required this.id,
//     required this.quantity,
//     required this.price,
//     required this.packaging,
//     required this.product,
//   });

//   factory OrderItemModel.fromJson(Map<String, dynamic> json) {
//     return OrderItemModel(
//       id: _readString(json, ['id']),
//       quantity: _readInt(json, 'quantity'),
//       price: _readDouble(json, 'price'),
//       packaging: _readDouble(json, 'packaging', fallback: _readDouble(json, 'packagingsize')),
//       product: json['product'] is Map<String, dynamic>
//           ? ProductModel.fromJson(json['product'] as Map<String, dynamic>)
//           : const ProductModel(id: '', name: '', images: []),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'quantity': quantity,
//       'price': price,
//       'packaging': packaging,
//       'product': product.toJson(),
//     };
//   }
// }

// class ProductModel {
//   final String id;
//   final String name;
//   final List<String> images;

//   const ProductModel({
//     required this.id,
//     required this.name,
//     required this.images,
//   });

//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     final imagesList = json['images'] as List<dynamic>? ?? const [];
//     return ProductModel(
//       id: _readString(json, ['id']),
//       name: _readString(json, ['name']),
//       images: imagesList
//           .whereType<Map<String, dynamic>>()
//           .map((img) => _readString(img, ['url']))
//           .where((url) => url.isNotEmpty)
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'images': images.map((url) => {'url': url}).toList(),
//     };
//   }
// }

class OrderTrackingModel {
  final String id;
  final String orderId;
  final TrackingType type;
  final String title;
  final String? message;
  final DateTime? timestamp;
  final DateTime createdAt;

  const OrderTrackingModel({
    required this.id,
    required this.orderId,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.createdAt,
  });

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) {
    return OrderTrackingModel(
      id: _readString(json, ['id']),
      orderId: _readString(json, ['orderId', 'orderid']),
      type: _trackingTypeFromJson(json['type']),
      title: _readString(json, ['title']),
      message: _readNullableString(json, ['message']),
      timestamp: _parseNullableDate(json['timestamp']),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'type': type.asApi,
      'title': title,
      'message': message,
      'timestamp': timestamp?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class RefundRequestModel {
  final String id;
  final String orderId;
  final String userId;

  final String accountName;
  final String? accountNumber;
  final String? phoneNumber;
  final String? reason;

  final RefundStatus status;
  final String? adminNote;

  final DateTime createdAt;
  final DateTime updatedAt;

  const RefundRequestModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.accountName,
    required this.accountNumber,
    required this.phoneNumber,
    required this.reason,
    required this.status,
    required this.adminNote,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RefundRequestModel.fromJson(Map<String, dynamic> json) {
    return RefundRequestModel(
      id: _readString(json, ['id']),
      orderId: _readString(json, ['orderId', 'orderid']),
      userId: _readString(json, ['userId']),
      accountName: _readString(json, ['accountName']),
      accountNumber: _readNullableString(json, ['accountNumber']),
      phoneNumber: _readNullableString(json, ['phoneNumber']),
      reason: _readNullableString(json, ['reason']),
      status: _refundStatusFromJson(json['status']),
      adminNote: _readNullableString(json, ['adminNote']),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'userId': userId,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'phoneNumber': phoneNumber,
      'reason': reason,
      'status': status.asApi,
      'adminNote': adminNote,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

extension OrderStatusX on OrderStatus {
  String get asApi {
    switch (this) {
      case OrderStatus.pendingPayment:
        return 'PENDING_PAYMENT';
      case OrderStatus.toBeDelivered:
        return 'TO_BE_DELIVERED';
      case OrderStatus.completed:
        return 'COMPLETED';
      case OrderStatus.cancelled:
        return 'CANCELLED';
      case OrderStatus.unknown:
        return 'UNKNOWN';
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.pendingPayment:
        return 'Pending Payment';
      case OrderStatus.toBeDelivered:
        return 'To Be Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.unknown:
        return 'Unknown';
    }
  }
}

extension PaymentStatusX on PaymentStatus {
  String get asApi {
    switch (this) {
      case PaymentStatus.pending:
        return 'PENDING';
      case PaymentStatus.screenshotSent:
        return 'SCREENSHOT_SENT';
      case PaymentStatus.failed:
        return 'FAILED';
      case PaymentStatus.confirmed:
        return 'CONFIRMED';
      case PaymentStatus.declined:
        return 'DECLINED';
      case PaymentStatus.refunded:
        return 'REFUNDED';
      case PaymentStatus.unknown:
        return 'UNKNOWN';
    }
  }

  String get label {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.screenshotSent:
        return 'Screenshot Sent';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.confirmed:
        return 'Confirmed';
      case PaymentStatus.declined:
        return 'Declined';
      case PaymentStatus.refunded:
        return 'Refunded';
      case PaymentStatus.unknown:
        return 'Unknown';
    }
  }
}

extension DeliveryStatusX on DeliveryStatus {
  String get asApi {
    switch (this) {
      case DeliveryStatus.notScheduled:
        return 'NOT_SCHEDULED';
      case DeliveryStatus.scheduled:
        return 'SCHEDULED';
      case DeliveryStatus.delivered:
        return 'DELIVERED';
      case DeliveryStatus.unknown:
        return 'UNKNOWN';
    }
  }

  String get label {
    switch (this) {
      case DeliveryStatus.notScheduled:
        return 'Not Scheduled';
      case DeliveryStatus.scheduled:
        return 'Scheduled';
      case DeliveryStatus.delivered:
        return 'Delivered';
      case DeliveryStatus.unknown:
        return 'Unknown';
    }
  }
}

extension RefundStatusX on RefundStatus {
  String get asApi {
    switch (this) {
      case RefundStatus.notStarted:
        return 'Not_Started';
      case RefundStatus.pending:
        return 'PENDING';
      case RefundStatus.approved:
        return 'APPROVED';
      case RefundStatus.rejected:
        return 'REJECTED';
      case RefundStatus.unknown:
        return 'UNKNOWN';
    }
  }

  String get label {
    switch (this) {
      case RefundStatus.notStarted:
        return 'Not Started';
      case RefundStatus.pending:
        return 'Pending';
      case RefundStatus.approved:
        return 'Approved';
      case RefundStatus.rejected:
        return 'Rejected';
      case RefundStatus.unknown:
        return 'Unknown';
    }
  }
}

extension TrackingTypeX on TrackingType {
  String get asApi {
    switch (this) {
      case TrackingType.paymentSubmitted:
        return 'PAYMENT_SUBMITTED';
      case TrackingType.paymentConfirmed:
        return 'PAYMENT_CONFIRMED';
      case TrackingType.deliveryScheduled:
        return 'DELIVERY_SCHEDULED';
      case TrackingType.confirmed:
        return 'CONFIRMED';
      case TrackingType.cancelled:
        return 'CANCELLED';
      case TrackingType.refunded:
        return 'REFUNDED';
      case TrackingType.unknown:
        return 'UNKNOWN';
    }
  }

  String get label {
    switch (this) {
      case TrackingType.paymentSubmitted:
        return 'Payment Submitted';
      case TrackingType.paymentConfirmed:
        return 'Payment Confirmed';
      case TrackingType.deliveryScheduled:
        return 'Delivery Scheduled';
      case TrackingType.confirmed:
        return 'Confirmed';
      case TrackingType.cancelled:
        return 'Cancelled';
      case TrackingType.refunded:
        return 'Refunded';
      case TrackingType.unknown:
        return 'Unknown';
    }
  }
}

OrderStatus _orderStatusFromJson(dynamic value) {
  final normalized = _normalize(value);
  switch (normalized) {
    case 'PENDING_PAYMENT':
      return OrderStatus.pendingPayment;
    case 'TO_BE_DELIVERED':
      return OrderStatus.toBeDelivered;
    case 'COMPLETED':
      return OrderStatus.completed;
    case 'CANCELLED':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.unknown;
  }
}

PaymentStatus _paymentStatusFromJson(dynamic value) {
  final normalized = _normalize(value);
  switch (normalized) {
    case 'PENDING':
      return PaymentStatus.pending;
    case 'SCREENSHOT_SENT':
      return PaymentStatus.screenshotSent;
    case 'FAILED':
      return PaymentStatus.failed;
    case 'CONFIRMED':
      return PaymentStatus.confirmed;
    case 'DECLINED':
      return PaymentStatus.declined;
    case 'REFUNDED':
      return PaymentStatus.refunded;
    default:
      return PaymentStatus.unknown;
  }
}

DeliveryStatus _deliveryStatusFromJson(dynamic value) {
  final normalized = _normalize(value);
  switch (normalized) {
    case 'NOT_SCHEDULED':
      return DeliveryStatus.notScheduled;
    case 'SCHEDULED':
      return DeliveryStatus.scheduled;
    case 'DELIVERED':
      return DeliveryStatus.delivered;
    default:
      return DeliveryStatus.unknown;
  }
}

RefundStatus _refundStatusFromJson(dynamic value) {
  final normalized = _normalize(value);
  switch (normalized) {
    case 'NOT_STARTED':
      return RefundStatus.notStarted;
    case 'PENDING':
      return RefundStatus.pending;
    case 'APPROVED':
      return RefundStatus.approved;
    case 'REJECTED':
      return RefundStatus.rejected;
    default:
      return RefundStatus.unknown;
  }
}

TrackingType _trackingTypeFromJson(dynamic value) {
  final normalized = _normalize(value);
  switch (normalized) {
    case 'PAYMENT_SUBMITTED':
      return TrackingType.paymentSubmitted;
    case 'PAYMENT_CONFIRMED':
      return TrackingType.paymentConfirmed;
    case 'DELIVERY_SCHEDULED':
      return TrackingType.deliveryScheduled;
    case 'CONFIRMED':
      return TrackingType.confirmed;
    case 'CANCELLED':
      return TrackingType.cancelled;
    case 'REFUNDED':
      return TrackingType.refunded;
    default:
      return TrackingType.unknown;
  }
}

String _normalize(dynamic value) {
  if (value == null) return '';
  final stringValue = value.toString().trim();
  if (stringValue.isEmpty) return '';
  return stringValue.replaceAll('-', '_').toUpperCase();
}

String _readString(Map<String, dynamic> json, List<String> keys, {String fallback = ''}) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final asString = value.toString();
    if (asString.isNotEmpty) return asString;
  }
  return fallback;
}

String? _readNullableString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) continue;
    final asString = value.toString();
    if (asString.isNotEmpty) return asString;
  }
  return null;
}

double _readDouble(Map<String, dynamic> json, String key, {double fallback = 0}) {
  final value = json[key];
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

double? _readNullableDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int _readInt(Map<String, dynamic> json, String key, {int fallback = 0}) {
  final value = json[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
  return null;
}

DateTime? _parseNullableDate(dynamic value) => _parseDate(value);
class OrderItem {
  final String id;
  final String userId;
  final String deliveryStatus;
  final String idempotencyKey;
  final String paymentStatus;
  final String refundStatus;
  final String merchOrderId;
  final String orderReceived;
  final String paymentMethod;
  final double totalAmount;
  final DateTime? deliveryDate;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Item> items;

  OrderItem({
    required this.id,
    required this.userId,
    required this.deliveryStatus,
    required this.idempotencyKey,
    required this.paymentStatus,
    required this.refundStatus,
    required this.merchOrderId,
    required this.orderReceived,
    required this.paymentMethod,
    required this.totalAmount,
    required this.deliveryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      deliveryStatus: json['deliverystatus'] ?? '',
      idempotencyKey: json['idempotencyKey'] ?? '',
      paymentStatus: json['paymentstatus'] ?? '',
      refundStatus: json['refundstatus'] ?? '',
      merchOrderId: json['merchOrderId'] ?? '',
      orderReceived: json['orderrecived'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      deliveryDate: json['deliverydate'] != null
          ? DateTime.tryParse(json['deliverydate'])
          : null,
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => Item.fromJson(item))
              .toList()
          : [],
    );
  }
}

class Item {
  final String id;
  final int quantity;
  final double price;
  final double packaging;
  final Product product;

  Item({
    required this.id,
    required this.quantity,
    required this.price,
    required this.packaging,
    required this.product,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      packaging: (json['packaging'] as num?)?.toDouble() ?? 0.0,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : Product(id: '', name: '', images: []),
    );
  }
}

class Product {
  final String id;
  final String name;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final imagesList = json['images'] as List<dynamic>? ?? [];
    final imageUrls =
        imagesList.map((img) => img['url']?.toString() ?? '').toList();

    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      images: imageUrls,
    );
  }
}

class OrderItem {
  final String name;
  final int packagingSize;
  final String image;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.packagingSize,
    required this.image,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    final images = product['images'] as List? ?? [];

    return OrderItem(
      name: product['name'] ?? '',
      packagingSize: json['packagingsize'] ?? 0,
      image: images.isNotEmpty ? images[0]['url'] : '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class OrderTrackingStep {
  final String title;
   final String date;
   final bool completed;

  OrderTrackingStep({
    required this.title,
     required this.date,
    required this.completed,
  });

  factory OrderTrackingStep.fromJson(Map<String, dynamic> json) {
    return OrderTrackingStep(
      title: json['title'] ?? '',
       date: json['timestamp'] ?? '', // can be null
       completed: json['timestamp'] != null,
    );
  }
}

class OrderDetails {
  final String orderId;
  final List<OrderTrackingStep> tracking;
  final List<OrderItem> items;
  final double deliveryFee;
  final String phoneNumber;
  final String address;
  final double totalAmount;

  OrderDetails({
    required this.orderId,
    required this.tracking,
    required this.items,
    required this.deliveryFee,
    required this.phoneNumber,
    required this.address,
    required this.totalAmount,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      orderId: json['merchantOrderId'] ?? '',
      tracking: (json['tracking'] as List<dynamic>)
          .map((x) => OrderTrackingStep.fromJson(x))
          .toList(),
      items: (json['items'] as List<dynamic>)
          .map((x) => OrderItem.fromJson(x))
          .toList(),
      deliveryFee: (json['deliveryfee'] as num).toDouble(),
      phoneNumber: json['phoneNumber'].toString(),
      address: json['location'] ?? '',
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );
  }
}

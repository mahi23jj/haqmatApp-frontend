class OrderItem {
  final String name;
  final String origin;
  final String image;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.origin,
    required this.image,
    required this.quantity,
    required this.price,
  });
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
}

class OrderDetails {
  final String orderId;
  final List<OrderTrackingStep> tracking;
  final List<OrderItem> items;
  final double deliveryFee;
  final String username;
  final String address;

  OrderDetails({
    required this.orderId,
    required this.tracking,
    required this.items,
    required this.deliveryFee,
    required this.username,
    required this.address,
  });
}

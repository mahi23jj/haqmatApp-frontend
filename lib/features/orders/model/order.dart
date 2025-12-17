class OrderItem {
  final String id;
  final String orderid;
  final double amount;
  final List<String> imageUrls;
  final String status;
  final DateTime date;

  OrderItem({
    required this.id,
    required this.orderid,
    required this.amount,
    required this.imageUrls,
    required this.status,
    required this.date,
  });

  // from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Parse list of items and extract their image URLs
    List<String> images = [];
    if (json['items'] != null) {
      images = List<String>.from(
        (json['items'] as List).map((item) => Item.fromJson(item).image),
      );
    }

    return OrderItem(
      id: json['id'],
      orderid: json['merchantOrderId'],
      amount: (json['totalAmount'] as num).toDouble(),
      imageUrls: images,
      status: json['status'],
      date: DateTime.parse(json['createdAt']),
    );
  }
}

class Item {
  final String productId;
  final String name;
  final String image;

  Item({
    required this.productId,
    required this.name,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: json["product"]['id'],
      name: json["product"]['name'],
      image: json["product"]["images"][0]["url"],
    );
  }
}




class CartModel {
  final String id;
  final String name;
  // final double price;
  final String imageUrl;
  final int packaging;
  final int quantity;
  final String tefftype;
  final String quality;
  final String productId;
  final int  totalprice;

  CartModel({
    required this.id,
    required this.name,
    // required this.price,
    required this.imageUrl,
    required this.packaging,
    required this.quantity,
    required this.tefftype,
    required this.quality,
    required this.productId,
    required this.totalprice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      name: json['product']['name'],
      // price: (json['product']['pricePerKg'] as num).toDouble(),
      imageUrl: json['product']['image'],
      packaging: json['packagingSize'],
      quantity: json['quantity'],
      tefftype: json['product']['tefftype'],
      quality: json['product']['quality'],
      productId: json['product']['id'],
      totalprice: json['totalprice']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // 'price': price,
      'imageUrl': imageUrl,
      'packaging': packaging,
      'quantity': quantity,
      'tefftype': tefftype,
      'quality': quality,
    };
  }

  // copy with
  CartModel copyWith({
    String? id,
    String? name,
    double? price,
    String? imageUrl,
    int? packaging,
    int? quantity,
    String? tefftype,
    String? quality,
    String? productId,
    int? totalprice,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      // price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      packaging: packaging ?? this.packaging,
      quantity: quantity ?? this.quantity,
      tefftype: tefftype ?? this.tefftype,
      quality: quality ?? this.quality,
      productId: productId ?? this.productId,
      totalprice: totalprice ?? this.totalprice,
    );
  }
}



class CartModelList {
  final List<CartModel> items;
  final int subtotal;
  final double tax;
  final double totalPrice;



  CartModelList({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.totalPrice,
    }
    );

 // from json
  factory CartModelList.fromJson(Map<String, dynamic> json) {
    var list = json['cart'] as List;
    List<CartModel> cartItems = list.map((i) => CartModel.fromJson(i)).toList();

    return CartModelList(
      items: cartItems,
      subtotal: json['subtotalPrice'],
      tax: (json['taxprice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }
  
}

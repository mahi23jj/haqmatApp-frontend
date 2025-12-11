import 'package:haqmate/features/home/models/product.dart';

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
    imageUrl: json['product']['image'],
    packaging: json['packagingSize'],
    quantity: json['quantity'],
    tefftype: json['product']['teffType'], // FIXED
    quality: json['product']['quality'],
    productId: json['product']['id'],
    totalprice: json['totalprice'],
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
  final LocationModel location;
  final String phoneNumber;
  final int totalPrice;

  CartModelList({
    required this.items,
    required this.location,
    required this.phoneNumber,
    required this.totalPrice,
  });

  // from json
  factory CartModelList.fromJson(Map<String, dynamic> json) {
    var list = json['cart'] as List;
    List<CartModel> cartItems =
        list.map((i) => CartModel.fromJson(i)).toList();

    return CartModelList(
      items: cartItems,
      location: LocationModel.fromJson(json['area']),
      phoneNumber: json['phoneNumber'],
      totalPrice: (json['subtotalPrice'] as num).toInt(),
    );
  }
}

class LocationModel {
  final String id;
  final String name;
  final int deliveryFee;

  LocationModel({
    required this.id,
    required this.name,
    required this.deliveryFee,
  });

  // from json
  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      name: json['name'],
      deliveryFee: (json['baseFee'] as num).toInt(),
    );
  }
}



class ProductOptions {
  final List<ProductModel> teffTypes;
  final List<int> packagingSizes;

  ProductOptions({
    required this.teffTypes,
    required this.packagingSizes,
  });

  factory ProductOptions.fromJson(Map<String, dynamic> json) {
    return ProductOptions(
      teffTypes: (json["teffTypes"] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
    
      packagingSizes: List<int>.from(json["packagingSizes"]),
    );
  }
}


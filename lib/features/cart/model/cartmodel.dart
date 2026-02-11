import 'package:haqmate/features/home/models/product.dart';
import 'package:hive/hive.dart';

part 'cartmodel.g.dart';

@HiveType(typeId: 1)
class CartModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final int packaging;
  @HiveField(4)
  final int quantity;
  @HiveField(5)
  final String tefftype;
  @HiveField(6)
  final String quality;
  @HiveField(7)
  final String productId;
  @HiveField(8)
  final int totalprice;

  CartModel({
    required this.id,
    required this.name,
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
      id: json['id']?.toString() ?? '',
      name: json['product']?['name']?.toString() ?? '',
      imageUrl: json['product']?['image']?.toString() ?? '',
      packaging:
          (json['packagingSize'] as num?)?.toInt() ??
          0, // FIXED: Use packagingSize
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      tefftype: json['product']?['teffType']?.toString() ?? '',
      quality: json['product']?['quality']?.toString() ?? '',
      productId: json['product']?['id']?.toString() ?? '',
      totalprice: (json['totalPrice'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'packaging': packaging,
      'quantity': quantity,
      'tefftype': tefftype,
      'quality': quality,
      'productId': productId,
      'totalprice': totalprice,
    };
  }

  CartModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? packaging,
    int? quantity,
    String? tefftype,
    String? quality,
    String? productId,
    int? totalprice,
    // int? deliveryFee,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      packaging: packaging ?? this.packaging,
      quantity: quantity ?? this.quantity,
      tefftype: tefftype ?? this.tefftype,
      quality: quality ?? this.quality,
      productId: productId ?? this.productId,
      totalprice: totalprice ?? this.totalprice,
      // deliveryFee: deliveryFee ?? this.deliveryFee,
    );
  }
}

@HiveType(typeId: 3)
class CartModelList {
  @HiveField(0)
  final List<CartModel> items;
  @HiveField(1)
  final LocationModel location;
  @HiveField(2)
  final String phoneNumber;
  @HiveField(3)
  final int totalPrice;
  @HiveField(4)
  final int deliveryFee;
  @HiveField(5)
  final int subtotalPrice;

  CartModelList({
    required this.items,
    required this.location,
    required this.phoneNumber,
    required this.totalPrice,
    this.deliveryFee = 0,
    this.subtotalPrice = 0,
  });

  factory CartModelList.fromJson(Map<String, dynamic> json) {
    var list = json['cart'] as List? ?? [];
    List<CartModel> cartItems = list
        .map((i) => CartModel.fromJson(i as Map<String, dynamic>))
        .toList();

    return CartModelList(
      items: cartItems,
      location: LocationModel.fromJson(json['area'] ?? {}),
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toInt() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toInt() ?? 0,
      subtotalPrice: (json['subtotalPrice'] as num?)?.toInt() ?? 0,
    );
  }

  // copy with
  CartModelList copyWith({
    List<CartModel>? items,
    LocationModel? location,
    String? phoneNumber,
    int? totalPrice,
    int? deliveryFee,
    int? subtotalPrice,
  }) {
    return CartModelList(
      items: items ?? this.items,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      subtotalPrice: subtotalPrice ?? this.subtotalPrice,
    );
  }
}

@HiveType(typeId: 2)
class LocationModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  // final int deliveryFee;

  LocationModel({
    required this.id,
    required this.name,
    // required this.deliveryFee,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      // deliveryFee: (json['baseFee'] as num?)?.toInt() ?? 0,
    );
  }
}

// class CartModel {
//   final String id;
//   final String name;
//   // final double price;
//   final String imageUrl;
//   final int packaging;
//   final int quantity;
//   final String tefftype;
//   final String quality;
//   final String productId;
//   final int  totalprice;

//   CartModel({
//     required this.id,
//     required this.name,
//     // required this.price,
//     required this.imageUrl,
//     required this.packaging,
//     required this.quantity,
//     required this.tefftype,
//     required this.quality,
//     required this.productId,
//     required this.totalprice,
//   });

//   factory CartModel.fromJson(Map<String, dynamic> json) {
//   return CartModel(
//     id: json['id'],
//     name: json['product']['name'],
//     imageUrl: json['product']['image'],
//     packaging: json['packagingSize'],
//     quantity: json['quantity'],
//     tefftype: json['product']['teffType'], // FIXED
//     quality: json['product']['quality'],
//     productId: json['product']['id'],
//     totalprice: json['totalPrice'],
//   );
// }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       // 'price': price,
//       'imageUrl': imageUrl,
//       'packaging': packaging,
//       'quantity': quantity,
//       'tefftype': tefftype,
//       'quality': quality,
//     };
//   }

//   // copy with
//   CartModel copyWith({
//     String? id,
//     String? name,
//     double? price,
//     String? imageUrl,
//     int? packaging,
//     int? quantity,
//     String? tefftype,
//     String? quality,
//     String? productId,
//     int? totalprice,
//   }) {
//     return CartModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       // price: price ?? this.price,
//       imageUrl: imageUrl ?? this.imageUrl,
//       packaging: packaging ?? this.packaging,
//       quantity: quantity ?? this.quantity,
//       tefftype: tefftype ?? this.tefftype,
//       quality: quality ?? this.quality,
//       productId: productId ?? this.productId,
//       totalprice: totalprice ?? this.totalprice,
//     );
//   }
// }

// class CartModelList {
//   final List<CartModel> items;
//   final LocationModel location;
//   final String phoneNumber;
//   final int totalPrice;

//   CartModelList({
//     required this.items,
//     required this.location,
//     required this.phoneNumber,
//     required this.totalPrice,
//   });

//   // from json
//   factory CartModelList.fromJson(Map<String, dynamic> json) {
//     var list = json['cart'] as List;
//     List<CartModel> cartItems =
//         list.map((i) => CartModel.fromJson(i)).toList();

//     return CartModelList(
//       items: cartItems,
//       location: LocationModel.fromJson(json['area']),
//       phoneNumber: json['phoneNumber'],
//       totalPrice: (json['subtotalPrice'] as num).toInt(),
//     );
//   }
// }

// class LocationModel {
//   final String id;
//   final String name;
//   final int deliveryFee;

//   LocationModel({
//     required this.id,
//     required this.name,
//     required this.deliveryFee,
//   });

//   // from json
//   factory LocationModel.fromJson(Map<String, dynamic> json) {
//     return LocationModel(
//       id: json['id'],
//       name: json['name'],
//       deliveryFee: (json['baseFee'] as num).toInt(),
//     );
//   }
// }

class ProductOptions {
  final List<ProductModel> teffTypes;
  final List<int> packagingSizes;

  ProductOptions({required this.teffTypes, required this.packagingSizes});

  factory ProductOptions.fromJson(Map<String, dynamic> json) {
    return ProductOptions(
      teffTypes: (json["teffTypes"] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList(),

      packagingSizes: List<int>.from(json["packagingSizes"]),
    );
  }
}

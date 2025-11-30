import 'package:haqmate/features/review/model/review_model.dart';

class Product {
final String id;
final String name;
final String description;
final double basePrice; // per default size
final List<String> images;
final bool inStock;
final double rating;
final int reviewsCount;
 final double? discountPercent; // nullable
final List<Review> reviews;


Product({
required this.id,
required this.name,
required this.description,
required this.basePrice,
required this.images,
required this.inStock,
required this.rating,
required this.reviewsCount,
required this.reviews,
 this.discountPercent,
});


// from json  
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    basePrice: (json['price'] as num).toDouble(),
    images: List<String>.from(json['images']),
    inStock: json['isstock'],
    rating: (json['averageRating'] as num).toDouble(),
    reviewsCount: json['totalRatings'],
    reviews: (json['feedback'] as List<dynamic>)
        .map((e) => Review.fromJson(e as Map<String, dynamic>))
        .toList(),
     discountPercent: json['discount'] != null
        ? (json['discount'] as num).toDouble()
        : null, 
  );
}


}


class WeightOption {
final String label; // e.g. 1kg, 5kg
final double multiplier; // price multiplier vs base
WeightOption({required this.label, required this.multiplier});
}
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
final Review? myReview;


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
 this.myReview,
});


// from json  
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] ?? "",

    name: json['name'] ?? "",

    description: json['description'] ?? "",

    basePrice: (json['price'] as num?)?.toDouble() ?? 0.0,

    images: json['images'] != null
        ? List<String>.from(json['images'])
        : [],

    inStock: json['isstock'] ?? false,

    rating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,

    reviewsCount: json['totalRatings'] ?? 0,

    reviews: json['feedback'] != null
        ? (json['feedback'] as List<dynamic>)
            .map((e) => Review.fromJson(e))
            .toList()
        : [],

    discountPercent: json['discount'] != null
        ? (json['discount'] as num?)?.toDouble()
        : null,
  );
}


// copywith
Product copyWith({
  String? id,
  String? name,
  String? description,
  double? basePrice,
  List<String>? images,
  bool? inStock,
  double? rating,
  int? reviewsCount,
  List<Review>? reviews,
  double? discountPercent,
  Review? myReview, 
} 
) {
  return Product(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    basePrice: basePrice ?? this.basePrice,
    images: images ?? this.images,
    inStock: inStock ?? this.inStock,
    rating: rating ?? this.rating,
    reviewsCount: reviewsCount ?? this.reviewsCount,
    reviews: reviews ?? this.reviews,
  );
}


  /// Return all reviews including user's own review on top
  List<Review> get allReviews {
    if (myReview == null) return reviews;

    // Avoid duplicate if myReview exists in reviews
    final filtered = reviews.where((r) => r.id != myReview!.id).toList();
    return [myReview!, ...filtered];
  }




}


class WeightOption {
final String label; // e.g. 1kg, 5kg
final int multiplier; // price multiplier vs base
WeightOption({required this.label, required this.multiplier});
}
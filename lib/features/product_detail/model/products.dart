class Product {
final String id;
final String name;
final String description;
final double basePrice; // per default size
final List<String> images;
final List<WeightOption> weights;
final bool inStock;
final double rating;
final int reviewsCount;
final String locationInfo;
final String deliveryInfo;
final double? discountPercent; // nullable


Product({
required this.id,
required this.name,
required this.description,
required this.basePrice,
required this.images,
required this.weights,
required this.inStock,
required this.rating,
required this.reviewsCount,
required this.locationInfo,
required this.deliveryInfo,
this.discountPercent,
});
}


class WeightOption {
final String label; // e.g. 1kg, 5kg
final double multiplier; // price multiplier vs base
WeightOption({required this.label, required this.multiplier});
}
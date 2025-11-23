import 'package:haqmate/features/product_detail/model/products.dart';

class FakeRepository {
  Product fetchProductById(String id) {
    // simulate network
    // await Future.delayed(Duration(milliseconds: 800));

    // Use the uploaded image path (the environment will transform this path).
    // Path provided by assistant: /mnt/data/9224a33d-c4b5-4563-bf64-990ffce32c93.png
    const localImagePath = 'assets/images/teff.jpg';

    return Product(
      id: id,
      name: 'Ethiopian White Teff (Level 1)',
      description:
          'Premium white teff, carefully processed. Great for injera and traditional dishes. Cleaned and quality checked.Premium white teff, carefully processed. Great for injera and traditional dishes. Cleaned and quality checked.',
      basePrice: 120.0, // base price in ETB for 1kg
      images: [localImagePath],
      weights: [
        WeightOption(label: '1 kg', multiplier: 1.0),
        WeightOption(label: '5 kg', multiplier: 4.6),
        WeightOption(label: '10 kg', multiplier: 8.5),
      ],
      inStock: true,
      rating: 4.8,
      reviewsCount: 124,
      locationInfo: 'Main Campus Market - Stall A12',
      deliveryInfo: 'Delivery within campus in 30–60 minutes',
      discountPercent: 10.0,
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:haqmate/features/product_detail/model/products.dart';
// import 'package:haqmate/features/product_detail/service/product_detail_repo.dart';
// import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';
// import 'package:haqmate/core/constants.dart';

// class ProductViewModel extends ChangeNotifier {
//   final ProductDetailRepo _repo;
//   Product? product;

//   List<WeightOption> get weights => [
//     WeightOption(label: '1 ኪ.ግ', multiplier: 1),
//     WeightOption(label: '5 ኪ.ግ', multiplier: 5),
//     WeightOption(label: '10 ኪ.ግ', multiplier: 10),
//   ];

//   bool loading = false;
//   String? error;
//   bool isRefreshing = false;

//   int selectedImageIndex = 0;
//   int quantity = 1;
//   int selectedWeightIndex = 0;
//   bool addingToCart = false;

//   String? customWeight;

//   ProductViewModel(this._repo);

//   void selectWeight(int idx, {String? customValue}) {
//     if (product == null) return;

//     if (idx < weights.length) {
//       selectedWeightIndex = idx;
//       customWeight = null;
//     } else {
//       final value = customValue?.trim();
//       if (value == null || value.isEmpty) return;
//       customWeight = value;
//       selectedWeightIndex = -1;
//     }

//     notifyListeners();
//   }

//   double get _customWeightAsDouble {
//     final parsed = double.tryParse(customWeight ?? '');
//     if (parsed == null || parsed <= 0) return 1;
//     return parsed;
//   }

//   double get selectedWeightMultiplier {
//     if (selectedWeightIndex == -1) {
//       return _customWeightAsDouble;
//     }

//     if (selectedWeightIndex >= 0 && selectedWeightIndex < weights.length) {
//       return weights[selectedWeightIndex].multiplier.toDouble();
//     }

//     return 1;
//   }

//   int get selectedPackagingSize => selectedWeightMultiplier.round();

//   String get selectedWeightLabel {
//     if (selectedWeightIndex == -1 && customWeight?.isNotEmpty == true) {
//       return '${customWeight!.trim()} ኪ.ግ';
//     }

//     if (selectedWeightIndex >= 0 && selectedWeightIndex < weights.length) {
//       return weights[selectedWeightIndex].label;
//     }

//     return weights.first.label;
//   }

//   Future<void> load(String id, {bool isRefresh = false}) async {
//     if (isRefresh) {
//       isRefreshing = true;
//     } else {
//       loading = true;
//     }
//     error = null;
//     notifyListeners();

//     try {
//       product = await _repo.fetchProductById(id);
//       error = null;
//     } catch (e) {
//       error = e.toString();
//       if (isRefresh) {
//         // For refresh, we keep the old data but show error
//         // Don't set product to null on refresh error
//       }
//     }

//     loading = false;
//     isRefreshing = false;
//     notifyListeners();
//   }

//   void reload(String id) {
//     load(id, isRefresh: true);
//   }

//   void resetState() {
//     selectedImageIndex = 0;
//     quantity = 1;
//     selectedWeightIndex = 0;
//     addingToCart = false;
//     customWeight = null;
//     notifyListeners();
//   }

//   void selectImage(int idx) {
//     selectedImageIndex = idx;
//     notifyListeners();
//   }

//   void setQuantity(int q) {
//     if (q < 1) return;
//     quantity = q;
//     notifyListeners();
//   }

//   void incrementQuantity() => setQuantity(quantity + 1);
//   void decrementQuantity() => setQuantity(quantity - 1);

//   double get price {
//     if (product == null) return 0.0;

//     final base = product!.basePrice * selectedWeightMultiplier;

//     final priceAfterDiscount = product!.discountPercent != null
//         ? base * (1 - product!.discountPercent! / 100)
//         : base;

//     return priceAfterDiscount * quantity;
//   }

//   String get formattedPrice {
//     return price.toStringAsFixed(2);
//   }

//   Future<void> addToCart(CartViewModel cartVm) async {
//     if (product == null || addingToCart) return;

//     addingToCart = true;
//     notifyListeners();

//     try {
//       await cartVm.addToCart(
//         productId: product!.id,
//         quantity: quantity,
//         packagingSize: selectedPackagingSize,
//       );
//     } finally {
//       addingToCart = false;
//       notifyListeners();
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:haqmate/features/product_detail/service/product_detail_repo.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';

/// Simple weight option model
class WeightOption {
  final String label;
  final double multiplier;

  WeightOption({
    required this.label,
    required this.multiplier,
  });
}

class ProductViewModel extends ChangeNotifier {
  final ProductDetailRepo _repo;
  Product? product;

  ProductViewModel(this._repo);

  /// =========================
  /// Weight handling
  /// =========================

  final List<WeightOption> _baseWeights = [
    WeightOption(label: '1 ኪ.ግ', multiplier: 1),
    WeightOption(label: '5 ኪ.ግ', multiplier: 5),
    WeightOption(label: '10 ኪ.ግ', multiplier: 10),
  ];

  WeightOption? _customWeight;
  int selectedWeightIndex = 0;
  // int selectedImageIndex = 0;

  List<WeightOption> get weights {
    if (_customWeight != null) {
      return [..._baseWeights, _customWeight!];
    }
    return _baseWeights;
  }

  WeightOption get selectedWeight => weights[selectedWeightIndex];

  void selectWeight(int index) {
    if (index < 0 || index >= weights.length) return;
    selectedWeightIndex = index;
    notifyListeners();
  }


  void selectImage(int idx) {
    selectedImageIndex = idx;
    notifyListeners();
  }


  /// Set or replace custom weight
  void setCustomWeight(double value) {
    if (value <= 0) return;

    _customWeight = WeightOption(
      label: '${value.toStringAsFixed(0)} ኪ.ግ',
      multiplier: value,
    );

    selectedWeightIndex = weights.length - 1; // select custom
    notifyListeners();
  }

  void clearCustomWeight() {
    _customWeight = null;
    selectedWeightIndex = 0;
    notifyListeners();
  }

  int get selectedPackagingSize =>
      selectedWeight.multiplier.round();

  String get selectedWeightLabel => selectedWeight.label;

  /// =========================
  /// UI State
  /// =========================

  bool loading = false;
  bool isRefreshing = false;
  bool addingToCart = false;
  String? error;

  int selectedImageIndex = 0;
  int quantity = 1;

  /// =========================
  /// Product loading
  /// =========================

  Future<void> load(String id, {bool isRefresh = false}) async {
    if (isRefresh) {
      isRefreshing = true;
    } else {
      loading = true;
    }
    error = null;
    notifyListeners();

    try {
      product = await _repo.fetchProductById(id);
    } catch (e) {
      error = e.toString();
    }

    loading = false;
    isRefreshing = false;
    notifyListeners();
  }

  void reload(String id) => load(id, isRefresh: true);

  void resetState() {
    selectedImageIndex = 0;
    quantity = 1;
    selectedWeightIndex = 0;
    _customWeight = null;
    addingToCart = false;
    notifyListeners();
  }

  /// =========================
  /// Quantity
  /// =========================

  void setQuantity(int q) {
    if (q < 1) return;
    quantity = q;
    notifyListeners();
  }

  void incrementQuantity() => setQuantity(quantity + 1);
  void decrementQuantity() => setQuantity(quantity - 1);

  /// =========================
  /// Price calculation
  /// =========================

  double get price {
    if (product == null) return 0;

    final basePrice =
        product!.basePrice * selectedWeight.multiplier;

    final discounted = product!.discountPercent != null
        ? basePrice * (1 - product!.discountPercent! / 100)
        : basePrice;

    return discounted * quantity;
  }

  String get formattedPrice => price.toStringAsFixed(2);

  /// =========================
  /// Cart
  /// =========================

  Future<void> addToCart(CartViewModel cartVm) async {
    if (product == null || addingToCart) return;

    addingToCart = true;
    notifyListeners();

    try {
      await cartVm.addToCart(
        productId: product!.id,
        quantity: quantity,
        packagingSize: selectedPackagingSize,
      );
    } finally {
      addingToCart = false;
      notifyListeners();
    }
  }
}

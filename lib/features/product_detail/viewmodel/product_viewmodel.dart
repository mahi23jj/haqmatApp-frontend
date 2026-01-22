import 'package:flutter/material.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:haqmate/features/product_detail/service/product_detail_repo.dart';
import 'package:haqmate/features/cart/viewmodel/cart_viewmodel.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductDetailRepo _repo;
  Product? product;

  List<WeightOption> get weights => [
    WeightOption(label: '1 kg', multiplier: 1),
    WeightOption(label: '5 kg', multiplier: 5),
    WeightOption(label: '10 kg', multiplier: 10),
  ];

  bool loading = false;
  String? error;

  int selectedImageIndex = 0;
  int quantity = 1;
  int selectedWeightIndex = 0;
  bool addingToCart = false;

  // Temporary variable to hold custom weight
  String? customWeight;

  ProductViewModel(this._repo);

  void selectWeight(int idx, {String? customValue}) {
    if (product == null) return;

    if (idx < weights.length) {
      selectedWeightIndex = idx;
      customWeight = null;
    } else {
      final value = customValue?.trim();
      if (value == null || value.isEmpty) return;
      customWeight = value;
      selectedWeightIndex = -1; // Use -1 for custom
    }

    notifyListeners();
  }

  double get _customWeightAsDouble {
    final parsed = double.tryParse(customWeight ?? '');
    if (parsed == null || parsed <= 0) return 1;
    return parsed;
  }

  double get selectedWeightMultiplier {
    if (selectedWeightIndex == -1) {
      return _customWeightAsDouble;
    }

    if (selectedWeightIndex >= 0 && selectedWeightIndex < weights.length) {
      return weights[selectedWeightIndex].multiplier.toDouble();
    }

    return 1;
  }

  int get selectedPackagingSize => selectedWeightMultiplier.round();

  String get selectedWeightLabel {
    if (selectedWeightIndex == -1 && customWeight?.isNotEmpty == true) {
      return '${customWeight!.trim()} kg';
    }

    if (selectedWeightIndex >= 0 && selectedWeightIndex < weights.length) {
      return weights[selectedWeightIndex].label;
    }

    return weights.first.label;
  }


  Future<void> load(String id) async {
    loading = true; // FIXED
    error = null;
    // product = null; // IMPORTANT FIX
    notifyListeners();

    try {
      product = await _repo.fetchProductById(id);
      print('view model $product');

      notifyListeners();
    } catch (e) {
      error = e.toString();
      print('error in product viewmodel: $error');
    }

    loading = false;
    notifyListeners();
  }

  void selectImage(int idx) {
    selectedImageIndex = idx;
    notifyListeners();
  }

  void setQuantity(int q) {
    if (q < 1) return;
    quantity = q;
    notifyListeners();
  }

  void nextQuantity() => setQuantity(quantity + 1);
  void prevQuantity() => setQuantity(quantity - 1);

  // void selectWeight(int idx) {
  //   if (product == null) return;
  //   if (idx < 0 || idx >= weights.length) return;
  //   selectedWeightIndex = idx;
  //   notifyListeners();
  // }






  // double get price {
  //   if (product == null) return 0.0;
  //   final base = product!.basePrice * weights[selectedWeightIndex].multiplier;
  //   final priceAfterDiscount = product!.discountPercent != null
  //       ? base * (1 - product!.discountPercent! / 100)
  //       : base;
  //   return priceAfterDiscount * quantity;
  // }

  double get price {
    if (product == null) return 0.0;

    final base = product!.basePrice * selectedWeightMultiplier;

    final priceAfterDiscount = product!.discountPercent != null
        ? base * (1 - product!.discountPercent! / 100)
        : base;

    return priceAfterDiscount * quantity;
  }

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


// class ProductViewModel extends ChangeNotifier {
//   final ProductDetailRepo _repo;
//   Product? product;
//   List<WeightOption> get weights => [WeightOption(label: '1 kg', multiplier: 1), WeightOption(label: '5 kg', multiplier: 5), WeightOption(label: '10 kg', multiplier: 10)];
//   bool loading = true;
//   String? error;

//   // UI state
//   int selectedImageIndex = 0;
//   int quantity = 1;
//   int selectedWeightIndex = 0;

//   ProductViewModel(this._repo);

//   void load(String id) async{
//     loading = false;
//     error = null;
//     notifyListeners();

//     try {
//       product = await _repo.fetchProductById(id);

//       print('viewmodel $product');
//       loading = false;
//       notifyListeners();
//     } catch (e) {
//       loading = false;
//       error = e.toString();
//       notifyListeners();
//     }
//   }

 
// }

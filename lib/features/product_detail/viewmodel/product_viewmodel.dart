import 'package:flutter/material.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:haqmate/features/product_detail/service/product_detail_repo.dart';

class ProductViewModel extends ChangeNotifier {
  final FakeRepository _repo;
  Product? product;
  bool loading = true;
  String? error;

  // UI state
  int selectedImageIndex = 0;
  int quantity = 1;
  int selectedWeightIndex = 0;

  ProductViewModel(this._repo);

  void load(String id) {
    loading = false;
    error = null;
    notifyListeners();

    try {
      product =  _repo.fetchProductById(id);
      loading = false;
      notifyListeners();
    } catch (e) {
      loading = false;
      error = e.toString();
      notifyListeners();
    }
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

  void selectWeight(int idx) {
    if (product == null) return;
    if (idx < 0 || idx >= product!.weights.length) return;
    selectedWeightIndex = idx;
    notifyListeners();
  }

  double get price {
    if (product == null) return 0.0;
    final base =
        product!.basePrice * product!.weights[selectedWeightIndex].multiplier;
    final priceAfterDiscount = product!.discountPercent != null
        ? base * (1 - product!.discountPercent! / 100)
        : base;
    return priceAfterDiscount * quantity;
  }
}

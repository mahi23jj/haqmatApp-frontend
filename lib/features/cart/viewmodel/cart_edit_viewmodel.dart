import 'package:flutter/material.dart';
import 'package:haqmate/features/home/models/product.dart';
import 'package:haqmate/features/home/service/product_repository.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';

class ProductOptionViewModel extends ChangeNotifier {
  final ProductsRepository _service = ProductsRepository();

  List<ProductModel>? options;

  List<WeightOption> get weights => [
        WeightOption(label: '1 kg', multiplier: 1),
        WeightOption(label: '5 kg', multiplier: 5),
        WeightOption(label: '10 kg', multiplier: 10),
      ];

  String? selectedTeffTypeId;
  bool isLoading = false;

  int quantity = 1;
  int selectedWeightIndex = 0;

  /// Initialize from a cart item if available
  void initFromCartItem(CartModel cartItem) {
    if (cartItem != null) {
      selectedTeffTypeId = cartItem.productId;

      // Find the weight index matching the cart's packaging size
      final weightIdx = weights.indexWhere(
        (w) => w.multiplier == cartItem.packaging,
      );
      selectedWeightIndex = weightIdx != -1 ? weightIdx : 0;

      quantity = cartItem.quantity;
    } else {
      // Defaults if no cart item
      selectedTeffTypeId = null;
      selectedWeightIndex = 0;
      quantity = 1;
    }

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
    if (idx < 0 || idx >= weights.length) return;
    selectedWeightIndex = idx;
    notifyListeners();
  }

  Future<void> loadOptions(String productId) async {
    isLoading = true;
    notifyListeners();

    options = await _service.fetchFeatured();

    // Default selections if not initialized from cart

    isLoading = false;
    notifyListeners();
  }

  void selectTeffType(String id) {
    selectedTeffTypeId = id;
    notifyListeners();
  }
}

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
  String? error;

  int quantity = 1;
  int selectedWeightIndex = 0;
  String? customWeight;

  /// Initialize from a cart item if available
  void initFromCartItem(CartModel cartItem) {
    if (cartItem != null) {
      selectedTeffTypeId = cartItem.productId;

      // Find the weight index matching the cart's packaging size
      final weightIdx = weights.indexWhere(
        (w) => w.multiplier == cartItem.packaging,
      );
      if (weightIdx != -1) {
        selectedWeightIndex = weightIdx;
        customWeight = null;
      } else {
        selectedWeightIndex = -1;
        customWeight = cartItem.packaging.toString();
      }

      quantity = cartItem.quantity;
    } else {
      // Defaults if no cart item
      selectedTeffTypeId = null;
      selectedWeightIndex = 0;
      quantity = 1;
      customWeight = null;
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

  void selectWeight(int idx, {String? customValue}) {
    if (idx < 0) return;

    // preset option
    if (idx < weights.length) {
      selectedWeightIndex = idx;
      customWeight = null;
      notifyListeners();
      return;
    }

    // custom option
    final value = customValue?.trim();
    if (value == null || value.isEmpty) return;
    customWeight = value;
    selectedWeightIndex = -1;
    notifyListeners();
  }

  double get _customWeightAsDouble {
    final parsed = double.tryParse(customWeight ?? '');
    if (parsed == null || parsed <= 0) return 1;
    return parsed;
  }

  double get selectedWeightMultiplier {
    if (selectedWeightIndex == -1) return _customWeightAsDouble;
    if (selectedWeightIndex >= 0 && selectedWeightIndex < weights.length) {
      return weights[selectedWeightIndex].multiplier.toDouble();
    }
    return 1;
  }

  int get selectedPackagingSize => selectedWeightMultiplier.round();

  Future<void> loadOptions(String productId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      options = await _service.fetchFeatured();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void selectTeffType(String id) {
    selectedTeffTypeId = id;
    notifyListeners();
  }
}

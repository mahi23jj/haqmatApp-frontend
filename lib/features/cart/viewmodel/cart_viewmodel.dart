import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';

import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/cart/service/cart_repo.dart';


class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();

  CartModelList? _cartItems;
  bool _loading = false;
  String? _error;

  CartModelList? get cartItems => _cartItems;
  bool get loading => _loading;
  String? get error => _error;

  // -------------------------
  // FETCH CART ITEMS
  // -------------------------
  Future<void> loadCart() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _cartItems = await _cartService.fetchcart();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  // -------------------------
  // ADD OR UPDATE CART
  // -------------------------
  Future<void> addToCart({
    required String productId,
    required int quantity,
    required int packagingSize,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      await _cartService.addcart(productId, quantity, packagingSize);

      // reload cart after adding
      await loadCart();

    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  // -------------------------
  // UPDATE QUANTITY (+ or -)
  // -------------------------
  Future<void> updateQuantity({
    required String productId,
    required int quantity,
    required int packagingSize,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      await _cartService.updatecartquanty(productId, quantity, packagingSize);
         

         final carts = _cartItems!.items;
      // update local object immediately
      final index = carts.indexWhere((c) =>
          c.productId == productId && c.packaging == packagingSize);

      if (index != -1) {
        carts[index] =
          carts[index].copyWith(quantity: quantity);
      }

    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  // -------------------------
  // CLEAR CART ERROR
  // -------------------------
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

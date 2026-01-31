import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/cart/service/cart_repo.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _cartService = CartService();

  CartModelList? _cartItems;
  bool _loading = false;
  String? _error;

  int _currentPage = 1;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool _loadingMore = false;
  String? _loadMoreError;

  CartModelList? get cartItems => _cartItems;
  bool get loading => _loading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get loadingMore => _loadingMore;
  String? get loadMoreError => _loadMoreError;

  Timer? _cartUpdateTimer;

  /* Future<void> updateQuantity({
  required String productId,
  required int quantity,
  required int packagingSize,
}) async {
  try {
    await _cartService.updatecartquanty(productId, quantity, packagingSize);

    final carts = _cartItems!.items;
    final index = carts.indexWhere(
      (c) => c.productId == productId && c.packaging == packagingSize,
    );

    if (index != -1) {
      final old = carts[index];

      final pricePerItem = old.totalprice ~/ old.quantity;

      carts[index] = old.copyWith(
        quantity: quantity,
        totalprice: quantity * pricePerItem,
      );
    }

    // recompute subtotal, tax, total
    final total = carts.fold(0, (sum, item) => sum + item.totalprice);
 /*    final tax = subtotal * 0.15; // adjust rate based on backend
    final total = subtotal + tax; */

    _cartItems = CartModelList(
      items: carts,
     location: _cartItems!.location,
     phoneNumber: _cartItems!.phoneNumber,
      totalPrice: total,
    );

  } catch (e) {
    _error = e.toString();
  }

  notifyListeners();
}
 */

  Future<void> updateQuantity({
    required String productId,
    required int quantity,
    required int packagingSize,
  }) async {
    if (_cartItems == null) return;

    final carts = List.of(_cartItems!.items);

    final index = carts.indexWhere(
      (c) => c.productId == productId && c.packaging == packagingSize,
    );

    if (index == -1) return;

    final oldItem = carts[index];

    // 🔥 1️⃣ UPDATE UI IMMEDIATELY (OPTIMISTIC)
    final pricePerItem = oldItem.totalprice ~/ oldItem.quantity;
    // final deliveryfee = 12 * oldItem.packaging * quantity;

    carts[index] = oldItem.copyWith(
      quantity: quantity,
      totalprice: quantity * pricePerItem,
    );

    final total = carts.fold(0, (sum, item) => sum + item.totalprice);

    final deliveryfee = carts.fold<int>(
      0,
      (sum, item) => sum + (12 * item.packaging * item.quantity),
    );

    final subtotalPrice = total - deliveryfee;

    _cartItems = _cartItems!.copyWith(
      items: carts,
      totalPrice: total,
      deliveryFee: deliveryfee,
      subtotalPrice: subtotalPrice,
    );

    notifyListeners(); // 🚀 UI updates instantly

    // 🔁 2️⃣ BACKGROUND API SYNC
    try {
      await _cartService.updatecartquanty(productId, quantity, packagingSize);
    } catch (e) {
      // ❌ 3️⃣ ROLLBACK IF API FAILS (optional but recommended)
      carts[index] = oldItem;

      final rollbackTotal = carts.fold(0, (sum, item) => sum + item.totalprice);

      _cartItems = _cartItems!.copyWith(
        items: carts,
        totalPrice: rollbackTotal,
      );

      notifyListeners();

      _error = e.toString();
    }
  }

  void updateQuantityDebounced({
    required String productId,
    required int quantity,
    required int packagingSize,
  }) {
    updateQuantity(
      productId: productId,
      quantity: quantity,
      packagingSize: packagingSize,
    );

    _cartUpdateTimer?.cancel();
    _cartUpdateTimer = Timer(const Duration(milliseconds: 400), () {
      _cartService.updatecartquanty(productId, quantity, packagingSize);
    });
  }

  Future<void> removeItem(CartModel item) async {
    if (_cartItems == null) return;

    final previousItems = List<CartModel>.from(_cartItems!.items);
    final updatedItems = List<CartModel>.from(previousItems)
      ..removeWhere((c) => c.id == item.id);

    final updatedTotal = updatedItems.fold<int>(
      0,
      (sum, cart) => sum + cart.totalprice,
    );

    _cartItems = _cartItems!.copyWith(
      items: updatedItems,
      totalPrice: updatedTotal,
    );

    notifyListeners();

    try {
      await _cartService.removeFromCart(item.id);
    } catch (e) {
      _cartItems = _cartItems!.copyWith(
        items: previousItems,
        totalPrice: previousItems.fold<int>(
          0,
          (sum, cart) => sum + cart.totalprice,
        ),
      );

      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateItem({
    required String id,
    required String? productId,
    required int? quantity,
    required int? packagingSize,
  }) async {
    try {
      await _cartService.updatecart(id, productId, quantity, packagingSize);

      loadCart(refresh: true);
    } catch (e) {
      _error = e.toString();
    }

    notifyListeners();
  }

  // -------------------------
  // FETCH CART ITEMS
  // -------------------------
  Future<void> loadCart({bool refresh = false}) async {
    _loading = true;
    _error = null;
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _loadMoreError = null;
    }
    notifyListeners();

    try {
      _cartItems = await _cartService.fetchcart(
        page: 1,
        limit: _pageSize,
      );
      print(_cartItems);
      _currentPage = 1;
      _hasMore = (_cartItems?.items.length ?? 0) == _pageSize;
      notifyListeners();
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
      final items = await _cartService.addcart(
        productId,
        quantity,
        packagingSize,
      );

      print(items);

      // reload cart after adding
      await loadCart(refresh: true);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> loadMoreCart() async {
    if (_loading || _loadingMore || !_hasMore) return;
    _loadingMore = true;
    _loadMoreError = null;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final data = await _cartService.fetchcart(
        page: nextPage,
        limit: _pageSize,
      );

      final currentItems = _cartItems?.items ?? [];
      final mergedItems = [...currentItems, ...data.items];

      _cartItems = CartModelList(
        items: mergedItems,
        location: data.location,
        phoneNumber: data.phoneNumber,
        totalPrice: data.totalPrice,
        deliveryFee: data.deliveryFee,
        subtotalPrice: data.subtotalPrice,
      );

      _currentPage = nextPage;
      _hasMore = data.items.length == _pageSize;
    } catch (e) {
      _loadMoreError = e.toString();
    }

    _loadingMore = false;
    notifyListeners();
  }

  // -------------------------
  // UPDATE QUANTITY (+ or -)
  // -------------------------
  // Future<void> updateQuantity({
  //   required String productId,
  //   required int quantity,
  //   required int packagingSize,
  // }) async {
  //   _loading = true;
  //   notifyListeners();

  //   try {
  //     await _cartService.updatecartquanty(productId, quantity, packagingSize);

  //        final carts = _cartItems!.items;
  //     // update local object immediately
  //     final index = carts.indexWhere((c) =>
  //         c.productId == productId && c.packaging == packagingSize);

  //     if (index != -1) {
  //       carts[index] =
  //         carts[index].copyWith(quantity: quantity);
  //     }

  //   } catch (e) {
  //     _error = e.toString();
  //   }

  //   _loading = false;
  //   notifyListeners();
  // }

  // -------------------------
  // CLEAR CART ERROR
  // -------------------------
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

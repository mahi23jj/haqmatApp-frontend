import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/data/cart_local_data_source.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/cart/service/cart_repo.dart';

class CartViewModel extends ChangeNotifier {
  CartViewModel({
    CartService? cartService,
    CartLocalDataSource? localDataSource,
  }) : _cartService = cartService ?? CartService(),
       _localDataSource = localDataSource ?? CartLocalDataSource();

  final CartService _cartService;
  final CartLocalDataSource _localDataSource;

  CartModelList? _cartItems;
  bool _loading = false;
  String? _error;

  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMore = true;
  bool _loadingMore = false;
  String? _loadMoreError;

  bool _syncingChange = false;
  Timer? _cartUpdateTimer;

  CartModelList? get cartItems => _cartItems;
  bool get loading => _loading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get loadingMore => _loadingMore;
  String? get loadMoreError => _loadMoreError;

  // -------------------------
  // CACHE HELPERS
  // -------------------------
  Future<void> _saveCache() async {
    if (_cartItems == null) return;
    await _localDataSource.saveCart(_cartItems!);
  }

  Future<CartModelList?> _readCache() async {
    return _localDataSource.readCart();
  }

  Future<void> clearCache() async {
    await _localDataSource.clearCart();
  }

  // -------------------------
  // FETCH CART ITEMS
  // -------------------------
  Future<void> loadCart({bool refresh = false}) async {
    if (_loading) return;

    if (!refresh) {
      final cached = await _readCache();
      if (cached != null) {
        _cartItems = _recalculateTotals(cached);
        _error = null;
        notifyListeners();
      }
    }

    _loading = refresh || _cartItems == null;
    _error = null;
    notifyListeners();

    try {
      final data = await _cartService.fetchcart(page: 1, limit: _pageSize);
      _cartItems = _recalculateTotals(data);
      _currentPage = 1;
      _hasMore = data.items.length == _pageSize;
      await _saveCache();
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

      final location = _cartItems?.location ?? data.location;
      final phoneNumber = _cartItems?.phoneNumber ?? data.phoneNumber;

      _cartItems = _recalculateTotals(
        CartModelList(
          items: mergedItems,
          location: location,
          phoneNumber: phoneNumber,
          totalPrice: data.totalPrice,
          deliveryFee: data.deliveryFee,
          subtotalPrice: data.subtotalPrice,
        ),
      );

      _currentPage = nextPage;
      _hasMore = data.items.length == _pageSize;
      await _saveCache();
    } catch (e) {
      _loadMoreError = e.toString();
    }

    _loadingMore = false;
    notifyListeners();
  }

  // -------------------------
  // ADD TO CART (OPTIMISTIC)
  // -------------------------
  Future<void> addToCart({
    required String productId,
    required String name,
    required String imageUrl,
    required int quantity,
    required int packaging,
    required String tefftype,
    required String quality,
    required int totalPrice,
  }) async {
    if (_syncingChange) return;

    _syncingChange = true;
    final before = _cartItems;

    _cartItems ??= CartModelList(
      items: [],
      location: LocationModel(id: '', name: ''),
      phoneNumber: '',
      totalPrice: 0,
      deliveryFee: 0,
      subtotalPrice: 0,
    );

    final items = List<CartModel>.from(_cartItems!.items);
    final existingIndex = items.indexWhere(
      (item) => item.productId == productId && item.packaging == packaging,
    );

    if (existingIndex != -1) {
      final existing = items[existingIndex];
      items[existingIndex] = existing.copyWith(
        quantity: quantity,
        totalprice: totalPrice,
      );
    } else {
      items.add(
        CartModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: productId,
          name: name,
          imageUrl: imageUrl,
          quantity: quantity,
          packaging: packaging,
          tefftype: tefftype,
          quality: quality,
          totalprice: totalPrice,
        ),
      );
    }

    _cartItems = _recalculateTotals(_cartItems!.copyWith(items: items));
    _error = null;
    await _saveCache();
    notifyListeners();

    try {
      await _cartService.addcart(productId, quantity, packaging);
    } catch (e) {
      _error = e.toString();
      _cartItems = before;
      await _saveCache();
      notifyListeners();
      await loadCart(refresh: true);
    }

    _syncingChange = false;
  }

  // -------------------------
  // UPDATE QUANTITY (OPTIMISTIC)
  // -------------------------
  Future<void> updateQuantity({
    required String productId,
    required int quantity,
    required int packagingSize,
    bool sync = true,
  }) async {
    if (_cartItems == null || _syncingChange) return;

    _syncingChange = true;
    final before = _cartItems;

    final items = List<CartModel>.from(_cartItems!.items);
    final index = items.indexWhere(
      (c) => c.productId == productId && c.packaging == packagingSize,
    );
    if (index == -1) {
      _syncingChange = false;
      return;
    }

    final oldItem = items[index];
    final pricePerItem = oldItem.totalprice ~/ oldItem.quantity;
    items[index] = oldItem.copyWith(
      quantity: quantity,
      totalprice: quantity * pricePerItem,
    );

    _cartItems = _recalculateTotals(_cartItems!.copyWith(items: items));
    _error = null;
    await _saveCache();
    notifyListeners();

    if (sync) {
      try {
        await _cartService.updatecartquanty(productId, quantity, packagingSize);
      } catch (e) {
        _error = e.toString();
        _cartItems = before;
        await _saveCache();
        notifyListeners();
        await loadCart(refresh: true);
      }

      _syncingChange = false;
    } else {
      _syncingChange = false;
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
      sync: false,
    );

    _cartUpdateTimer?.cancel();
    _cartUpdateTimer = Timer(const Duration(milliseconds: 400), () {
      _cartService.updatecartquanty(productId, quantity, packagingSize);
    });
  }

  // -------------------------
  // REMOVE ITEM (OPTIMISTIC)
  // -------------------------
  Future<void> removeItem(CartModel item) async {
    if (_cartItems == null || _syncingChange) return;

    _syncingChange = true;
    final before = _cartItems;

    final items = List<CartModel>.from(_cartItems!.items)
      ..removeWhere((c) => c.id == item.id);

    _cartItems = _recalculateTotals(_cartItems!.copyWith(items: items));
    _error = null;
    await _saveCache();
    notifyListeners();

    try {
      await _cartService.removeFromCart(item.id);
    } catch (e) {
      _error = e.toString();
      _cartItems = before;
      await _saveCache();
      notifyListeners();
      await loadCart(refresh: true);
    }

    _syncingChange = false;
  }

  // -------------------------
  // UPDATE ITEM (OPTIMISTIC)
  // -------------------------
  Future<void> updateItem({
    required String id,
    required String? productId,
    required int? quantity,
    required int? packagingSize,
  }) async {
    if (_cartItems == null || _syncingChange) return;

    _syncingChange = true;
    final before = _cartItems;

    if (quantity != null && packagingSize != null && productId != null) {
      final items = List<CartModel>.from(_cartItems!.items);
      final index = items.indexWhere((c) => c.id == id);
      if (index != -1) {
        final oldItem = items[index];
        final pricePerItem = oldItem.totalprice ~/ oldItem.quantity;
        items[index] = oldItem.copyWith(
          quantity: quantity,
          packaging: packagingSize,
          totalprice: quantity * pricePerItem,
          productId: productId,
        );
        _cartItems = _recalculateTotals(_cartItems!.copyWith(items: items));
        _error = null;
        await _saveCache();
        notifyListeners();
      }
    }

    try {
      await _cartService.updatecart(id, productId, quantity, packagingSize);
    } catch (e) {
      _error = e.toString();
      _cartItems = before;
      await _saveCache();
      notifyListeners();
      await loadCart(refresh: true);
    }

    _syncingChange = false;
  }

  // -------------------------
  // TOTALS CALCULATION
  // -------------------------
  CartModelList _recalculateTotals(CartModelList base) {
    final subtotal = base.items.fold<int>(
      0,
      (sum, item) => sum + item.totalprice,
    );
    final deliveryFee = base.items.fold<int>(
      0,
      (sum, item) => sum + (12 * item.quantity * item.packaging),
    );
    final total = subtotal + deliveryFee;

    return base.copyWith(
      subtotalPrice: subtotal,
      deliveryFee: deliveryFee,
      totalPrice: total,
    );
  }

  // -------------------------
  // ERROR STATE
  // -------------------------
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// class CartViewModel extends CartViewModel {
//   CartViewModel({CartService? cartService}) : super(cartService: cartService);
// }import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:haqmate/features/cart/model/cartmodel.dart';
// import 'package:haqmate/features/cart/service/cart_repo.dart';

// class CartViewModel extends ChangeNotifier {
//   final CartService _cartService = CartService();

//   CartModelList? _cartItems;
//   bool _loading = false;
//   String? _error;

//   int _currentPage = 1;
//   final int _pageSize = 10;
//   bool _hasMore = true;
//   bool _loadingMore = false;
//   String? _loadMoreError;

//   CartModelList? get cartItems => _cartItems;
//   bool get loading => _loading;
//   String? get error => _error;
//   int get currentPage => _currentPage;
//   bool get hasMore => _hasMore;
//   bool get loadingMore => _loadingMore;
//   String? get loadMoreError => _loadMoreError;

//   Timer? _cartUpdateTimer;

//   Future<void> updateQuantity({
//     required String productId,
//     required int quantity,
//     required int packagingSize,
//   }) async {
//     if (_cartItems == null) return;

//     final carts = List.of(_cartItems!.items);

//     final index = carts.indexWhere(
//       (c) => c.productId == productId && c.packaging == packagingSize,
//     );

//     if (index == -1) return;

//     final oldItem = carts[index];

//     // 🔥 1️⃣ UPDATE UI IMMEDIATELY (OPTIMISTIC)
//     final pricePerItem = oldItem.totalprice ~/ oldItem.quantity;
//     // final deliveryfee = 12 * oldItem.packaging * quantity;

//     carts[index] = oldItem.copyWith(
//       quantity: quantity,
//       totalprice: quantity * pricePerItem,
//     );

//     final total = carts.fold(0, (sum, item) => sum + item.totalprice);

//     final deliveryfee = carts.fold<int>(
//       0,
//       (sum, item) => sum + (12 * item.packaging * item.quantity),
//     );

//     final subtotalPrice = total - deliveryfee;

//     _cartItems = _cartItems!.copyWith(
//       items: carts,
//       totalPrice: total,
//       deliveryFee: deliveryfee,
//       subtotalPrice: subtotalPrice,
//     );

//     notifyListeners(); // 🚀 UI updates instantly

//     // 🔁 2️⃣ BACKGROUND API SYNC
//     try {
//       await _cartService.updatecartquanty(productId, quantity, packagingSize);
//     } catch (e) {
//       // ❌ 3️⃣ ROLLBACK IF API FAILS (optional but recommended)
//       carts[index] = oldItem;

//       final rollbackTotal = carts.fold(0, (sum, item) => sum + item.totalprice);

//       _cartItems = _cartItems!.copyWith(
//         items: carts,
//         totalPrice: rollbackTotal,
//       );

//       notifyListeners();

//       _error = e.toString();
//     }
//   }

//   void updateQuantityDebounced({
//     required String productId,
//     required int quantity,
//     required int packagingSize,
//   }) {
//     updateQuantity(
//       productId: productId,
//       quantity: quantity,
//       packagingSize: packagingSize,
//     );

//     _cartUpdateTimer?.cancel();
//     _cartUpdateTimer = Timer(const Duration(milliseconds: 400), () {
//       _cartService.updatecartquanty(productId, quantity, packagingSize);
//     });
//   }

//   Future<void> removeItem(CartModel item) async {
//     if (_cartItems == null) return;

//     final previousItems = List<CartModel>.from(_cartItems!.items);
//     final updatedItems = List<CartModel>.from(previousItems)
//       ..removeWhere((c) => c.id == item.id);

//     final updatedTotal = updatedItems.fold<int>(
//       0,
//       (sum, cart) => sum + cart.totalprice,
//     );

//     _cartItems = _cartItems!.copyWith(
//       items: updatedItems,
//       totalPrice: updatedTotal,
//     );

//     notifyListeners();

//     try {
//       await _cartService.removeFromCart(item.id);
//     } catch (e) {
//       _cartItems = _cartItems!.copyWith(
//         items: previousItems,
//         totalPrice: previousItems.fold<int>(
//           0,
//           (sum, cart) => sum + cart.totalprice,
//         ),
//       );

//       _error = e.toString();
//       notifyListeners();
//     }
//   }

//   Future<void> updateItem({
//     required String id,
//     required String? productId,
//     required int? quantity,
//     required int? packagingSize,
//   }) async {
//     try {
//       await _cartService.updatecart(id, productId, quantity, packagingSize);

//       loadCart(refresh: true);
//     } catch (e) {
//       _error = e.toString();
//     }

//     notifyListeners();
//   }

//   // -------------------------
//   // FETCH CART ITEMS
//   // -------------------------
//   Future<void> loadCart({bool refresh = false}) async {
//     _loading = true;
//     _error = null;
//     if (refresh) {
//       _currentPage = 1;
//       _hasMore = true;
//       _loadMoreError = null;
//     }
//     notifyListeners();

//     try {
//       _cartItems = await _cartService.fetchcart(page: 1, limit: _pageSize);
//       print(_cartItems);
//       _currentPage = 1;
//       _hasMore = (_cartItems?.items.length ?? 0) == _pageSize;
//       notifyListeners();
//     } catch (e) {
//       _error = e.toString();
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // ADD OR UPDATE CART
//   // -------------------------
//   Future<void> addToCart({
//     required String productId,
//     required String name,
//     required String imageUrl,
//     required int quantity,
//     required int packaging,
//     required String tefftype,
//     required String quality,
//     required int totalPrice,
//   }) async {
//     _loading = true;
//     notifyListeners();

//     // Ensure _cartItems is initialized
//     _cartItems ??= CartModelList(
//       items: [],
//       location: LocationModel(id: '', name: ''),
//       phoneNumber: '',
//       totalPrice: 0,
//       deliveryFee: 0,
//       subtotalPrice: 0,
//     );

//     // Find existing item
//     final existingIndex = _cartItems!.items.indexWhere(
//       (item) => item.productId == productId && item.packaging == packaging,
//     );
//     final existing = existingIndex != -1 ? _cartItems!.items[existingIndex] : null;

//     if (existing != null) {
//       // Optimistic update quantity & total price
//       _cartItems!.items[existingIndex] = existing.copyWith(
//         quantity: quantity,
//         totalprice: totalPrice,
//       );
//     } else {
//       // Add new item optimistically
//       _cartItems!.items.add(
//         CartModel(
//           id: DateTime.now().millisecondsSinceEpoch.toString(), // temp id
//           productId: productId,
//           name: name,
//           imageUrl: imageUrl,
//           quantity: quantity,
//           packaging: packaging,
//           tefftype: tefftype,
//           quality: quality,
//           totalprice: totalPrice,
//         ),
//       );
//     }

//     // Update subtotal & total
//     _cartItems = _cartItems!.copyWith(
//       subtotalPrice: _cartItems!.items.fold(
//         0,
//         (sum, item) => (sum ?? 0) + (item.totalprice ?? 0),
//       ),
//       totalPrice: _cartItems!.items.fold(
//         0,
//         (sum, item) => (sum ?? 0) + (item.totalprice ?? 0),
//       ),
//       deliveryFee: _cartItems!.items.fold(
//         0,
//         (sum, item) => (sum ?? 0) + (12 * item.quantity * item.packaging),
//       ),
//     );

//     notifyListeners();

//     try {
//       // Call backend
//       await _cartService.addcart(productId, quantity, packaging);

//       // Optional: reload from server to sync
//       await loadCart(refresh: true);
//     } catch (e) {
//       _error = e.toString();

//       // Rollback optimistic update by reloading from server
//       await loadCart(refresh: true);
//     }

//     _loading = false;
//     notifyListeners();
//   }

//   Future<void> loadMoreCart() async {
//     if (_loading || _loadingMore || !_hasMore) return;
//     _loadingMore = true;
//     _loadMoreError = null;
//     notifyListeners();

//     try {
//       final nextPage = _currentPage + 1;
//       final data = await _cartService.fetchcart(
//         page: nextPage,
//         limit: _pageSize,
//       );

//       final currentItems = _cartItems?.items ?? [];
//       final mergedItems = [...currentItems, ...data.items];

//       _cartItems = CartModelList(
//         items: mergedItems,
//         location: data.location,
//         phoneNumber: data.phoneNumber,
//         totalPrice: data.totalPrice,
//         deliveryFee: data.deliveryFee,
//         subtotalPrice: data.subtotalPrice,
//       );

//       _currentPage = nextPage;
//       _hasMore = data.items.length == _pageSize;
//     } catch (e) {
//       _loadMoreError = e.toString();
//     }

//     _loadingMore = false;
//     notifyListeners();
//   }

//   // -------------------------
//   // UPDATE QUANTITY (+ or -)
//   // -------------------------
//   // Future<void> updateQuantity({
//   //   required String productId,
//   //   required int quantity,
//   //   required int packagingSize,
//   // }) async {
//   //   _loading = true;
//   //   notifyListeners();

//   //   try {
//   //     await _cartService.updatecartquanty(productId, quantity, packagingSize);

//   //        final carts = _cartItems!.items;
//   //     // update local object immediately
//   //     final index = carts.indexWhere((c) =>
//   //         c.productId == productId && c.packaging == packagingSize);

//   //     if (index != -1) {
//   //       carts[index] =
//   //         carts[index].copyWith(quantity: quantity);
//   //     }

//   //   } catch (e) {
//   //     _error = e.toString();
//   //   }

//   //   _loading = false;
//   //   notifyListeners();
//   // }

//   // -------------------------
//   // CLEAR CART ERROR
//   // -------------------------
//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }

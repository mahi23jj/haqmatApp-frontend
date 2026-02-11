import 'dart:convert';

import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartLocalDataSource {
  CartLocalDataSource({Box<CartModelList>? box})
    : _box = box ?? Hive.box<CartModelList>(cartBoxName);

  static const String cartBoxName = 'cartBox';
  static const String _cacheKey = 'cache';
  static const String _legacyPrefsKey = 'cart_cache_v1';

  final Box<CartModelList> _box;

  Future<CartModelList?> readCart() async {
    return _box.get(_cacheKey);
  }

  Future<void> saveCart(CartModelList cart) async {
    await _box.put(_cacheKey, cart);
  }

  Future<void> clearCart() async {
    await _box.delete(_cacheKey);
  }

  Future<void> migrateFromSharedPrefsIfNeeded() async {
    if (_box.containsKey(_cacheKey)) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_legacyPrefsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final cart = _cartFromCacheJson(decoded);
      await _box.put(_cacheKey, cart);
      await prefs.remove(_legacyPrefsKey);
    } catch (_) {
      return;
    }
  }

  CartModelList _cartFromCacheJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List?) ?? [];
    final items = itemsJson
        .whereType<Map<String, dynamic>>()
        .map(_cartItemFromCacheJson)
        .toList();

    final locationJson = (json['location'] as Map<String, dynamic>?) ?? {};
    final location = LocationModel(
      id: locationJson['id']?.toString() ?? '',
      name: locationJson['name']?.toString() ?? '',
    );

    return CartModelList(
      items: items,
      location: location,
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      subtotalPrice: (json['subtotalPrice'] as num?)?.toInt() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toInt() ?? 0,
      totalPrice: (json['totalPrice'] as num?)?.toInt() ?? 0,
    );
  }

  CartModel _cartItemFromCacheJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      packaging: (json['packaging'] as num?)?.toInt() ?? 0,
      tefftype: json['tefftype']?.toString() ?? '',
      quality: json['quality']?.toString() ?? '',
      totalprice: (json['totalprice'] as num?)?.toInt() ?? 0,
    );
  }
}

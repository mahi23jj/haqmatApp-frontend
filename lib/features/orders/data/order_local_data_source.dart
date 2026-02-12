import 'dart:convert';

import 'package:haqmate/features/orders/model/order.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderLocalDataSource {
  OrderLocalDataSource({Box<dynamic>? box})
    : _box = box ?? Hive.box(orderBoxName);

  static const String orderBoxName = 'orderBox';
  static const String _cacheKey = 'cache';
  static const String _legacyPrefsKey = 'orders_cache_v1';

  final Box<dynamic> _box;

  Future<List<OrderModel>?> readOrders() async {
    final raw = _box.get(_cacheKey);
    if (raw is List<OrderModel>) {
      return raw;
    }
    if (raw is List) {
      return raw
          .map((item) {
            if (item is OrderModel) return item;
            if (item is Map<String, dynamic>) {
              return OrderModel.fromJson(item);
            }
            if (item is Map) {
              return OrderModel.fromJson(
                item.map(
                  (key, value) => MapEntry(key.toString(), value),
                ),
              );
            }
            return null;
          })
          .whereType<OrderModel>()
          .toList();
    }
    return null;
  }

  Future<void> saveOrders(List<OrderModel> orders) async {
    await _box.put(_cacheKey, orders);
  }

  Future<void> clearOrders() async {
    await _box.delete(_cacheKey);
  }

  Future<void> migrateFromSharedPrefsIfNeeded() async {
    if (_box.containsKey(_cacheKey)) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_legacyPrefsKey);
    if (raw == null || raw.isEmpty) return;

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final orders = decoded
          .whereType<Map<String, dynamic>>()
          .map(OrderModel.fromJson)
          .toList();
      await _box.put(_cacheKey, orders);
      await prefs.remove(_legacyPrefsKey);
    } catch (_) {
      return;
    }
  }
}

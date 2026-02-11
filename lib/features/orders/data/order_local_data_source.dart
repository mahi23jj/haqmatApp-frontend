import 'dart:convert';

import 'package:haqmate/features/orders/model/order.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderLocalDataSource {
  OrderLocalDataSource({Box<List<OrderModel>>? box})
    : _box = box ?? Hive.box<List<OrderModel>>(orderBoxName);

  static const String orderBoxName = 'orderBox';
  static const String _cacheKey = 'cache';
  static const String _legacyPrefsKey = 'orders_cache_v1';

  final Box<List<OrderModel>> _box;

  Future<List<OrderModel>?> readOrders() async {
    return _box.get(_cacheKey);
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

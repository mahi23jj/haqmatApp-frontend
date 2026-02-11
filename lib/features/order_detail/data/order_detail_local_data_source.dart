import 'dart:convert';

import 'package:haqmate/features/order_detail/model/order_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailLocalDataSource {
  OrderDetailLocalDataSource({Box<OrderData>? box})
    : _box = box ?? Hive.box<OrderData>(orderDetailBoxName);

  static const String orderDetailBoxName = 'orderDetailBox';
  static const String _legacyPrefsKeyPrefix = 'order_detail_cache_v1_';

  final Box<OrderData> _box;

  Future<OrderData?> readOrder(String id) async {
    return _box.get(id);
  }

  Future<void> saveOrder(String id, OrderData order) async {
    await _box.put(id, order);
  }

  Future<void> clearOrder(String id) async {
    await _box.delete(id);
  }

  Future<void> migrateFromSharedPrefsIfNeeded(List<String> orderIds) async {
    final prefs = await SharedPreferences.getInstance();

    for (final id in orderIds) {
      if (_box.containsKey(id)) continue;

      final legacyKey = '$_legacyPrefsKeyPrefix$id';
      final raw = prefs.getString(legacyKey);
      if (raw == null || raw.isEmpty) continue;

      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        final order = OrderData.fromJson(decoded);
        await _box.put(id, order);
        await prefs.remove(legacyKey);
      } catch (_) {
        continue;
      }
    }
  }
}

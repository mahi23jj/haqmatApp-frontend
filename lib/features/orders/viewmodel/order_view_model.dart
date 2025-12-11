import 'package:flutter/material.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:haqmate/features/orders/service/order_repo.dart';

class OrdersViewModel extends ChangeNotifier {
  final OrdersRepository _repo = OrdersRepository();

  List<OrderItem> orders = [];
  List<OrderItem> filtered = [];

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  String activeFilter = "All";

  OrdersViewModel() {
    load();
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      orders = await _repo.fetchOrders();
      print(orders);
      applyFilter("All");
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<String> createorder(
    List<Map<String, dynamic>> products,
    String locationid,
    String phoneNumber,
    String orderReceived,
    String paymentMethod,
  ) async {
    print('created order $products, $locationid, $phoneNumber, $orderReceived, $paymentMethod');
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final value = await _repo.createMultiOrder(
        products: products,
        location: locationid,
        phoneNumber: phoneNumber,
        orderReceived: orderReceived,
        paymentMethod: paymentMethod,
      );
      print('created multi order $value');
      notifyListeners();
      return value;
      // applyFilter("All");
    } catch (e) {
      _error = e.toString();
      return _error!;
    }

    // _loading = false;
    // notifyListeners();
  }

  void applyFilter(String filter) {
    activeFilter = filter;

    if (filter == "All") {
      filtered = orders;
    } else {
      filtered = orders.where((o) => o.status == filter).toList();
    }

    notifyListeners();
  }
}

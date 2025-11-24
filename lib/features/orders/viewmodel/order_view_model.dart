import 'package:flutter/material.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:haqmate/features/orders/service/order_repo.dart';

class OrdersViewModel extends ChangeNotifier {
  final OrdersRepository _repo = OrdersRepository();

  List<OrderItem> orders = [];
  List<OrderItem> filtered = [];

  bool loading = true;

  String activeFilter = "All";

  OrdersViewModel() {
    load();
  }

  Future<void> load() async {
    loading = true;
    notifyListeners();

    orders = await _repo.fetchOrders();

    applyFilter("All");

    loading = false;
    notifyListeners();
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


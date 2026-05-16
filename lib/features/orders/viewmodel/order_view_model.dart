import 'package:flutter/material.dart';
import 'package:haqmate/features/orders/data/order_local_data_source.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:haqmate/features/orders/service/order_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersViewModel extends ChangeNotifier {
  final OrdersRepository _repo = OrdersRepository();
  final OrderLocalDataSource _localDataSource = OrderLocalDataSource();

  List<OrderModel> orders = [];
  List<OrderModel> filtered = [];

  // late PaymentIntentModel value;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  OrderStatus? activeFilter;

  OrdersViewModel() {
    load();
  }

  // -------------------------
  // CACHE HELPERS
  // -------------------------
  Future<void> _saveCache() async {
    await _localDataSource.saveOrders(orders);
  }

  Future<List<OrderModel>?> _readCache() async {
    return _localDataSource.readOrders();
  }

  Future<void> clearCache() async {
    await _localDataSource.clearOrders();
  }

  Future<void> load({bool refresh = false}) async {
    if (!refresh) {
      final cached = await _readCache();
      if (cached != null) {
        orders = cached;
        applyFilter(activeFilter);
        _error = null;
        notifyListeners();
      }
    }

    _loading = refresh || orders.isEmpty;
    _error = null;
    notifyListeners();

    try {
      orders = await _repo.fetchOrders();
      applyFilter(activeFilter);
      await _saveCache();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  // loadorder
  // Future<void> loadOrder(String orderId) async {
  //   _loading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final order = await _repo.fetchOrder(orderId);
  //     final index = orders.indexWhere((o) => o.id == orderId);
  //     if (index != -1) {
  //       orders[index] = order;
  //     } else {
  //       orders.add(order);
  //     }
  //     applyFilter(activeFilter);
  //     notifyListeners();
  //   } catch (e) {
  //     _error = e.toString();
  //   }

  //   _loading = false;
  //   notifyListeners();
  // }

  void applyFilter(OrderStatus? filter) {
    activeFilter = filter;

    if (filter == null) {
      filtered = orders;
    } else {
      filtered = orders.where((o) => o.status == filter).toList();
    }

    notifyListeners();
  }

  OrderUiConfig uiConfigFor(OrderModel order) {
    final paymentTags = <String>[];
    final deliveryTags = <String>[];
    final actions = <OrderAction>[OrderAction.track];
    String? declineReason;

    switch (order.status) {
      case OrderStatus.pendingPayment:
        paymentTags.add(order.paymentStatus.label);
        if (order.paymentStatus == PaymentStatus.pending ||
            order.paymentStatus == PaymentStatus.failed) {
          actions.insert(0, OrderAction.pay);
        }
        break;

      case OrderStatus.toBeDelivered:
        paymentTags.add(PaymentStatus.confirmed.label);
        deliveryTags.add(order.deliveryStatus.label);
        break;

      case OrderStatus.completed:
        paymentTags.add(PaymentStatus.confirmed.label);
        deliveryTags.add(DeliveryStatus.delivered.label);
        break;

      case OrderStatus.cancelled:
        paymentTags.add(PaymentStatus.declined.label);
        declineReason = order.paymentDeclineReason ?? order.cancelReason;
        break;

      case OrderStatus.unknown:
        paymentTags.add(order.paymentStatus.label);
        break;
    }

    return OrderUiConfig(
      paymentTags: paymentTags,
      deliveryTags: deliveryTags,
      actions: actions,
      declineReason: declineReason,
      deliveryDate: order.deliveryDate,
    );
  }

  Future<void> contactSeller(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void handleAction(OrderAction action, OrderModel order) {
    debugPrint('Order action: ${action.name} for order ${order.id}');
  }
}

enum OrderAction { pay, track }

class OrderUiConfig {
  final List<String> paymentTags;
  final List<String> deliveryTags;
  final List<OrderAction> actions;
  final String? declineReason;
  final DateTime? deliveryDate;

  const OrderUiConfig({
    required this.paymentTags,
    required this.deliveryTags,
    required this.actions,
    required this.declineReason,
    required this.deliveryDate,
  });
}

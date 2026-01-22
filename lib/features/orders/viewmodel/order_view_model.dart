import 'package:flutter/material.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:haqmate/features/orders/service/order_repo.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersViewModel extends ChangeNotifier {
  final OrdersRepository _repo = OrdersRepository();

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

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      orders = await _repo.fetchOrders();
      applyFilter(null);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

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
    RefundStatus? refundTag;

    switch (order.status) {
      case OrderStatus.pendingPayment:
        paymentTags.add(order.paymentStatus.label);
        if (order.paymentStatus == PaymentStatus.pending ||
            order.paymentStatus == PaymentStatus.failed) {
          actions.insert(0, OrderAction.pay);
        }
        if (order.paymentStatus == PaymentStatus.screenshotSent) {
          actions.insert(0, OrderAction.cancel);
        }
        break;

      case OrderStatus.toBeDelivered:
        paymentTags.add(PaymentStatus.confirmed.label);
        deliveryTags.add(order.deliveryStatus.label);
        if (order.deliveryStatus == DeliveryStatus.notScheduled) {
          actions.insert(0, OrderAction.cancel);
        }
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

    if (order.paymentStatus == PaymentStatus.refunded) {
      refundTag = order.refundStatus;
    }

    return OrderUiConfig(
      paymentTags: paymentTags,
      deliveryTags: deliveryTags,
      actions: actions,
      declineReason: declineReason,
      refundStatus: refundTag,
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
    // Placeholder for future integration with payment/cancellation flows.
    debugPrint('Order action: ${action.name} for order ${order.id}');
  }
}

enum OrderAction { pay, cancel, track }

class OrderUiConfig {
  final List<String> paymentTags;
  final List<String> deliveryTags;
  final List<OrderAction> actions;
  final String? declineReason;
  final RefundStatus? refundStatus;
  final DateTime? deliveryDate;

  const OrderUiConfig({
    required this.paymentTags,
    required this.deliveryTags,
    required this.actions,
    required this.declineReason,
    required this.refundStatus,
    required this.deliveryDate,
  });
}

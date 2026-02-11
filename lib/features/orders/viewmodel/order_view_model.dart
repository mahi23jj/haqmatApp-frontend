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

  // Per-order cancel loading state for button feedback
  final Map<String, bool> _cancelLoading = {};
  bool isCancelling(String orderId) => _cancelLoading[orderId] == true;

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
    debugPrint('Order action: ${action.name} for order ${order.id}');
  }

  Future<void> cancelOrder(BuildContext context, String orderId) async {
    _cancelLoading[orderId] = true;
    notifyListeners();

    try {
      await _repo.cancelOrder(orderId);
      await load(refresh: true);
      _cancelLoading[orderId] = false;
      notifyListeners();

      if (!context.mounted) return;

      // Success dialog asking for refund
      final shouldRequest = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Order canceled'),
            content: const Text(
              'Successful canceled. Do you want to request a refund?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );

      if (!context.mounted) return;
      if (shouldRequest == true) {
        await _showRefundDialog(context, orderId);
      }
    } catch (e) {
      _cancelLoading[orderId] = false;
      notifyListeners();

      if (!context.mounted) return;

      // Error dialog with try again
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Cancellation Failed'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  cancelOrder(context, orderId);
                },
                child: const Text('Try Again'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showRefundDialog(BuildContext context, String orderId) async {
    final accNameCtrl = TextEditingController();
    final accNumberCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            bool submitting = false;
            return AlertDialog(
              title: const Text('Request Refund'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: accNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Account Name',
                      ),
                    ),
                    TextField(
                      controller: accNumberCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Account Number',
                      ),
                    ),
                    TextField(
                      controller: reasonCtrl,
                      decoration: const InputDecoration(labelText: 'Reason'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (accNameCtrl.text.trim().isEmpty ||
                        accNumberCtrl.text.trim().isEmpty ||
                        reasonCtrl.text.trim().isEmpty) {
                      // simple validation
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }
                    setState(() => submitting = true);
                    try {
                      await _repo.requestRefund(
                        orderId: orderId,
                        accountName: accNameCtrl.text.trim(),
                        accountNumber: accNumberCtrl.text.trim(),
                        reason: reasonCtrl.text.trim(),
                      );
                      setState(() => submitting = false);
                      Navigator.pop(ctx);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Refund requested successfully'),
                        ),
                      );
                      await load(refresh: true);
                    } catch (e) {
                      setState(() => submitting = false);
                      if (!context.mounted) return;
                      showDialog<void>(
                        context: context,
                        builder: (ctx2) => AlertDialog(
                          title: const Text('Refund Failed'),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx2),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Refund'),
                ),
              ],
            );
          },
        );
      },
    );
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

import 'package:flutter/material.dart';
import 'package:haqmate/features/order_detail/service/order_detail_service.dart';
import 'package:haqmate/features/orders/model/order.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/order_model.dart';

class OrderdetailViewModel extends ChangeNotifier {
  final OrdersDetailRepository orderdetail = OrdersDetailRepository();

  OrderModel? _order;
  bool _loading = false;
  String? _error;

  OrderModel? get order => _order;
  bool get loading => _loading;
  String? get error => _error;

  // -------------------------
  // FETCH CART ITEMS
  // -------------------------
  Future<void> loadorderdetail(String id) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _order = await orderdetail.fetchOrderDetail(id);
      print('order_item $_order');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> callSeller(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch phone dialer';
    }
    notifyListeners();
  }

  // --- Computed UI helpers --- //
  bool get showPaymentProof {
    final o = _order;
    return o != null &&
        o.paymentStatus == PaymentStatus.screenshotSent &&
        (o.paymentProofUrl?.isNotEmpty ?? false);
  }

  bool get showConfirmedPaymentTag {
    final o = _order;
    return o != null && o.status == OrderStatus.toBeDelivered;
  }

  String? get deliveryStatusTagLabel {
    final o = _order;
    if (o == null) return null;
    if (o.status == OrderStatus.toBeDelivered) {
      return o.deliveryStatus.label;
    }
    return null;
  }

  String? get deliveryDateFormatted {
    final o = _order;
    if (o == null) return null;
    if (o.deliveryStatus == DeliveryStatus.scheduled && o.deliveryDate != null) {
      return _formatDate(o.deliveryDate!);
    }
    return null;
  }

  bool get showDeclineReason {
    final o = _order;
    return o != null &&
        o.status == OrderStatus.cancelled &&
        o.paymentStatus == PaymentStatus.declined &&
        (o.paymentDeclineReason?.isNotEmpty ?? false);
  }

  bool get showRefundTag {
    final o = _order;
    return o != null && o.paymentStatus == PaymentStatus.refunded;
  }

  bool get showRefundRejectReason {
    final o = _order;
    return o != null &&
        o.refundStatus == RefundStatus.rejected &&
        (o.cancelReason?.isNotEmpty ?? false);
  }

  String _formatDate(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays >= 365) {
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
    if (diff.inDays >= 30) return '${d.month}-${d.day}-${d.year}';
    if (diff.inDays >= 7) return '${diff.inDays ~/ 7}w ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'just now';
  }
}

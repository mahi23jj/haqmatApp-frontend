import 'package:flutter/material.dart';
import 'package:haqmate/features/order_detail/service/order_detail_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/order_model.dart';

class OrderdetailViewModel extends ChangeNotifier {
  final OrdersDetailRepository orderdetail = OrdersDetailRepository();

  OrderData? _order;
  bool _loading = false;
  String? _error;

  OrderData? get order => _order;
  bool get loading => _loading;
  String? get error => _error;

  OrderStatus? get _statusEnum => _parseOrderStatus(_order?.status);
  PaymentStatus? get _paymentStatusEnum => _parsePaymentStatus(_order?.paymentstatus);
  DeliveryStatus? get _deliveryStatusEnum => _parseDeliveryStatus(_order?.deliverystatus);
  RefundStatus? get _refundStatusEnum => _parseRefundStatus(_order?.refundstatus);

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
        _paymentStatusEnum == PaymentStatus.SCREENSHOT_SENT &&
        (o.paymentProofUrl.isNotEmpty);
  }

  bool get showConfirmedPaymentTag {
    final o = _order;
    return o != null && _statusEnum == OrderStatus.TO_BE_DELIVERED;
  }

  String? get deliveryStatusTagLabel {
    final o = _order;
    if (o == null) return null;
    if (_statusEnum == OrderStatus.TO_BE_DELIVERED) {
      return o.deliverystatus;
    }
    return null;
  }

  String? get deliveryDateFormatted {
    final o = _order;
    if (o == null) return null;
    if (_deliveryStatusEnum == DeliveryStatus.SCHEDULED && o.deliveryDate != null) {
      return _formatDate(DateTime.parse(o.deliveryDate!));
    }
    return null;
  }

  bool get showDeclineReason {
    final o = _order;
    return o != null &&
        _statusEnum == OrderStatus.CANCELLED &&
        _paymentStatusEnum == PaymentStatus.DECLINED &&
        (o.cancelReason.isNotEmpty);
  }

  bool get showRefundTag {
    final o = _order;
    return o != null && _paymentStatusEnum == PaymentStatus.REFUNDED;
  }

  bool get showRefundRejectReason {
    final o = _order;
    return o != null &&
        _refundStatusEnum == RefundStatus.REJECTED &&
        (o.cancelReason.isNotEmpty);
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

  String _normalize(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    return value.trim().replaceAll('-', '_').toUpperCase();
  }

  OrderStatus _parseOrderStatus(String? value) {
    switch (_normalize(value)) {
      case 'PENDING_PAYMENT':
        return OrderStatus.PENDING_PAYMENT;
      case 'TO_BE_DELIVERED':
        return OrderStatus.TO_BE_DELIVERED;
      case 'COMPLETED':
        return OrderStatus.COMPLETED;
      case 'CANCELLED':
        return OrderStatus.CANCELLED;
      default:
        return OrderStatus.UNKNOWN;
    }
  }

  PaymentStatus _parsePaymentStatus(String? value) {
    switch (_normalize(value)) {
      case 'PENDING':
        return PaymentStatus.PENDING;
      case 'SCREENSHOT_SENT':
        return PaymentStatus.SCREENSHOT_SENT;
      case 'FAILED':
        return PaymentStatus.FAILED;
      case 'CONFIRMED':
        return PaymentStatus.CONFIRMED;
      case 'DECLINED':
        return PaymentStatus.DECLINED;
      case 'REFUNDED':
        return PaymentStatus.REFUNDED;
      default:
        return PaymentStatus.UNKNOWN;
    }
  }

  DeliveryStatus _parseDeliveryStatus(String? value) {
    switch (_normalize(value)) {
      case 'NOT_SCHEDULED':
        return DeliveryStatus.NOT_SCHEDULED;
      case 'SCHEDULED':
        return DeliveryStatus.SCHEDULED;
      case 'DELIVERED':
        return DeliveryStatus.DELIVERED;
      default:
        return DeliveryStatus.UNKNOWN;
    }
  }

  RefundStatus _parseRefundStatus(String? value) {
    switch (_normalize(value)) {
      case 'NOT_STARTED':
        return RefundStatus.NOT_STARTED;
      case 'PENDING':
        return RefundStatus.PENDING;
      case 'APPROVED':
        return RefundStatus.APPROVED;
      case 'REJECTED':
        return RefundStatus.REJECTED;
      default:
        return RefundStatus.UNKNOWN;
    }
  }
}

enum OrderStatus {
  PENDING_PAYMENT,
  TO_BE_DELIVERED,
  COMPLETED,
  CANCELLED,
  UNKNOWN,
}

enum PaymentStatus {
  PENDING,
  SCREENSHOT_SENT,
  FAILED,
  CONFIRMED,
  DECLINED,
  REFUNDED,
  UNKNOWN,
}

enum DeliveryStatus {
  NOT_SCHEDULED,
  SCHEDULED,
  DELIVERED,
  UNKNOWN,
}

enum RefundStatus {
  NOT_STARTED,
  PENDING,
  APPROVED,
  REJECTED,
  UNKNOWN,
}

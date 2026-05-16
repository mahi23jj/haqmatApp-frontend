import 'package:flutter/material.dart';
import 'package:haqmate/features/order_detail/data/order_detail_local_data_source.dart';
import 'package:haqmate/features/order_detail/service/order_detail_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/order_model.dart';

class OrderdetailViewModel extends ChangeNotifier {
  final OrdersDetailRepository orderdetail = OrdersDetailRepository();
  final OrderDetailLocalDataSource _localDataSource =
      OrderDetailLocalDataSource();

  OrderData? _order;
  bool _loading = false;
  String? _error;

  OrderData? get order => _order;
  bool get loading => _loading;
  String? get error => _error;

  OrderStatus? get _statusEnum => _parseOrderStatus(_order?.status);
  PaymentStatus? get _paymentStatusEnum =>
      _parsePaymentStatus(_order?.paymentstatus);
  DeliveryStatus? get _deliveryStatusEnum =>
      _parseDeliveryStatus(_order?.deliverystatus);

  // -------------------------
  // CACHE HELPERS
  // -------------------------
  Future<void> _saveCache(String id) async {
    final order = _order;
    if (order == null) return;
    await _localDataSource.saveOrder(id, order);
  }

  Future<OrderData?> _readCache(String id) async {
    return _localDataSource.readOrder(id);
  }

  Future<void> clearCache(String id) async {
    await _localDataSource.clearOrder(id);
  }

  // -------------------------
  // FETCH ORDER ITEMS
  // -------------------------
  Future<void> loadorderdetail(String id, {bool refresh = false}) async {
    if (!refresh) {
      final cached = await _readCache(id);
      if (cached != null) {
        _order = cached;
        _error = null;
        notifyListeners();
      }
    }

    _loading = refresh || _order == null;
    _error = null;
    notifyListeners();

    try {
      _order = await orderdetail.fetchOrderDetail(id);
      await _saveCache(id);
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
    if (o == null || _deliveryStatusEnum != DeliveryStatus.SCHEDULED) {
      return null;
    }

    final rawDate = o.deliveryDate?.trim();
    if (rawDate == null || rawDate.isEmpty) return null;

    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return null;

    return _formatDate(parsed);
  }

  bool _hasMeaningfulText(String? value) {
    if (value == null) return false;
    final normalized = value.trim();
    return normalized.isNotEmpty && normalized.toLowerCase() != 'null';
  }

  String _cleanText(String value) {
    if (!_hasMeaningfulText(value)) return '';
    return value.trim();
  }

  String get cancelReasonText {
    final o = _order;
    if (o == null) return '';
    return _cleanText(o.cancelReason);
  }


  bool get showDeclineReason {
    final o = _order;
    return o != null &&
        _statusEnum == OrderStatus.CANCELLED &&
        _paymentStatusEnum == PaymentStatus.DECLINED &&
        _hasMeaningfulText(o.cancelReason);
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
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

enum DeliveryStatus { NOT_SCHEDULED, SCHEDULED, DELIVERED, UNKNOWN }


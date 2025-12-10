import 'package:flutter/material.dart';
import 'package:haqmate/features/order_detail/service/order_detail_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/order_model.dart';

class OrderdetailViewModel extends ChangeNotifier {
  final OrdersDetailRepository orderdetail = OrdersDetailRepository();

  OrderDetails? _order;
  bool _loading = false;
  String? _error;

  OrderDetails? get order => _order;
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
      _order = await orderdetail.fetchOrdersdetail(id);
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
}

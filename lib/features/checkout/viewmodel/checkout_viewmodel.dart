// checkout_viewmodel.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/checkout/service/checkout_service.dart';


class CheckoutViewModel extends ChangeNotifier {
  /* final CheckoutService service;
  final String userId; // pass current user id

  CheckoutViewModel({required this.service, required this.userId}); */


   final CheckoutService service = CheckoutService();

  // initial cart snapshot (passed from cart page)
  late CartModelList cart;

  // UI state
  LocationModel? selectedLocation;
  String phoneNumber = '';
  bool saveAsDefault = false;

  // suggestions for search-as-you-type
  List<LocationModel> suggestions = [];
  bool loadingSuggestions = false;

  // order state
  bool processingOrder = false;
  String? errorMessage;
  Map<String, dynamic>? lastOrderResponse;

  // debounce
  Timer? _debounce;

  void initFromCart(CartModelList cartModel) {
    cart = cartModel;
    selectedLocation = cart.location;
    phoneNumber = cart.phoneNumber;
    notifyListeners();
  }

  // compute fees
  int get subtotal => cart.totalPrice;
  int get deliveryFee => selectedLocation?.deliveryFee ?? cart.location.deliveryFee;
  int get total => subtotal + deliveryFee;

  void updatePhone(String phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  void toggleSaveAsDefault(bool v) {
    saveAsDefault = v;
    notifyListeners();
  }

  void selectLocation(LocationModel loc) {
    selectedLocation = loc;
    suggestions = [];
    notifyListeners();
  }

  /// search locations with debounce (search while typing)
  void searchLocations(String query) {
    _debounce?.cancel();
    if (query.isEmpty) {
      suggestions = [];
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      loadingSuggestions = true;
      notifyListeners();
      try {
        final list = await service.searchLocations(query);
        suggestions = list;
      } catch (e) {
        suggestions = [];
      } finally {
        loadingSuggestions = false;
        notifyListeners();
      }
    });
  }

 /*  Future<bool> placeOrder() async {
    processingOrder = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await service.placeOrder(
        userId: userId,
        location: selectedLocation ?? cart.location,
        phoneNumber: phoneNumber,
        items: cart.items,
        deliveryFee: deliveryFee,
        subtotal: subtotal,
        total: total,
        saveAsDefault: saveAsDefault,
      );

      lastOrderResponse = response;
      processingOrder = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      processingOrder = false;
      notifyListeners();
      return false;
    }
  } */

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

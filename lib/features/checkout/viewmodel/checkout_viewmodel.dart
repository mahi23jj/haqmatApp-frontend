import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/checkout/model/checkout_model.dart';
import 'package:haqmate/features/checkout/service/checkout_service.dart';

class CheckoutViewModel extends ChangeNotifier {
  final CheckoutService service = CheckoutService();

  // Initial cart snapshot
  late CartModelList cart;

  // Controllers for UI
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Location + phone
  LocationModel? selectedLocation;

   PaymentIntentResponse? chapaIntent;

  // Search UI state
  List<LocationModel> suggestions = [];
  bool loadingSuggestions = false;

  // Order state
  bool saveAsDefault = false;
  String? errorMessage;
  String? _error;
  Timer? _debounce;
  Map<String, dynamic>? lastOrderResponse;

  // Computed fees
  int get subtotal => cart.totalPrice;

  int get deliveryFee =>
      selectedLocation?.deliveryFee ?? cart.location.deliveryFee;

  int get total => subtotal + deliveryFee;

  String get error => _error ?? "";





  // ------------------------------------
  // INIT FROM CART
  // ------------------------------------
  void initFromCart(CartModelList cartModel) {
    cart = cartModel;

    // initial values
    selectedLocation = cart.location;

    locationController.text = cart.location.name;
    phoneController.text = cart.phoneNumber ?? "";

    notifyListeners();
  }

  // ------------------------------------
  // PHONE UPDATE
  // ------------------------------------
  void updatePhone(String phone) {
    phoneController.text = phone;
    notifyListeners();
  }

  // ------------------------------------
  // SELECT LOCATION
  // ------------------------------------
  void selectLocation(LocationModel loc) {
    selectedLocation = loc;
    locationController.text = loc.name; // show selected location
    suggestions = []; // hide dropdown
    notifyListeners();
  }

  // ------------------------------------
  // SAVE DEFAULT
  // ------------------------------------
  Future<void> saveDefault(String locationId, String phone) async {
      print("saveDefault, $locationId, $phone");

    try {
      await service.updateuserstatus(locationId, phone);
      saveAsDefault = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ------------------------------------
  // SEARCH LOCATIONS (DEBOUNCE)
  // ------------------------------------
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
        final results = await service.searchLocations(query);
        suggestions = results;
      } catch (_) {
        suggestions = [];
      }

      loadingSuggestions = false;
      notifyListeners();
    });
  }


  Future<void> createChapaPayment({
    required String orderId,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    // _loading = true;
    notifyListeners();

    try {
      chapaIntent = await service.createChapaIntent(
        orderId: orderId,
        currency: "ETB",
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
    } catch (e) {
      print("❌ Chapa Intent Error: $e");
    }

    // loading = false;
    notifyListeners();
  }


  // ------------------------------------
  // DISPOSE
  // ------------------------------------
  @override
  void dispose() {
    _debounce?.cancel();
    locationController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}

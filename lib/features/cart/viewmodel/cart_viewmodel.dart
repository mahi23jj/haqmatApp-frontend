import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';

class CartViewModel extends ChangeNotifier {
  List<CartModel> CartModels = [
    CartModel(
        name: "CLUB C 85 LOONEY TUNES",
        price: 1200,
        imageUrl: "assets/images/injera.jpg"),
    CartModel(
        name: "AF1 CRATER FLYKNIT NN (GS)",
        price: 670,
        imageUrl: "assets/images/injera.jpg"),
    CartModel(
        name: "BLAZER LOW PLATFORM (W)",
        price: 880,
        imageUrl: "assets/images/injera.jpg"),
  ];

  void increment(CartModel CartModel) {
    CartModel.quantity++;
    notifyListeners();
  }

  void decrement(CartModel CartModel) {
    if (CartModel.quantity > 1) {
      CartModel.quantity--;
      notifyListeners();
    }
  }

  double get subtotal =>
      CartModels.fold(0, (sum, item) => sum + item.price * item.quantity);

  double get deliveryFee => 2;

  double get total => subtotal + deliveryFee;
}
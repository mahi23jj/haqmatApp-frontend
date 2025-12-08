import 'package:flutter/material.dart';
import 'package:haqmate/features/checkout/model/checkout_model.dart';


class CheckoutViewModel extends ChangeNotifier {
  // Fake data
  List<Address> addresses = [
    Address(location: 'Piazza, Addis Ababa', detail: 'eoeppo2'),
    Address(location: 'Bole, Addis Ababa', detail: 'House 23')
  ];

  List<PaymentMethod> paymentMethods = [
    PaymentMethod(name: 'Pay with Chapa', description: 'Secure online payment'),
    PaymentMethod(name: 'Cash on Delivery', description: 'Pay when you receive'),
  ];

  // Selected values
  Address? selectedAddress;
  PaymentMethod? selectedPayment;

  CheckoutViewModel() {
    selectedAddress = addresses.first;
    selectedPayment = paymentMethods.last;
  }

  void selectAddress(Address address) {
    selectedAddress = address;
    notifyListeners();
  }

  void selectPayment(PaymentMethod payment) {
    selectedPayment = payment;
    notifyListeners();
  }

  double get totalFee => 50.0; // Fake total fee
  double get deliveryFee => 5.0;
  double get totalAmount => totalFee + deliveryFee;

  void payNow() {
    // Fake pay logic
    print('Payment done for ${selectedPayment?.name}');
    print('Delivery to: ${selectedAddress?.location}, ${selectedAddress?.detail}');
  }
}

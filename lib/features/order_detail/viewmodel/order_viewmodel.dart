import 'package:flutter/material.dart';
import '../model/order_model.dart';

class OrderdetailViewModel extends ChangeNotifier {
  late OrderDetails order;

  OrderdetailViewModel() {
    loadFakeData();
  }

  void loadFakeData() {
    order = OrderDetails(
      orderId: "#TF2024-1234",
      username: "Mahlet Bekele",
      address: "Bole, Addis Ababa, Ethiopia",
      deliveryFee: 150,
      tracking: [
        OrderTrackingStep(
            title: "Order Placed",
            date: "Nov 4, 2025 - 10:30 AM",
            completed: true),
        OrderTrackingStep(
            title: "Order Confirmed",
            date: "Nov 4, 2025 - 11:15 AM",
            completed: true),
        OrderTrackingStep(
            title: "Packing in Progress",
            date: "Nov 5, 2025 - 09:00 AM",
            completed: true),
        OrderTrackingStep(
            title: "Out for Delivery",
            date: "Estimated: Nov 7, 2025",
            completed: false),
        OrderTrackingStep(
            title: "Delivered",
            date: "Estimated: Nov 8, 2025",
            completed: false),
      ],
      items: [
        OrderItem(
          name: "Pure White Teff",
          origin: "Grown in Gojjam",
          quantity: 2,
          price: 4500,
          image:
              "assets/images/teff.jpg",
        ),
        OrderItem(
          name: "Pure White Teff",
          origin: "Grown in Gojjam",
          quantity: 2,
          price: 4500,
          image:
              "assets/images/teff.jpg",
        ),
        OrderItem(
          name: "Pure White Teff",
          origin: "Grown in Gojjam",
          quantity: 2,
          price: 4500,
          image:
              "assets/images/teff.jpg",
        ),
      ],
    );

    notifyListeners();
  }
}

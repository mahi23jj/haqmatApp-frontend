import 'package:haqmate/features/orders/model/order.dart';

class OrdersRepository {
  Future<List<OrderItem>> fetchOrders() async {
    await Future.delayed(Duration(milliseconds: 800));

    return [
      OrderItem(
        id: "TF2024-1189",
        amount: 5400,
        stage: 4,
        status: "Delivered",
        date: DateTime(2025, 10, 28),
        imageUrls: [
          "assets/images/teff.jpg",
          "assets/images/injera.jpg",
        ],
      ),
      OrderItem(
        id: "TF2024-0945",
        amount: 2700,
        stage: 1,
        status: "Pending",
        date: DateTime(2025, 10, 2),
        imageUrls: [
          "assets/images/teff.jpg",
        ],
      )
    ];
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<String> imageUrls;
  final String status;
  final int stage; // 1–4 (Ordered, Packed, Shipped, Delivered)
  final DateTime date;

  OrderItem({
    required this.id,
    required this.amount,
    required this.imageUrls,
    required this.status,
    required this.stage,
    required this.date,
  });
}

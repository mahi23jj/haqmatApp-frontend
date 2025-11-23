class CartModel {
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartModel({
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}
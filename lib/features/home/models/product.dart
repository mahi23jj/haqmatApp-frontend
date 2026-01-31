class ProductModel {
final String id;
final String name;
final String imageUrl;
final double price;
final String teffType;


ProductModel({required this.id, required this.name, required this.imageUrl, required this.price, required this.teffType});

// from json
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['images'][0],
      teffType: json['teffType'] ?? "",
      price: json['price'],);
  }

}
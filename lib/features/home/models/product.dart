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
      price: json['price'].toDouble(),);
  }

}

//I/flutter ( 9349): {status: success, message: Retrieve all products, data: [{id: 7507c538-8aea-4fc1-9483-0c97688160ce, name: ነጭ ደረጃ 2 ጤፍ, images: [https://tse1.mm.bing.net/th/id/OIP.EXvCtA6XsqzuYYELpQUAfwHaE7?rs=1&pid=ImgDetMain&o=7&rm=3], description: ይህ ከጎጃም የመጣ ደረጃ 2 ነጭ ጤፍ ነው።, price: 130, teffType: ነጭ ጤፍ, createdAt: 2026-01-31T23:19:58.295Z, updatedAt: 2026-02-10T19:03:45.530Z, quality: ደረጃ 2}], pagination: {page: 1, limit: 20, total: 1, totalPages: 1}}
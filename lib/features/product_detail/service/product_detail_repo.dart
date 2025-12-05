import 'dart:convert';

import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:haqmate/features/product_detail/model/products.dart';
import 'package:http/http.dart' as Http;

class ProductDetailRepo {
  Future<Product> fetchProductById(String id) async {
    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}/api/products/$id'),
        headers: {'Content-Type': 'application/json'},
      );

    

      if (response.statusCode == 201) {
        final body = jsonDecode(response.body);
       

        // If API returns { "data": [...] }
        final productsJson = body["data"] ?? body;

        // if (productsJson is! List) {
        //   throw Exception("Invalid data format");
        // }

        final products = Product.fromJson(productsJson);

        print('product detail $products');

        return products;
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Product fetchProductById(String id) {
  //   // simulate network
  //   // await Future.delayed(Duration(milliseconds: 800));

  //   // Use the uploaded image path (the environment will transform this path).
  //   // Path provided by assistant: /mnt/data/9224a33d-c4b5-4563-bf64-990ffce32c93.png
  //   const localImagePath = 'assets/images/teff.jpg';

  //   return Product(
  //     id: id,
  //     name: 'Ethiopian White Teff (Level 1)',
  //     description:
  //         'Premium white teff, carefully processed. Great for injera and traditional dishes. Cleaned and quality checked.Premium white teff, carefully processed. Great for injera and traditional dishes. Cleaned and quality checked.',
  //     basePrice: 120.0, // base price in ETB for 1kg
  //     images: [localImagePath],

  //     inStock: true,
  //     rating: 4.8,
  //     reviewsCount: 124,
  //     /*  locationInfo: 'Main Campus Market - Stall A12',
  //     deliveryInfo: 'Delivery within campus in 30–60 minutes', */
  //     discountPercent: 10.0,
  //   );
  // }
}

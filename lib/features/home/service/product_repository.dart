import 'dart:async';
import 'dart:convert';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:http/http.dart' as Http;

import '../models/product.dart';

class ProductsRepository {
  // Simulate network latency and
  Future<List<ProductModel>> searchFeatured(String param) async {
    print(param);

    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}/api/products/search?search=$param'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(body);

        // If API returns { "data": [...] }
        final productsJson = body["data"] ?? body;

        if (productsJson is! List) {
          throw Exception("Invalid data format");
        }

        final products = productsJson
            .map<ProductModel>((json) => ProductModel.fromJson(json))
            .toList();

        print(products);

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

  // return demo data
  Future<List<ProductModel>> fetchFeatured() async {
    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}/api/products/popular'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        print(body);

        // If API returns { "data": [...] }
        final productsJson = body["data"] ?? body;

        if (productsJson is! List) {
          throw Exception("Invalid data format");
        }

        final products = productsJson
            .map<ProductModel>((json) => ProductModel.fromJson(json))
            .toList();

        print(products);

        return products;
      } else {

        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        if (message != null) {
          print("API Error: $message");
        }
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<List<ProductModel>> fetchAll() async {
    try {
      final response = await Http.get(
        Uri.parse('${Constants.baseurl}/api/products'),
        headers: {'Content-Type': 'application/json'},
      );

      print(response.body);

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        print(body);

        // If API returns { "data": [...] }
        final productsJson = body["data"] ?? body;

        print('Products JSON: $productsJson');

        if (productsJson is! List) {
          throw Exception("Invalid data format");
        }

        final products = productsJson
            .map<ProductModel>((json) => ProductModel.fromJson(json))
            .toList();

        print(products);

        return products;
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
             if (message != null) {
          print("API Error: $message");
        }
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  //   Future<AuthModel> login(String email, String password) async {
  //   try {
  //     final response = await Http.post(
  //       Uri.parse('${Constants.baseurl}/api/login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({"email": email, "password": password}),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       return AuthModel.fromJson(data);
  //     } else {
  //       final body = jsonDecode(response.body);
  //       final message = ErrorParser.parse(body);
  //       throw Exception(message);
  //     }
  //   } catch (e) {
  //     throw Exception('Login error: $e');
  //   }
  // }
  //   List<Product> fetchFeatured()  {
  //   // await Future.delayed(const Duration(milliseconds: 600));
  //   return List.generate(
  //     4,
  //     (i) => Product(
  //       id: 'p$i',
  //       name: 'Chair ${i + 1}',
  //       imageUrl: 'assets/images/teff.jpg',
  //       price: 125.0 + i * 50,
  //     ),
  //   );
  // }

  /* Future<List<Product>> fetchFlashSale() async {
    // await Future.delayed(const Duration(milliseconds: 700));
    return List.generate(
      6,
      (i) => Product(
        id: 'f$i',
        name: 'Seat ${i + 1}',
        imageUrl: 'assets/images/injera.jpg',
        price: 90.0 + i * 20,
      ),
    );
  } */
  // List<Product> fetchFlashSale() {
  //   // await Future.delayed(const Duration(milliseconds: 700));
  //   return List.generate(
  //     4,
  //     (i) => Product(
  //       id: 'f$i',
  //       name: 'Seat ${i + 1}',
  //       imageUrl: 'assets/images/injera.jpg',
  //       price: 90.0 + i * 20,
  //     ),
  //   );
  // }
}

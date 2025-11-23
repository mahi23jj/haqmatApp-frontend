import 'dart:async';
import '../models/product.dart';

class FakeRepository {
  // Simulate network latency and return demo data
  // Future<List<Product>> fetchFeatured() async {
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

    List<Product> fetchFeatured()  {
    // await Future.delayed(const Duration(milliseconds: 600));
    return List.generate(
      4,
      (i) => Product(
        id: 'p$i',
        name: 'Chair ${i + 1}',
        imageUrl: 'assets/images/teff.jpg',
        price: 125.0 + i * 50,
      ),
    );
  }

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
 List<Product> fetchFlashSale() {
    // await Future.delayed(const Duration(milliseconds: 700));
    return List.generate(
      4,
      (i) => Product(
        id: 'f$i',
        name: 'Seat ${i + 1}',
        imageUrl: 'assets/images/injera.jpg',
        price: 90.0 + i * 20,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:haqmate/features/home/service/product_repository.dart';
import '../models/product.dart';

class HomeViewModel extends ChangeNotifier {
  final FakeRepository _repo = FakeRepository();
  bool _loading = true;
  String? _error;
  // List<Product> featured = [];
  List<ProductModel> flashSale = [];

  bool get loading => _loading;
  String? get error => _error;

  HomeViewModel() {
    load();
  }

  Future<List<ProductModel>> load() async {
    _loading = false;
    _error = null;
    notifyListeners();

    try {
      flashSale = await _repo.fetchFeatured();

      print(flashSale.length);

      _loading = false;
      notifyListeners();

      return flashSale;
    } catch (e) {
      _error = 'Failed to load data';
      return [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:haqmate/features/home/service/product_repository.dart';
import '../models/product.dart';

class HomeViewModel extends ChangeNotifier {
  final ProductsRepository _repo = ProductsRepository();
  bool _loading = true;
  String? _error;
  // List<Product> featured = [];
  List<ProductModel> flashSale = [];
  List<ProductModel> allProducts = [];
  List<ProductModel> result = [];

  bool get loading => _loading;
  String? get error => _error;

  Timer? _debounce;

  HomeViewModel() {
    load();
  }

  Future<List<ProductModel>> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      flashSale = await _repo.fetchAll();

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

  Future<List<ProductModel>> loadall() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      allProducts = await _repo.fetchFeatured();

      print(allProducts.length);

      _loading = false;
      notifyListeners();

      return allProducts;
    } catch (e) {
      _error = 'Failed to load data';
      return [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// 🔍 Public method used by UI
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (query.trim().isNotEmpty) {
        search(query);
      } else {
        result = [];
        notifyListeners();
      }
    });
  }

  /// 🔍 Actual API call
  ///
  Future<List<ProductModel>> search(String param) async {
    if (param.trim().isEmpty) {
      result = [];
      notifyListeners();
      return [];
    }

    try {
      _loading = true;
      notifyListeners();

      result = await _repo.searchFeatured(param);

      return result;
    } catch (e) {
      _error = 'Failed to load data';
      return [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clear() {
    result = [];
    _error = null;
    notifyListeners();
  }

  // Future<void> search(String param) async {
  //   _loading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     result = await _repo.searchFeatured(param);

  //     print(result);
  //   } catch (e) {
  //     _error = 'Failed to load data';
  //     flashSale = [];
  //   } finally {
  //     _loading = false;
  //     notifyListeners();
  //   }
  // }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

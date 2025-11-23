
import 'package:flutter/material.dart';
import 'package:haqmate/features/home/service/product_repository.dart';
import '../models/product.dart';


class HomeViewModel extends ChangeNotifier {
  final FakeRepository _repo = FakeRepository();
  bool _loading = true;
  String? _error;
  List<Product> featured = [];
  List<Product> flashSale = [];

  bool get loading => _loading;
  String? get error => _error;

  HomeViewModel() {
    load();
  }

  Future<void> load() async {
    _loading = false;
    _error = null;
    notifyListeners();

    try {
 /*      final results = await Future.wait([
        
       
      ]); */
      featured = _repo.fetchFeatured() ;
      flashSale =  _repo.fetchFlashSale() ;
    } catch (e) {
      // Log.e('HomeViewModel load failed', e);
      _error = 'Failed to load data';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

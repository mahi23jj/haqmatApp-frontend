import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/auth/model/auth_model.dart';
import 'package:haqmate/features/auth/service/auth_reposiroty.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  bool _loading = false;
  String? _error;
  AuthModel? _user;

  bool get loading => _loading;
  String? get error => _error;
  AuthModel? get user => _user;

  AuthViewModel();

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repo.login(email, password);
      print(result);
      _user = result;


      await saveToken(_user!.token); // save token to local storage

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(
    String email,
    String password,
    String name,
    String location,
    String phone,
  ) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repo.signup(email, password, name, location, phone);
      _user = result;

       await saveToken(_user!.token); // save token to local storage

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}

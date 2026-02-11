import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/auth/model/auth_model.dart';
import 'package:haqmate/features/auth/service/auth_reposiroty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  static const String _rememberMeKey = 'remember_me';
  static const String _rememberedEmailKey = 'remembered_email';
  static const String _rememberedPasswordKey = 'remembered_password';

  bool _loading = false;
  String? _error;
  AuthModel? _user;
  bool _rememberMe = false;
  String? _rememberedEmail;
  String? _rememberedPassword;

  bool get loading => _loading;
  String? get error => _error;
  AuthModel? get user => _user;
  bool get rememberMe => _rememberMe;
  String? get rememberedEmail => _rememberedEmail;
  String? get rememberedPassword => _rememberedPassword;

  AuthViewModel();

  Future<void> loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    _rememberedEmail = prefs.getString(_rememberedEmailKey);
    _rememberedPassword = prefs.getString(_rememberedPasswordKey);
    notifyListeners();
  }

  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
    if (!value) {
      await _clearRememberedCredentials();
    }
  }

  Future<void> _saveRememberedCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rememberedEmailKey, email);
    await prefs.setString(_rememberedPasswordKey, password);
    _rememberedEmail = email;
    _rememberedPassword = password;
  }

  Future<void> _clearRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberedEmailKey);
    await prefs.remove(_rememberedPasswordKey);
    _rememberedEmail = null;
    _rememberedPassword = null;
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repo.login(email, password);
      print(result);
      _user = result;
      await saveToken(_user!.token); // save token to local storage

      if (_rememberMe) {
        await _saveRememberedCredentials(email, password);
      } else {
        await _clearRememberedCredentials();
      }

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

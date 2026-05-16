import 'package:flutter/material.dart';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/auth/model/auth_model.dart';
import 'package:haqmate/features/auth/service/auth_reposiroty.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo = AuthRepository();

  static const String _rememberMeKey = 'remember_me';
  static const String _rememberedPhoneKey = 'remembered_phone';
  static const String _legacyRememberedEmailKey = 'remembered_email';
  static const String _rememberedPasswordKey = 'remembered_password';

  bool _loading = false;
  String? _error;
  AuthModel? _user;
  bool _rememberMe = false;
  String? _rememberedPhone;
  String? _rememberedPassword;

  bool get loading => _loading;
  String? get error => _error;
  AuthModel? get user => _user;
  bool get rememberMe => _rememberMe;
  String? get rememberedPhone => _rememberedPhone;
  String? get rememberedPassword => _rememberedPassword;

  AuthViewModel();

  Future<void> loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool(_rememberMeKey) ?? false;
    _rememberedPhone = prefs.getString(_rememberedPhoneKey) ??
        prefs.getString(_legacyRememberedEmailKey);
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

  Future<void> _saveRememberedCredentials(
    String phoneNumber,
    String password,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rememberedPhoneKey, phoneNumber);
    await prefs.remove(_legacyRememberedEmailKey);
    await prefs.setString(_rememberedPasswordKey, password);
    _rememberedPhone = phoneNumber;
    _rememberedPassword = password;
  }

  Future<void> _clearRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberedPhoneKey);
    await prefs.remove(_legacyRememberedEmailKey);
    await prefs.remove(_rememberedPasswordKey);
    _rememberedPhone = null;
    _rememberedPassword = null;
  }

  Future<bool> login(String phoneNumber, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repo.login(phoneNumber, password);
      _user = result;
      await saveToken(_user!.token); // save token to local storage

      if (_rememberMe) {
        await _saveRememberedCredentials(phoneNumber, password);
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

  Future<bool> isLoggedInSafe() async {
    try {
      final box = Hive.box('authBox'); // or wherever you store login info
      return box.get('isLoggedIn', defaultValue: false) as bool;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signup({
    required String password,
    required String name,
    required String subcity,
    required String address,
    required String phone,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _repo.signup(
        password,
        name,
        subcity,
        address,
        phone,
      );
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

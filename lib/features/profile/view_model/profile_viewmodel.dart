import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haqmate/features/cart/model/cartmodel.dart';
import 'package:haqmate/features/checkout/service/checkout_service.dart';
import 'package:haqmate/features/profile/model/profile_model.dart';
import 'package:haqmate/features/profile/service/profile_service.dart';

class ProfileViewModel with ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final CheckoutService _checkoutService = CheckoutService();

  ProfileViewModel() {
    loadProfile();
  }

  Profile? _profile;
  Profile? _originalProfile;
  bool _isLoading = false;
  bool _isEditing = false;
  String _errorMessage = '';
  bool _isSaving = false;

  // Location search state
  final TextEditingController locationController = TextEditingController();
  LocationModel? selectedLocation;
  List<LocationModel> suggestions = [];
  bool loadingSuggestions = false;
  Timer? _debounce;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;
  String get errorMessage => _errorMessage;
  bool get isSaving => _isSaving;






  Future<void> loadProfile() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _profile = await _profileService.getProfile();
      selectedLocation = _profile?.address;
      locationController.text = _profile?.address.name ?? '';
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startEditing() {
    _isEditing = true;
    _originalProfile = _profile?.copyWith();
    locationController.text = _profile?.address.name ?? '';
    selectedLocation = _profile?.address;
    suggestions = [];
    notifyListeners();
  }

  void cancelEditing() {
    _isEditing = false;
    _errorMessage = '';
    suggestions = [];
    if (_originalProfile != null) {
      _profile = _originalProfile;
    }
    locationController.text = _profile?.address.name ?? '';
    selectedLocation = _profile?.address;
    _originalProfile = null;
    notifyListeners();
  }

  void updateField(String field, String value) {
    if (_profile == null) return;

    switch (field) {
      case 'name':
        _profile = _profile!.copyWith(name: value);
        break;
      case 'phone':
        _profile = _profile!.copyWith(phone: value);
        break;
    }
    notifyListeners();
  }




  // ------------------------------------
  // LOCATION SELECT + SEARCH
  // ------------------------------------
  void selectLocation(LocationModel loc) {
    selectedLocation = loc;
    locationController.text = loc.name;
    suggestions = [];
    if (_profile != null) {
      _profile = _profile!.copyWith(address: loc);
    }
    notifyListeners();
  }

  void searchLocations(String query) {
    _debounce?.cancel();

    if (query.isEmpty) {
      suggestions = [];
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      loadingSuggestions = true;
      notifyListeners();

      try {
        final results = await _checkoutService.searchLocations(query);
        suggestions = results;
      } catch (_) {
        suggestions = [];
      }

      loadingSuggestions = false;
      notifyListeners();
    });
  }

  Future<bool> saveProfile() async {
    if (_profile == null) return false;

    _isSaving = true;
    _errorMessage = '';
    notifyListeners();

     print('Saving profile: ${_profile!.toJson()}');

    try {
      _profile = await _profileService.updateProfile(_profile!);


      _isEditing = false;
      _originalProfile = null;
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetCode(String email) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _profileService.sendPasswordResetCode(email);
    } catch (e) {
      _errorMessage = 'Failed to send reset code: $e';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOtp(String email, String code) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _profileService.verifyOtp(email, code);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to verify code: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(ChangePasswordRequest request) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _profileService.verifyAndResetPassword(request);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to change password: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _profileService.logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    locationController.dispose();
    super.dispose();
  }
}

extension on Profile {
  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    LocationModel? address,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

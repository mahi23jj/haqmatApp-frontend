import 'package:flutter/material.dart';
import 'package:haqmate/features/profile/model/profile_model.dart';
import 'package:haqmate/features/profile/service/profile_service.dart';


class ProfileViewModel with ChangeNotifier {
  final ProfileService _profileService;
  
  Profile? _profile;
  bool _isLoading = false;
  bool _isEditing = false;
  String _errorMessage = '';
  bool _isSaving = false;

  ProfileViewModel({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService();

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
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startEditing() {
    _isEditing = true;
    notifyListeners();
  }

  void cancelEditing() {
    _isEditing = false;
    _errorMessage = '';
    notifyListeners();
  }

  void updateField(String field, String value) {
    if (_profile == null) return;
    
    switch (field) {
      case 'name':
        _profile = _profile!.copyWith(name: value);
        break;
      case 'email':
        _profile = _profile!.copyWith(email: value);
        break;
      case 'phone':
        _profile = _profile!.copyWith(phone: value);
        break;
      case 'address':
        _profile = _profile!.copyWith(address: value);
        break;
    }
    notifyListeners();
  }

  Future<bool> saveProfile() async {
    if (_profile == null) return false;
    
    _isSaving = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _profile = await _profileService.updateProfile(_profile!);
      _isEditing = false;
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
}

extension on Profile {
  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
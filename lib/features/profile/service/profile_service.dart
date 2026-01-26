import 'dart:convert';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/profile/model/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String _baseUrl = Constants.baseurl;
  static const Duration _timeout = Duration(seconds: 30);

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token");
  }

  Future<Profile> getProfile() async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/profile'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Profile.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<Profile> updateProfile(Profile profile) async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http
        .put(
          Uri.parse('$_baseUrl/api/profile'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(profile.toJson()),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Profile.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

  Future<void> sendPasswordResetCode(String email) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/send-reset-code'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email}),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to send reset code: ${response.statusCode}');
    }
  }

  Future<void> verifyAndResetPassword(ChangePasswordRequest request) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/reset-password'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(request.toJson()),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final token = await _getAuthToken();
    if (token != null) {
      try {
        await http
            .post(
              Uri.parse('$_baseUrl/api/auth/logout'),
              headers: {'Authorization': 'Bearer $token'},
            )
            .timeout(_timeout);
      } catch (e) {
        // Continue with local logout even if API call fails
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }
}

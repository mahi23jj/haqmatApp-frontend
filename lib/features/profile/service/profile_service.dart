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
    String? token = await getToken();
    if (token == null) throw Exception('No authentication token found');

    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/profile'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
       
       print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Profile.fromJson(data['data'] ?? data);
    } else {
      throw Exception('Failed to load profile: ${response.statusCode}');
    }
  }

  Future<Profile> updateProfile(Profile profile) async {
    String? token = await getToken();
    if (token == null) throw Exception('No authentication token found');

    print('Updating profile with data: ${profile.toJson()}');

    final response = await http
        .put(
          Uri.parse('$_baseUrl/api/user/update-profile'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(profile.toJson()),
        );
        
     print(response.body);
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
          Uri.parse('$_baseUrl/api/forgot-password'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email}),
        );
        

    if (response.statusCode != 200) {
      throw Exception('Failed to send reset code: ${response.statusCode}');
    }
  }

  Future<void> verifyOtp(String email, String code) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/forgot-password/verify-otp'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'otp': code}),
        );
        

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password: ${response.statusCode}');
    }
  }

  Future<void> verifyAndResetPassword(ChangePasswordRequest request) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/forgot-password/reset'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(request.toJson()),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to reset password: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
  String? token = await getToken();
    if (token != null) {
      try {
        await http
            .post(
              Uri.parse('$_baseUrl/api/logout'),
              headers: {'Authorization': 'Bearer $token'},
            );
            
      } catch (e) {
        // Continue with local logout even if API call fails
      }
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
  }
}

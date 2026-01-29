import 'dart:convert';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/features/auth/model/auth_model.dart';
import 'package:http/http.dart' as Http;

class AuthRepository {
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email, 
          "password": password,
          "rememberMe": true // Add this if your backend expects it
        }),
      );

      final responseBody = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return AuthModel.fromJson(responseBody);
      } else {
        // Extract error from backend response
        final error = responseBody['error'] ?? 'Login failed';
        throw AuthException(error, response.statusCode);
      }
    } on Http.ClientException catch (e) {
      throw AuthException('Network error. Please check your connection.', 0);
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}', 500);
    }
  }

  Future<AuthModel> signup(
    String email,
    String password,
    String name,
    String location,
    String phone,
  ) async {
    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}/api/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
          "username": name,
          "location": location,
          "phoneNumber": phone,
        }),
      );

      final responseBody = jsonDecode(response.body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return AuthModel.fromJson(responseBody);
      } else {
        // Extract error from backend response
        final error = responseBody['error'] ?? 'Signup failed';
        throw AuthException(error, response.statusCode);
      }
    } on Http.ClientException catch (e) {
      throw AuthException('Network error. Please check your connection.', 0);
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}', 500);
    }
  }
}

// Custom exception class for auth errors
class AuthException implements Exception {
  final String message;
  final int statusCode;
  
  AuthException(this.message, this.statusCode);
  
  @override
  String toString() => message;
}
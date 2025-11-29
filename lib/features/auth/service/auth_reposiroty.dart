import 'dart:convert';
import 'package:haqmate/core/constants.dart';
import 'package:haqmate/core/error_parser.dart';
import 'package:haqmate/features/auth/model/auth_model.dart';
import 'package:http/http.dart' as Http;

class AuthRepository {
  Future<AuthModel> login(String email, String password) async {
    try {
      final response = await Http.post(
        Uri.parse('${Constants.baseurl}/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthModel.fromJson(data);
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthModel.fromJson(data);
      } else {
        final body = jsonDecode(response.body);
        final message = ErrorParser.parse(body);
        throw Exception(message);
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserDataProvider {
  UserDataProvider({required this.baseUrl});

  final String baseUrl;

  Future<Map<String, dynamic>> getUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/me'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> createAccount({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create account');
    }
  }
}

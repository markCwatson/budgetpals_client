import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthDataProvider {
  AuthDataProvider({required this.baseUrl});

  final String baseUrl;

  Future<Map<String, dynamic>> getToken({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/token'),
      body: jsonEncode(
        <String, String>{'email': username, 'password': password},
      ),
      headers: <String, String>{'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load user');
    }
  }
}

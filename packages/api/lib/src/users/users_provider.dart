import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserDataProvider {
  UserDataProvider({required this.baseUrl});

  final String baseUrl;

  Future<Map<String, dynamic>> getUser() async {
    // \todo: save token and use here
    final response = await http.get(
      Uri.parse('$baseUrl/api/users'),
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6Im1hcmtAZW1haWwuY29tIiwiaWF0IjoxNjkyOTIxNzkwLCJleHAiOjE2OTMwMDgxOTAsInN1YiI6IjY0ZTdlN2JjZGY1YmE1YTE2YTQ5MDg2NyJ9.OrL-IR1eEvsV8bZu4sELjUMEUkj3-NFZriXocisIysw',
      },
    );

    if (response.statusCode == 200) {
      // Decode the response body into a List
      final jsonArray = jsonDecode(response.body) as List<dynamic>;

      // Access the first element and return it as a Map<String, dynamic>
      return jsonArray.first as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load user');
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BudgetsDataProvider {
  BudgetsDataProvider({required this.baseUrl});

  final String baseUrl;

  Future<Map<String, dynamic>> getBudget(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/budget'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load budget');
    }
  }

  Future<List<String>> getPeriods(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/budget/periods'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return List<String>.from(decoded);
      } else {
        throw Exception('Expected a list but got ${decoded.runtimeType}');
      }
    } else {
      throw Exception('Failed to load periods');
    }
  }

  Future<bool> addBudget({
    required String token,
    required String start,
    required String period,
    required double accountBalance,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/budget'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'startDate': start,
        'period': period,
        'startAccountBalance': accountBalance,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }
}

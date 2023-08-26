import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ExpensesDataProvider {
  ExpensesDataProvider({required this.baseUrl});

  final String baseUrl;

  Future<List<Map<String, dynamic>>> getExpenses(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/expenses'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      } else {
        throw Exception('Expected a list but got ${decoded.runtimeType}');
      }
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<List<String>> getExpenseCategories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/expenses/categories'),
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
      throw Exception('Failed to load expenses');
    }
  }

  Future<List<String>> getExpenseFrequencies(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/expenses/frequencies'),
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
      throw Exception('Failed to load expenses');
    }
  }
}

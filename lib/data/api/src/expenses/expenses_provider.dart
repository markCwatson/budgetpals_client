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

  Future<Map<String, dynamic>> getExpenseById(String token, String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/$id/expenses'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load expense');
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

  Future<void> addExpense({
    required String token,
    required double amount,
    required String date,
    required String category,
    required String frequency,
    required bool isEnding,
    required String endDate,
    required bool isFixed,
    required bool isPlanned,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/expenses'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<dynamic, dynamic>{
        'amount': amount,
        'date': date,
        'category': category,
        'frequency': frequency,
        'isEnding': isEnding,
        'endDate': endDate,
        'isFixed': isFixed,
        'isPlanned': isPlanned,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add expense');
    }
  }

  Future<void> deleteExpense({
    required String token,
    required String id,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/expenses/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete expense');
    }
  }
}

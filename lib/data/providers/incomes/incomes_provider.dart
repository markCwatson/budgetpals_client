import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class IncomesDataProvider {
  IncomesDataProvider({required this.baseUrl});

  final String baseUrl;

  Future<List<Map<String, dynamic>>> getIncomes(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/incomes'),
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
      throw Exception('Failed to load incomes');
    }
  }

  Future<Map<String, dynamic>> getIncomeById(String token, String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/$id/incomes'),
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
      throw Exception('Failed to load income');
    }
  }

  Future<List<String>> getCategories(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/incomes/categories'),
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
      throw Exception('Failed to load incomes');
    }
  }

  Future<List<String>> getFrequencies(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/incomes/frequencies'),
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
      throw Exception('Failed to load incomes');
    }
  }

  Future<bool> addIncome({
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
      Uri.parse('$baseUrl/api/incomes'),
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
      throw Exception('Failed to add income');
    }

    return true;
  }

  Future<bool> updateIncome({
    required String token,
    required String id,
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
      Uri.parse('$baseUrl/api/incomes/$id'),
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

    if (response.statusCode != 200) {
      throw Exception('Failed to update income');
    }

    return true;
  }

  Future<bool> deleteIncome({
    required String token,
    required String id,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/incomes/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete income');
    }

    return true;
  }
}

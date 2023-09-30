import 'dart:convert';
import 'dart:io';
import 'package:api/src/api_cache_helper/model/expense_box.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ApiCacheHelper {
  static const int _cacheTimeout = 15 * 60 * 1000; // 15 mins

  static Future<dynamic> getJsonResponse(
    String route,
    String token,
  ) async {
    final box = Hive.box<ApiResponseBox?>('apiResponses');
    //returns first element according to the condition or empty object
    final cachedResponse = box.values.firstWhere(
      (response) => response?.url == route,
      orElse: () => null,
    );

    if (cachedResponse != null &&
        DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp <
            _cacheTimeout) {
      // Return cached response if it's not expired yet
      return json.decode(cachedResponse.response);
    }

    // Fetch new response if cache is expired or not available
    final response = await http.get(
      Uri.parse(route),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    dynamic jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    } else {
      throw Exception('Error in ApiCacheHelper');
    }

    // Save new response to cache
    final newResponse = ApiResponseBox()
      ..url = route
      ..response = json.encode(jsonResponse)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;
    await box.add(newResponse);

    return jsonResponse;
  }
}

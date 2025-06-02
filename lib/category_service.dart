import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

// =================== CATEGORY SERVICE ===================
/// Service for fetching product categories from the backend API.
/// Used by AddProductScreen and HomeScreen to populate category lists.
class CategoryService {
  /// Fetches all categories from the backend API.
  /// Returns a list of category maps with 'id' and 'name'.
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/categories');

    try {
      final response = await http.get(url);

      //print('GET ${url.toString()} → ${response.statusCode}');
      //print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map<Map<String, dynamic>>((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      //print('Exception in getCategories(): $e');
      throw Exception('Network error occurred');
    }
  }
}
// =================== END CATEGORY SERVICE ===================

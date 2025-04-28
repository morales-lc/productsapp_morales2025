import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/categories');

    final response = await http.get(url);

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
  }
}

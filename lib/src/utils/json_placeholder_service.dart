import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonPlaceholderService {
  static Future<List<dynamic>> getPosts() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Falha ao carregar posts');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';

class CepService {
  static Future<Map<String, dynamic>?> buscarCep(String cep) async {
    try {
      final response = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Tratar erro
    }
    return null;
  }
}
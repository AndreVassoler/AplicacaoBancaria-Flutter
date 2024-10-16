import 'package:http/http.dart' as http;
import 'dart:convert';

class AbstractApi {
  final String baseUrl = 'http://localhost:3000';
  final String resource = '/transacoes';

  Future<List<dynamic>> getAll() async {
    final response = await http.get(Uri.parse('$baseUrl$resource'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar dados');
    }
  }

  Future<void> create(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$resource'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      throw Exception('Erro ao criar a pessoa');
    }
  }

  Future<void> update(String id, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$resource/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar a pessoa');
    }
  }

  Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl$resource/$id'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir a pessoa');
    }
  }
}

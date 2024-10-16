import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './screen/formulario.dart';
import './screen/lista.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Bancaria',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Aplicação Bancaria'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = 'http://localhost:3000/transacoes'; // URL da API

  void _navigateToFormulario() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioScreen(
          pessoa: null, // Ao criar um novo formulário, a pessoa é null
          onSave: (Map<String, dynamic> newPessoa) async {
            if (newPessoa['id'] != null) {
              // Verifica se o ID está presente
              await _updatePessoa(newPessoa);
            } else {
              // Se não, cria uma nova pessoa
              await _createPessoa(newPessoa);
            }
          },
        ),
      ),
    );
  }

  Future<void> _createPessoa(Map<String, dynamic> pessoa) async {
    // Método para criar uma nova pessoa
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pessoa),
      );

      if (response.statusCode == 201) {
        print('Pessoa criada com sucesso');
      } else {
        throw Exception('Erro ao criar a pessoa');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  Future<void> _updatePessoa(Map<String, dynamic> pessoa) async {
    // Método para atualizar uma pessoa
    try {
      final String id = pessoa['id'].toString();
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pessoa),
      );

      if (response.statusCode == 200) {
        print('Pessoa atualizada com sucesso');
      } else {
        throw Exception('Erro ao atualizar a pessoa');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  void _navigateToLista() {
    // Método para navegar para a lista de pessoas
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListaPessoas(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _navigateToFormulario,
              child: const Text('Ir para Formulário'),
            ),
            ElevatedButton(
              onPressed: _navigateToLista,
              child: const Text('Ir para Lista'),
            ),
          ],
        ),
      ),
    );
  }
}

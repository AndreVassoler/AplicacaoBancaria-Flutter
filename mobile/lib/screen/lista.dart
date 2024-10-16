import 'package:atividade01/service/abstract-api.dart';
import 'package:flutter/material.dart';
import 'formulario.dart';

class ListaPessoas extends StatefulWidget {
  @override
  _ListaPessoasState createState() => _ListaPessoasState();
}

class _ListaPessoasState extends State<ListaPessoas> {
  List<dynamic> pessoas = [];
  final AbstractApi api = AbstractApi();

  @override
  void initState() {
    super.initState();
    _fetchPessoas();
  }

  Future<void> _fetchPessoas() async {
    // Método para buscar todas as pessoas
    try {
      final response = await api.getAll();
      setState(() {
        pessoas = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar os dados')),
      );
    }
  }

  Future<void> _deletePessoa(String id) async {
    // Método para deletar uma pessoa
    try {
      await api.delete(id);
      setState(() {
        pessoas.removeWhere((pessoa) => pessoa['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pessoa excluída com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir a pessoa')),
      );
    }
  }

  void _navigateToEditForm(Map<String, dynamic> pessoa) {
    // Método para navegar para o formulário de edição
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioScreen(
          pessoa: pessoa,
          onSave: (updatedPessoa) async {
            try {
              // Verifica se estamos atualizando ou criando um novo registro
              if (updatedPessoa['id'] != null) {
                // Se o ID estiver presente, atualiza a pessoa
                await api.update(updatedPessoa['id'].toString(), updatedPessoa);
              } else {
                // Se não, cria uma nova pessoa
                await api.create(updatedPessoa);
              }

              setState(() {
                final index = pessoas.indexWhere((p) =>
                    p['id'].toString() == updatedPessoa['id'].toString());
                if (index != -1) {
                  pessoas[index] = updatedPessoa;
                } else {
                  pessoas.add(updatedPessoa);
                }
              });

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pessoa salva com sucesso')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao salvar a pessoa')),
                );
              }
            }
          },
        ),
      ),
    ).then((_) {
      _fetchPessoas(); // Atualiza a lista de pessoas
    });
  }

  @override
  Widget build(BuildContext context) {
    // Método para construir a tela
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pessoas Cadastradas'),
      ),
      body: pessoas.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pessoas.length,
              itemBuilder: (context, index) {
                final pessoa = pessoas[index];
                final nome = pessoa['nome'] ??
                    'Nome não disponível'; // Verifica se o nome está presente
                final valor = pessoa['valor']?.toString() ??
                    'Valor não disponível'; // Verifica se o valor está presente

                return ListTile(
                  title: Text(nome),
                  subtitle: Text('Valor: $valor'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            _navigateToEditForm(pessoa), // Editar pessoa
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            _deletePessoa(pessoa['id']), // Deletar pessoa
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

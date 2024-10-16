import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  final Map<String, dynamic>? pessoa;
  final Future<void> Function(Map<String, dynamic>) onSave;

  FormularioScreen({Key? key, this.pessoa, required this.onSave})
      : super(key: key);

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _valorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pessoa != null) {
      _textController.text = widget.pessoa!['nome'];
      _valorController.text = widget.pessoa!['valor'].toString();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String nome = _textController.text;
      final double valor = double.parse(_valorController.text);

      final Map<String, dynamic> pessoa = {
        'id': widget.pessoa?['id'],
        'nome': nome,
        'valor': valor,
      };

      try {
        await widget.onSave(pessoa);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar a transação: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um valor';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

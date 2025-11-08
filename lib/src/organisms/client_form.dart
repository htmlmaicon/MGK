import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../molecules/text_field.dart';
import '../molecules/cep_field.dart';
import '../molecules/submit_button.dart';

class ClientForm extends StatefulWidget {
  final String tipoCliente;

  const ClientForm({super.key, required this.tipoCliente});

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController nascimentoController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController paiController = TextEditingController();
  final TextEditingController maeController = TextEditingController();
  final TextEditingController expedicaoController = TextEditingController();
  final TextEditingController emissorController = TextEditingController();
  final TextEditingController rendaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _loadingCep = false;
  bool _salvando = false;
  String? _cepError;

  Future<void> buscarCep(String cep) async {
    if (cep.isEmpty) return;

    setState(() {
      _loadingCep = true;
      _cepError = null;
    });

    try {
      final response = await http.get(
        Uri.parse("https://viacep.com.br/ws/$cep/json/"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey("erro")) {
          _cepError = "CEP não encontrado";
        } else {
          enderecoController.text =
              "${data['logradouro']}, ${data['bairro']}, ${data['localidade']}-${data['uf']}";
        }
      }
    } catch (e) {
      _cepError = "Erro ao buscar o CEP";
    } finally {
      setState(() {
        _loadingCep = false;
      });
    }
  }

  Future<void> salvarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      await _firestore.collection('clientes').add({
        'nome': nomeController.text.trim(),
        'rg': rgController.text.trim(),
        'cpf': cpfController.text.trim(),
        'nascimento': nascimentoController.text.trim(),
        'cep': cepController.text.trim(),
        'endereco': enderecoController.text.trim(),
        'pai': paiController.text.trim(),
        'mae': maeController.text.trim(),
        'expedicao': expedicaoController.text.trim(),
        'emissor': emissorController.text.trim(),
        'renda': rendaController.text.trim(),
        'email': emailController.text.trim(),
        'tipoCliente': widget.tipoCliente,
        'contratoAtivo': true,
        'criadoEm': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cliente salvo com sucesso!")),
      );

      _formKey.currentState!.reset();
      nomeController.clear();
      rgController.clear();
      cpfController.clear();
      nascimentoController.clear();
      cepController.clear();
      enderecoController.clear();
      paiController.clear();
      maeController.clear();
      expedicaoController.clear();
      emissorController.clear();
      rendaController.clear();
      emailController.clear();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao salvar cliente: $e")));
    } finally {
      setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nomeController,
              labelText: "Nome completo",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: rgController,
              labelText: "RG/CNH",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: cpfController,
              labelText: "CPF",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: nascimentoController,
              labelText: "Data de nascimento",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CepField(
              cepController: cepController,
              enderecoController: enderecoController,
              onSearchCep: buscarCep,
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
              isLoading: _loadingCep,
              error: _cepError,
            ),
            CustomTextField(
              controller: enderecoController,
              labelText: "Endereço completo",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: paiController,
              labelText: "Nome do Pai",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: maeController,
              labelText: "Nome da Mãe",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: expedicaoController,
              labelText: "Data de expedição do RG",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: emissorController,
              labelText: "Emissor",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: rendaController,
              labelText: "Renda Bruta",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            CustomTextField(
              controller: emailController,
              labelText: "Email",
              validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 20),
            SubmitButton(
              onPressed: () {
                if (!_salvando) salvarCliente();
              },
              text: _salvando ? "Salvando..." : "Enviar",
            ),
          ],
        ),
      ),
    );
  }
}

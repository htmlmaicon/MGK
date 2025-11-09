import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../molecules/text_field.dart';
import '../molecules/cep_field.dart';
import '../molecules/submit_button.dart';

class EditClientForm extends StatefulWidget {
  final String clienteId;
  final Map<String, dynamic> clienteData;

  const EditClientForm({
    super.key,
    required this.clienteId,
    required this.clienteData,
  });

  @override
  State<EditClientForm> createState() => _EditClientFormState();
}

class _EditClientFormState extends State<EditClientForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController nomeController;
  late TextEditingController rgController;
  late TextEditingController cpfController;
  late TextEditingController nascimentoController;
  late TextEditingController cepController;
  late TextEditingController enderecoController;
  late TextEditingController paiController;
  late TextEditingController maeController;
  late TextEditingController expedicaoController;
  late TextEditingController emissorController;
  late TextEditingController rendaController;
  late TextEditingController emailController;

  bool _loadingCep = false;
  bool _salvando = false;
  String? _cepError;

  @override
  void initState() {
    super.initState();
    // Inicializar controllers com os dados existentes
    nomeController = TextEditingController(
      text: widget.clienteData['nome'] ?? '',
    );
    rgController = TextEditingController(text: widget.clienteData['rg'] ?? '');
    cpfController = TextEditingController(
      text: widget.clienteData['cpf'] ?? '',
    );
    nascimentoController = TextEditingController(
      text: widget.clienteData['nascimento'] ?? '',
    );
    cepController = TextEditingController(
      text: widget.clienteData['cep'] ?? '',
    );
    enderecoController = TextEditingController(
      text: widget.clienteData['endereco'] ?? '',
    );
    paiController = TextEditingController(
      text: widget.clienteData['pai'] ?? '',
    );
    maeController = TextEditingController(
      text: widget.clienteData['mae'] ?? '',
    );
    expedicaoController = TextEditingController(
      text: widget.clienteData['expedicao'] ?? '',
    );
    emissorController = TextEditingController(
      text: widget.clienteData['emissor'] ?? '',
    );
    rendaController = TextEditingController(
      text: widget.clienteData['renda'] ?? '',
    );
    emailController = TextEditingController(
      text: widget.clienteData['email'] ?? '',
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    rgController.dispose();
    cpfController.dispose();
    nascimentoController.dispose();
    cepController.dispose();
    enderecoController.dispose();
    paiController.dispose();
    maeController.dispose();
    expedicaoController.dispose();
    emissorController.dispose();
    rendaController.dispose();
    emailController.dispose();
    super.dispose();
  }

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

  Future<void> atualizarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      await _firestore.collection('clientes').doc(widget.clienteId).update({
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
        'atualizadoEm': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cliente atualizado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Retorna true para indicar sucesso
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao atualizar cliente: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
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
                if (!_salvando) atualizarCliente();
              },
              text: _salvando ? "Salvando..." : "Atualizar Cliente",
            ),
          ],
        ),
      ),
    );
  }
}

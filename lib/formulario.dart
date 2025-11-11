import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'src/core/services/notification_service.dart';

class FormularioPage extends StatefulWidget {
  final String tipoCliente;
  const FormularioPage({super.key, required this.tipoCliente});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();

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

  Future<void> buscarCep(String cep) async {
    try {
      final response = await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey("erro")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("CEP não encontrado")),
          );
        } else {
          setState(() {
            enderecoController.text =
                "${data['logradouro']}, ${data['bairro']}, ${data['localidade']}-${data['uf']}";
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao buscar o CEP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário do Cliente - ${widget.tipoCliente}"),
        backgroundColor: Colors.green[900],
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nome completo"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: rgController,
                decoration: const InputDecoration(labelText: "RG/CNH"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: cpfController,
                decoration: const InputDecoration(labelText: "CPF"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: nascimentoController,
                decoration: const InputDecoration(labelText: "Data de nascimento"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cepController,
                      decoration: const InputDecoration(labelText: "CEP"),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.green),
                    onPressed: () {
                      // Remove a máscara antes de buscar
                      String cep = cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
                      buscarCep(cep);
                    },
                  )
                ],
              ),
              TextFormField(
                controller: enderecoController,
                decoration: const InputDecoration(labelText: "Endereço completo"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: paiController,
                decoration: const InputDecoration(labelText: "Nome do Pai"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: maeController,
                decoration: const InputDecoration(labelText: "Nome da Mãe"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: expedicaoController,
                decoration: const InputDecoration(labelText: "Data de expedição do RG"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: emissorController,
                decoration: const InputDecoration(labelText: "Emissor"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: rendaController,
                decoration: const InputDecoration(labelText: "Renda Bruta"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      // Remove máscara do CPF para salvar no banco
                      String cpfLimpo = cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
                      
                      // Salva o cliente no Firestore
                      await FirebaseFirestore.instance
                          .collection('clientes')
                          .doc(cpfLimpo)
                          .set({
                        'nome': nomeController.text,
                        'rg': rgController.text,
                        'cpf': cpfLimpo,
                        'dataNascimento': nascimentoController.text,
                        'cep': cepController.text,
                        'endereco': enderecoController.text,
                        'pai': paiController.text,
                        'mae': maeController.text,
                        'dataExpedicao': expedicaoController.text,
                        'emissor': emissorController.text,
                        'renda': rendaController.text,
                        'email': emailController.text,
                        'tipoCliente': widget.tipoCliente,
                        'status': 'pendente',
                        'dataCadastro': FieldValue.serverTimestamp(),
                      });

                      // Salva o token FCM para receber notificações (apenas em mobile)
                      if (!kIsWeb) {
                        try {
                          await NotificationService().salvarTokenNoFirestore(cpfLimpo);
                          // Inicia monitoramento de mudanças de status
                          NotificationService().monitorarStatusCliente(cpfLimpo);
                        } catch (e) {
                          // Erro ao configurar notificações
                        }
                      }

                      if (mounted) {
                        String mensagem = kIsWeb 
                          ? "Formulário enviado com sucesso!"
                          : "Formulário enviado com sucesso! Você receberá uma notificação quando for aprovado.";
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(mensagem),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 5),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erro ao enviar formulário: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text("Enviar", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
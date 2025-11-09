import 'package:flutter/material.dart';
import '../templates/form_template.dart';
import '../utils/auth_service.dart';

class CadastroClientePage extends StatelessWidget {
  final AuthService _authService = AuthService();

  CadastroClientePage({super.key});

  void _abrirFormulario(BuildContext context, String tipoCliente) {
    // Verificar permissão
    if (!_authService.canCreateClient()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthService.getPermissionDeniedMessage()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormTemplate(tipoCliente: tipoCliente),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Verificar permissão ao entrar na página
    if (!_authService.canCreateClient()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AuthService.getPermissionDeniedMessage()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cadastrar Cliente'),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Icon(Icons.person_add_alt_1, size: 80, color: Colors.green[800]),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo ao cadastro de clientes!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Escolha o tipo de cliente que deseja cadastrar abaixo. Cada opção possui um formulário específico para agilizar o processo.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Botão Agricultor
              ElevatedButton.icon(
                onPressed: () => _abrirFormulario(context, 'Agricultor'),
                icon: const Icon(Icons.agriculture, color: Colors.white),
                label: const Text(
                  'Agricultor',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Botão Assalariado
              ElevatedButton.icon(
                onPressed: () => _abrirFormulario(context, 'Assalariado'),
                icon: const Icon(Icons.work, color: Colors.white),
                label: const Text(
                  'Assalariado',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),

              // Botão Aposentado/Pensionista
              ElevatedButton.icon(
                onPressed: () =>
                    _abrirFormulario(context, 'Aposentado/Pensionista'),
                icon: const Icon(Icons.elderly, color: Colors.white),
                label: const Text(
                  'Aposentado/Pensionista',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 40),

              Text(
                'Após selecionar o tipo de cliente, você será direcionado para o formulário correspondente.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

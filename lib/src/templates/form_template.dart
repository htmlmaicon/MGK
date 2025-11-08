import 'package:flutter/material.dart';
import '../organisms/client_form.dart';

class FormTemplate extends StatelessWidget {
  final String tipoCliente;

  const FormTemplate({super.key, required this.tipoCliente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulário do Cliente - $tipoCliente"),
        backgroundColor: Colors.green[900],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: ClientForm(tipoCliente: tipoCliente),
    );
  }
}
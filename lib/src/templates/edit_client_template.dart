import 'package:flutter/material.dart';
import '../organisms/edit_client_form.dart';

class EditClientTemplate extends StatelessWidget {
  final String clienteId;
  final Map<String, dynamic> clienteData;

  const EditClientTemplate({
    super.key,
    required this.clienteId,
    required this.clienteData,
  });

  @override
  Widget build(BuildContext context) {
    final tipoCliente = clienteData['tipoCliente'] ?? 'Cliente';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar $tipoCliente",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.green[900],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: EditClientForm(
        clienteId: clienteId,
        clienteData: clienteData,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../templates/edit_client_template.dart';

class EditClientePage extends StatelessWidget {
  final String clienteId;
  final Map<String, dynamic> clienteData;

  const EditClientePage({
    super.key,
    required this.clienteId,
    required this.clienteData,
  });

  @override
  Widget build(BuildContext context) {
    return EditClientTemplate(clienteId: clienteId, clienteData: clienteData);
  }
}

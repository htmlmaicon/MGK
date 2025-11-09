import 'package:flutter/material.dart';
import '../organisms/solicitations_list_organism.dart';

class SolicitationsTemplate extends StatelessWidget {
  const SolicitationsTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitações de Cadastro'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SolicitationsListOrganism(),
    );
  }
}

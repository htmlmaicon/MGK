import 'package:flutter/material.dart';
import '../organisms/contracts_list_organism.dart';

class ContractsTemplate extends StatefulWidget {
  const ContractsTemplate({super.key});

  @override
  State<ContractsTemplate> createState() => _ContractsTemplateState();
}

class _ContractsTemplateState extends State<ContractsTemplate> {
  bool _expandAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Contratos Ativos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(_expandAll ? Icons.unfold_less : Icons.unfold_more),
            onPressed: () {
              setState(() {
                _expandAll = !_expandAll;
              });
            },
            tooltip: _expandAll ? 'Recolher Todos' : 'Expandir Todos',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              border: Border(
                bottom: BorderSide(color: Colors.green[200]!, width: 1),
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.assignment, size: 48, color: Colors.green[700]),
                const SizedBox(height: 8),
                Text(
                  'Esteira de Contratos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Gerencie os contratos ativos dos seus clientes',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(child: ContractsListOrganism(expandAll: _expandAll)),
        ],
      ),
    );
  }
}

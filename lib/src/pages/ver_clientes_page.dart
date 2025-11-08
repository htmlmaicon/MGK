import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_cliente_page.dart';

class VerClientesPage extends StatelessWidget {
  const VerClientesPage({super.key});

  Future<void> _ativarContrato(BuildContext context, String clienteId, String nomeCliente) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ativar Contrato'),
          content: Text('Deseja ativar o contrato de $nomeCliente?\n\nO cliente aparecerá na esteira de contratos ativos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ativar', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await FirebaseFirestore.instance.collection('clientes').doc(clienteId).update({
          'contratoAtivo': true,
          'dataAtivacao': FieldValue.serverTimestamp(),
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contrato de $nomeCliente ativado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao ativar contrato: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _desativarContrato(BuildContext context, String clienteId, String nomeCliente) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Desativar Contrato'),
          content: Text('Deseja desativar o contrato de $nomeCliente?\n\nO cliente será removido da esteira de contratos ativos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Desativar', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await FirebaseFirestore.instance.collection('clientes').doc(clienteId).update({
          'contratoAtivo': false,
          'dataDesativacao': FieldValue.serverTimestamp(),
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contrato de $nomeCliente desativado!'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao desativar contrato: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _excluirCliente(BuildContext context, String clienteId, String nomeCliente) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Cliente'),
          content: Text('Tem certeza que deseja excluir $nomeCliente?\n\nEsta ação não pode ser desfeita!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        await FirebaseFirestore.instance.collection('clientes').doc(clienteId).delete();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$nomeCliente excluído com sucesso!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao excluir cliente: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _editarCliente(BuildContext context, String clienteId, Map<String, dynamic> clienteData) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditClientePage(
          clienteId: clienteId,
          clienteData: clienteData,
        ),
      ),
    );

    if (resultado == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Lista de Clientes',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('clientes').orderBy('nome').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Nenhum cliente cadastrado."));
          }

          final docs = snapshot.data!.docs;

          // Agrupar clientes por tipoCliente
          final Map<String, List<Map<String, dynamic>>> clientesPorTipo = {};
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id; // Adicionar ID do documento
            final tipo = data['tipoCliente'] ?? 'Sem categoria';
            clientesPorTipo.putIfAbsent(tipo, () => []).add(data);
          }

          return ListView(
            padding: const EdgeInsets.all(10),
            children: clientesPorTipo.entries.map((entry) {
              final tipo = entry.key;
              final clientes = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho da categoria
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Text(
                      tipo.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                  ),
                  // Lista de clientes da categoria
                  ...clientes.map((cliente) {
                    final clienteId = cliente['id'];
                    final nome = cliente['nome'] ?? 'Sem nome';
                    final email = cliente['email'] ?? 'Sem email';
                    final contratoAtivo = cliente['contratoAtivo'] ?? false;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.green[50],
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.green[800],
                          size: 35,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                nome,
                                style: TextStyle(
                                  color: Colors.green[900],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (contratoAtivo)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[700],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'ATIVO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(email),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Informações do cliente
                                _buildInfoRow('CPF', cliente['cpf'] ?? 'Não informado'),
                                _buildInfoRow('Endereço', cliente['endereco'] ?? 'Não informado'),
                                _buildInfoRow('Renda', cliente['renda'] ?? 'Não informado'),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 8),
                                
                                // Botões de ação
                                Row(
                                  children: [
                                    // Botão Editar
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _editarCliente(
                                          context,
                                          clienteId,
                                          cliente,
                                        ),
                                        icon: const Icon(Icons.edit, size: 18),
                                        label: const Text('Editar'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue[600],
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Botão Excluir
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () => _excluirCliente(
                                          context,
                                          clienteId,
                                          nome,
                                        ),
                                        icon: const Icon(Icons.delete, size: 18),
                                        label: const Text('Excluir'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[600],
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Botão Ativar/Desativar Contrato
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      if (contratoAtivo) {
                                        _desativarContrato(context, clienteId, nome);
                                      } else {
                                        _ativarContrato(context, clienteId, nome);
                                      }
                                    },
                                    icon: Icon(
                                      contratoAtivo ? Icons.check_circle_outline : Icons.check_circle,
                                      size: 20,
                                    ),
                                    label: Text(
                                      contratoAtivo ? 'Desativar Contrato' : 'Ativar Contrato',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: contratoAtivo ? Colors.orange[700] : Colors.green[700],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

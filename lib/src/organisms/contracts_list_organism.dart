import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContractsListOrganism extends StatefulWidget {
  final bool expandAll;

  const ContractsListOrganism({super.key, this.expandAll = false});

  @override
  State<ContractsListOrganism> createState() => _ContractsListOrganismState();
}

class _ContractsListOrganismState extends State<ContractsListOrganism> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _finalizarContrato(String clienteId, String nomeCliente) async {
    // Mostrar diálogo de confirmação
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Finalizar Contrato'),
          content: Text('Deseja finalizar o contrato de $nomeCliente?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Finalizar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      try {
        // Atualizar o status do contrato no Firestore
        await _firestore.collection('clientes').doc(clienteId).update({
          'contratoAtivo': false,
          'dataFinalizacao': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contrato de $nomeCliente finalizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao finalizar contrato: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('clientes')
          .where('contratoAtivo', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Erro ao carregar contratos',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${snapshot.error}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        }

        // Pegar os documentos e ordenar manualmente
        final contratos = snapshot.data?.docs ?? [];

        // Ordenar por data de criação (mais recentes primeiro)
        contratos.sort((a, b) {
          final dadosA = a.data() as Map<String, dynamic>;
          final dadosB = b.data() as Map<String, dynamic>;

          final dataA = dadosA['criadoEm'] as Timestamp?;
          final dataB = dadosB['criadoEm'] as Timestamp?;

          if (dataA == null && dataB == null) return 0;
          if (dataA == null) return 1;
          if (dataB == null) return -1;

          return dataB.compareTo(dataA); // Ordem decrescente
        });

        if (contratos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 100, color: Colors.grey[400]),
                const SizedBox(height: 20),
                Text(
                  'Nenhum contrato ativo',
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),
                Text(
                  'Os contratos ativos aparecerão aqui',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: contratos.length,
          itemBuilder: (context, index) {
            final contrato = contratos[index];
            final dados = contrato.data() as Map<String, dynamic>;
            final clienteId = contrato.id;
            final nome = dados['nome'] ?? 'Sem nome';
            final cpf = dados['cpf'] ?? 'Sem CPF';
            final tipoCliente = dados['tipoCliente'] ?? 'Não informado';
            final email = dados['email'] ?? 'Sem email';

            // Formatar data de criação
            String dataCriacao = 'Data não disponível';
            if (dados['criadoEm'] != null) {
              final timestamp = dados['criadoEm'] as Timestamp;
              final data = timestamp.toDate();
              dataCriacao =
                  '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
            }

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                key: GlobalKey(),
                initiallyExpanded: widget.expandAll,
                leading: CircleAvatar(
                  backgroundColor: Colors.green[700],
                  child: Text(
                    nome[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('CPF: $cpf'),
                    Text('Tipo: $tipoCliente'),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Seção: Informações Pessoais
                        _buildSectionTitle('INFORMAÇÕES PESSOAIS'),
                        _buildInfoRow(Icons.person, 'Nome Completo', nome),
                        _buildInfoRow(
                          Icons.badge,
                          'RG/CNH',
                          dados['rg'] ?? 'Não informado',
                        ),
                        _buildInfoRow(Icons.fingerprint, 'CPF', cpf),
                        _buildInfoRow(
                          Icons.cake,
                          'Data de Nascimento',
                          dados['nascimento'] ?? 'Não informado',
                        ),
                        _buildInfoRow(
                          Icons.calendar_today,
                          'Data de Expedição RG',
                          dados['expedicao'] ?? 'Não informado',
                        ),
                        _buildInfoRow(
                          Icons.business,
                          'Emissor',
                          dados['emissor'] ?? 'Não informado',
                        ),

                        const SizedBox(height: 16),
                        const Divider(thickness: 2),
                        const SizedBox(height: 16),

                        // Seção: Contato
                        _buildSectionTitle('CONTATO'),
                        _buildInfoRow(Icons.email, 'Email', email),

                        const SizedBox(height: 16),
                        const Divider(thickness: 2),
                        const SizedBox(height: 16),

                        // Seção: Endereço
                        _buildSectionTitle('ENDEREÇO'),
                        _buildInfoRow(
                          Icons.location_city,
                          'CEP',
                          dados['cep'] ?? 'Não informado',
                        ),
                        _buildInfoRow(
                          Icons.location_on,
                          'Endereço Completo',
                          dados['endereco'] ?? 'Não informado',
                        ),

                        const SizedBox(height: 16),
                        const Divider(thickness: 2),
                        const SizedBox(height: 16),

                        // Seção: Filiação
                        _buildSectionTitle('FILIAÇÃO'),
                        _buildInfoRow(
                          Icons.man,
                          'Nome do Pai',
                          dados['pai'] ?? 'Não informado',
                        ),
                        _buildInfoRow(
                          Icons.woman,
                          'Nome da Mãe',
                          dados['mae'] ?? 'Não informado',
                        ),

                        const SizedBox(height: 16),
                        const Divider(thickness: 2),
                        const SizedBox(height: 16),

                        // Seção: Informações Financeiras
                        _buildSectionTitle('INFORMAÇÕES FINANCEIRAS'),
                        _buildInfoRow(
                          Icons.attach_money,
                          'Renda Bruta',
                          dados['renda'] ?? 'Não informado',
                        ),
                        _buildInfoRow(
                          Icons.work,
                          'Tipo de Cliente',
                          tipoCliente,
                        ),

                        const SizedBox(height: 16),
                        const Divider(thickness: 2),
                        const SizedBox(height: 16),

                        // Seção: Informações do Contrato
                        _buildSectionTitle('INFORMAÇÕES DO CONTRATO'),
                        _buildInfoRow(
                          Icons.calendar_today,
                          'Início do Contrato',
                          dataCriacao,
                        ),
                        _buildInfoRow(
                          Icons.check_circle,
                          'Status',
                          'ATIVO',
                          valueColor: Colors.green[700],
                        ),

                        const SizedBox(height: 24),
                        const Divider(thickness: 2),
                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _finalizarContrato(clienteId, nome),
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Finalizar Contrato',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[900],
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.green[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

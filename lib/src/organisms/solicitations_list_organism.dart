import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SolicitationsListOrganism extends StatelessWidget {
  const SolicitationsListOrganism({super.key});

  Future<void> _aprovarSolicitacao(
    BuildContext context,
    String docId,
    Map<String, dynamic> dados,
  ) async {
    try {
      // Criar usuário no Firebase Auth
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCred = await auth.createUserWithEmailAndPassword(
        email: dados['email'],
        password: dados['senha'],
      );

      // Salvar dados na collection usuarios
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(userCred.user!.uid)
          .set({
            'nome': dados['nome'],
            'cpf': dados['cpf'],
            'email': dados['email'],
            'createdAt': Timestamp.now(),
            'aprovadoEm': Timestamp.now(),
          });

      // Atualizar status da solicitação para aprovado
      await FirebaseFirestore.instance
          .collection('solicitacoes_cadastro')
          .doc(docId)
          .update({'status': 'aprovado', 'aprovadoEm': Timestamp.now()});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro aprovado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao criar usuário.';
      if (e.code == 'email-already-in-use') {
        message = 'Este email já está em uso.';
      } else if (e.code == 'weak-password') {
        message = 'Senha muito fraca.';
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _rejeitarSolicitacao(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('solicitacoes_cadastro')
          .doc(docId)
          .update({'status': 'rejeitado', 'rejeitadoEm': Timestamp.now()});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitação rejeitada.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('solicitacoes_cadastro')
          .where('status', isEqualTo: 'pendente')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhuma solicitação pendente',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Ordenar manualmente por data
        final solicitacoes = snapshot.data!.docs;
        solicitacoes.sort((a, b) {
          final Timestamp? timestampA =
              (a.data() as Map<String, dynamic>)['solicitadoEm'] as Timestamp?;
          final Timestamp? timestampB =
              (b.data() as Map<String, dynamic>)['solicitadoEm'] as Timestamp?;

          if (timestampA == null && timestampB == null) return 0;
          if (timestampA == null) return 1;
          if (timestampB == null) return -1;

          return timestampB.compareTo(timestampA); // Mais recente primeiro
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: solicitacoes.length,
          itemBuilder: (context, index) {
            final doc = solicitacoes[index];
            final dados = doc.data() as Map<String, dynamic>;
            final docId = doc.id;

            final Timestamp? timestamp = dados['solicitadoEm'] as Timestamp?;
            final DateTime? data = timestamp?.toDate();
            final String dataFormatada = data != null
                ? '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}'
                : 'Data não disponível';

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person_add, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dados['nome'] ?? 'Nome não informado',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(Icons.email, 'Email', dados['email']),
                    _buildInfoRow(Icons.badge, 'CPF', dados['cpf']),
                    _buildInfoRow(
                      Icons.access_time,
                      'Solicitado em',
                      dataFormatada,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Rejeitar solicitação'),
                                content: Text(
                                  'Deseja rejeitar a solicitação de ${dados['nome']}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Rejeitar'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              await _rejeitarSolicitacao(context, docId);
                            }
                          },
                          icon: const Icon(Icons.close),
                          label: const Text('Rejeitar'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Aprovar solicitação'),
                                content: Text(
                                  'Deseja aprovar a solicitação de ${dados['nome']}?\n\nUm novo usuário será criado com acesso ao sistema.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Aprovar'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && context.mounted) {
                              await _aprovarSolicitacao(context, docId, dados);
                            }
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Aprovar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(value ?? 'N/A', style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

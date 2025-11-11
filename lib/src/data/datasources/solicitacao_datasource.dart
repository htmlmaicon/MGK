import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/solicitacao_model.dart';

/// DataSource para operações com solicitações no Firestore
class SolicitacaoDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'solicitacoes_cadastro';

  SolicitacaoDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Busca todas as solicitações pendentes
  Future<List<SolicitacaoModel>> getPendentes() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('status', isEqualTo: 'pendente')
          .orderBy('solicitadoEm', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SolicitacaoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar solicitações pendentes: $e');
    }
  }

  /// Busca todas as solicitações
  Future<List<SolicitacaoModel>> getAll() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('solicitadoEm', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => SolicitacaoModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar solicitações: $e');
    }
  }

  /// Busca uma solicitação por ID
  Future<SolicitacaoModel?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return SolicitacaoModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Erro ao buscar solicitação: $e');
    }
  }

  /// Cria uma nova solicitação
  Future<String> create(SolicitacaoModel solicitacao) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(solicitacao.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao criar solicitação: $e');
    }
  }

  /// Aprova uma solicitação
  Future<void> aprovar(String id, String aprovadoPor) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'status': 'aprovada',
        'processadoEm': FieldValue.serverTimestamp(),
        'processadoPor': aprovadoPor,
      });
    } catch (e) {
      throw Exception('Erro ao aprovar solicitação: $e');
    }
  }

  /// Rejeita uma solicitação
  Future<void> rejeitar(String id, String rejeitadoPor) async {
    try {
      await _firestore.collection(_collection).doc(id).update({
        'status': 'rejeitada',
        'processadoEm': FieldValue.serverTimestamp(),
        'processadoPor': rejeitadoPor,
      });
    } catch (e) {
      throw Exception('Erro ao rejeitar solicitação: $e');
    }
  }

  /// Stream que monitora mudanças nas solicitações
  Stream<List<SolicitacaoModel>> get solicitacoesStream {
    return _firestore
        .collection(_collection)
        .orderBy('solicitadoEm', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SolicitacaoModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}

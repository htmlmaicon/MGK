import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/cliente_model.dart';

/// DataSource para operações com clientes no Firestore
class ClienteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'clientes';

  ClienteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Busca todos os clientes
  Future<List<ClienteModel>> getAll() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('dataCadastro', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ClienteModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar clientes: $e');
    }
  }

  /// Busca um cliente por ID
  Future<ClienteModel?> getById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) return null;

      return ClienteModel.fromMap(doc.data()!, doc.id);
    } catch (e) {
      throw Exception('Erro ao buscar cliente: $e');
    }
  }

  /// Adiciona um novo cliente
  Future<String> add(ClienteModel cliente) async {
    try {
      final docRef = await _firestore.collection(_collection).add(
            cliente.toMap(),
          );
      return docRef.id;
    } catch (e) {
      throw Exception('Erro ao adicionar cliente: $e');
    }
  }

  /// Atualiza um cliente existente
  Future<void> update(String id, ClienteModel cliente) async {
    try {
      await _firestore.collection(_collection).doc(id).update(
            cliente.toMap(),
          );
    } catch (e) {
      throw Exception('Erro ao atualizar cliente: $e');
    }
  }

  /// Remove um cliente
  Future<void> delete(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao remover cliente: $e');
    }
  }

  /// Busca clientes por nome (pesquisa)
  Future<List<ClienteModel>> searchByName(String nome) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('nome', isGreaterThanOrEqualTo: nome)
          .where('nome', isLessThanOrEqualTo: '$nome\uf8ff')
          .get();

      return snapshot.docs
          .map((doc) => ClienteModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao pesquisar clientes: $e');
    }
  }

  /// Stream que monitora mudanças na coleção de clientes
  Stream<List<ClienteModel>> get clientesStream {
    return _firestore
        .collection(_collection)
        .orderBy('dataCadastro', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClienteModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}

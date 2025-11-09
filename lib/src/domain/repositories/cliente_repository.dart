import '../models/cliente_model.dart';

/// Interface do Repositório de Clientes
/// Define os contratos para operações CRUD de clientes
abstract class ClienteRepository {
  /// Busca todos os clientes
  Future<List<ClienteModel>> getAll();

  /// Busca um cliente por ID
  Future<ClienteModel?> getById(String id);

  /// Adiciona um novo cliente
  Future<String> add(ClienteModel cliente);

  /// Atualiza um cliente existente
  Future<void> update(String id, ClienteModel cliente);

  /// Remove um cliente
  Future<void> delete(String id);

  /// Busca clientes por nome (pesquisa)
  Future<List<ClienteModel>> searchByName(String nome);

  /// Stream que monitora mudanças na coleção de clientes
  Stream<List<ClienteModel>> get clientesStream;
}

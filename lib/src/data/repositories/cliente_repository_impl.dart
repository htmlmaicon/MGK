import '../../domain/models/cliente_model.dart';
import '../../domain/repositories/cliente_repository.dart';
import '../datasources/cliente_datasource.dart';

/// Implementação do ClienteRepository
/// Usa ClienteDataSource para realizar operações CRUD de clientes
class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteDataSource _dataSource;

  ClienteRepositoryImpl({required ClienteDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<ClienteModel>> getAll() {
    return _dataSource.getAll();
  }

  @override
  Future<ClienteModel?> getById(String id) {
    return _dataSource.getById(id);
  }

  @override
  Future<String> add(ClienteModel cliente) {
    return _dataSource.add(cliente);
  }

  @override
  Future<void> update(String id, ClienteModel cliente) {
    return _dataSource.update(id, cliente);
  }

  @override
  Future<void> delete(String id) {
    return _dataSource.delete(id);
  }

  @override
  Future<List<ClienteModel>> searchByName(String nome) {
    return _dataSource.searchByName(nome);
  }

  @override
  Stream<List<ClienteModel>> get clientesStream => _dataSource.clientesStream;
}

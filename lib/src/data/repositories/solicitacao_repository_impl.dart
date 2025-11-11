import '../../domain/models/solicitacao_model.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../datasources/solicitacao_datasource.dart';

/// Implementação do SolicitacaoRepository
/// Usa SolicitacaoDataSource para gerenciar solicitações de cadastro
class SolicitacaoRepositoryImpl implements SolicitacaoRepository {
  final SolicitacaoDataSource _dataSource;

  SolicitacaoRepositoryImpl({required SolicitacaoDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<SolicitacaoModel>> getPendentes() {
    return _dataSource.getPendentes();
  }

  @override
  Future<List<SolicitacaoModel>> getAll() {
    return _dataSource.getAll();
  }

  @override
  Future<SolicitacaoModel?> getById(String id) {
    return _dataSource.getById(id);
  }

  @override
  Future<String> create(SolicitacaoModel solicitacao) {
    return _dataSource.create(solicitacao);
  }

  @override
  Future<void> aprovar(String id, String aprovadoPor) {
    return _dataSource.aprovar(id, aprovadoPor);
  }

  @override
  Future<void> rejeitar(String id, String rejeitadoPor) {
    return _dataSource.rejeitar(id, rejeitadoPor);
  }

  @override
  Stream<List<SolicitacaoModel>> get solicitacoesStream =>
      _dataSource.solicitacoesStream;
}

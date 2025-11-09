import '../models/solicitacao_model.dart';

/// Interface do Repositório de Solicitações de Cadastro
/// Define os contratos para gerenciar solicitações de cadastro
abstract class SolicitacaoRepository {
  /// Busca todas as solicitações pendentes
  Future<List<SolicitacaoModel>> getPendentes();

  /// Busca todas as solicitações
  Future<List<SolicitacaoModel>> getAll();

  /// Busca uma solicitação por ID
  Future<SolicitacaoModel?> getById(String id);

  /// Cria uma nova solicitação
  Future<String> create(SolicitacaoModel solicitacao);

  /// Aprova uma solicitação
  Future<void> aprovar(String id, String aprovadoPor);

  /// Rejeita uma solicitação
  Future<void> rejeitar(String id, String rejeitadoPor);

  /// Stream que monitora mudanças nas solicitações
  Stream<List<SolicitacaoModel>> get solicitacoesStream;
}

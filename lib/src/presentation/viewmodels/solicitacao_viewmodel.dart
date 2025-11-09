import 'package:flutter/foundation.dart';
import '../../domain/models/solicitacao_model.dart';
import '../../domain/repositories/solicitacao_repository.dart';
import '../../domain/repositories/auth_repository.dart';

/// ViewModel para gerenciar o estado de solicitações de cadastro
/// Usa ChangeNotifier para notificar mudanças e Provider para injeção de dependência
class SolicitacaoViewModel extends ChangeNotifier {
  final SolicitacaoRepository _solicitacaoRepository;
  final AuthRepository _authRepository;

  List<SolicitacaoModel> _solicitacoes = [];
  bool _isLoading = false;
  String? _errorMessage;

  SolicitacaoViewModel({
    required SolicitacaoRepository solicitacaoRepository,
    required AuthRepository authRepository,
  })  : _solicitacaoRepository = solicitacaoRepository,
        _authRepository = authRepository {
    _initialize();
  }

  // Getters
  List<SolicitacaoModel> get solicitacoes => _solicitacoes;

  List<SolicitacaoModel> get solicitacoesPendentes =>
      _solicitacoes.where((s) => s.status == SolicitacaoStatus.pendente).toList();

  List<SolicitacaoModel> get solicitacoesAprovadas =>
      _solicitacoes.where((s) => s.status == SolicitacaoStatus.aprovada).toList();

  List<SolicitacaoModel> get solicitacoesRejeitadas =>
      _solicitacoes.where((s) => s.status == SolicitacaoStatus.rejeitada).toList();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get totalPendentes => solicitacoesPendentes.length;

  /// Inicializa o ViewModel carregando solicitações
  void _initialize() {
    loadSolicitacoes();
    _listenSolicitacoesChanges();
  }

  /// Escuta mudanças na coleção de solicitações
  void _listenSolicitacoesChanges() {
    _solicitacaoRepository.solicitacoesStream.listen((solicitacoes) {
      _solicitacoes = solicitacoes;
      notifyListeners();
    });
  }

  /// Carrega todas as solicitações
  Future<void> loadSolicitacoes() async {
    _setLoading(true);
    _clearError();

    try {
      _solicitacoes = await _solicitacaoRepository.getAll();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Carrega apenas solicitações pendentes
  Future<void> loadSolicitacoesPendentes() async {
    _setLoading(true);
    _clearError();

    try {
      _solicitacoes = await _solicitacaoRepository.getPendentes();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Cria uma nova solicitação
  Future<bool> createSolicitacao(SolicitacaoModel solicitacao) async {
    _setLoading(true);
    _clearError();

    try {
      await _solicitacaoRepository.create(solicitacao);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Aprova uma solicitação
  Future<bool> aprovarSolicitacao(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final user = _authRepository.getCurrentUser();
      if (user == null) {
        _setError('Usuário não autenticado');
        _setLoading(false);
        return false;
      }

      // Buscar solicitação para obter dados
      final solicitacao = await _solicitacaoRepository.getById(id);
      if (solicitacao == null) {
        _setError('Solicitação não encontrada');
        _setLoading(false);
        return false;
      }

      // Criar usuário no sistema
      final newUser = await _authRepository.createUser(
        solicitacao.email,
        solicitacao.senha,
        solicitacao.nome,
      );

      if (newUser == null) {
        _setError('Erro ao criar usuário');
        _setLoading(false);
        return false;
      }

      // Aprovar solicitação
      await _solicitacaoRepository.aprovar(id, user.email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Rejeita uma solicitação
  Future<bool> rejeitarSolicitacao(String id) async {
    _setLoading(true);
    _clearError();

    try {
      final user = _authRepository.getCurrentUser();
      if (user == null) {
        _setError('Usuário não autenticado');
        _setLoading(false);
        return false;
      }

      await _solicitacaoRepository.rejeitar(id, user.email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpa mensagem de erro
  void clearError() {
    _clearError();
  }
}

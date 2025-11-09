import 'package:flutter/foundation.dart';
import '../../domain/models/cliente_model.dart';
import '../../domain/repositories/cliente_repository.dart';

/// ViewModel para gerenciar o estado de clientes
/// Usa ChangeNotifier para notificar mudanças e Provider para injeção de dependência
class ClienteViewModel extends ChangeNotifier {
  final ClienteRepository _clienteRepository;

  List<ClienteModel> _clientes = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  ClienteViewModel({required ClienteRepository clienteRepository})
      : _clienteRepository = clienteRepository {
    _initialize();
  }

  // Getters
  List<ClienteModel> get clientes => _searchQuery.isEmpty
      ? _clientes
      : _clientes
          .where((c) =>
              c.nome.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              c.cpf.contains(_searchQuery) ||
              c.email.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  /// Inicializa o ViewModel carregando clientes
  void _initialize() {
    loadClientes();
    _listenClientesChanges();
  }

  /// Escuta mudanças na coleção de clientes
  void _listenClientesChanges() {
    _clienteRepository.clientesStream.listen((clientes) {
      _clientes = clientes;
      notifyListeners();
    });
  }

  /// Carrega todos os clientes
  Future<void> loadClientes() async {
    _setLoading(true);
    _clearError();

    try {
      _clientes = await _clienteRepository.getAll();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Adiciona um novo cliente
  Future<bool> addCliente(ClienteModel cliente) async {
    _setLoading(true);
    _clearError();

    try {
      await _clienteRepository.add(cliente);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Atualiza um cliente existente
  Future<bool> updateCliente(String id, ClienteModel cliente) async {
    _setLoading(true);
    _clearError();

    try {
      await _clienteRepository.update(id, cliente);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Remove um cliente
  Future<bool> deleteCliente(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await _clienteRepository.delete(id);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Define o termo de pesquisa
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Limpa o termo de pesquisa
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
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

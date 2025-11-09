import 'package:flutter/foundation.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

/// ViewModel para gerenciar o estado de autenticação
/// Usa ChangeNotifier para notificar mudanças e Provider para injeção de dependência
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _initialize();
  }

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  /// Inicializa o ViewModel verificando o usuário atual
  void _initialize() {
    _currentUser = _authRepository.getCurrentUser();
    _listenAuthChanges();
  }

  /// Escuta mudanças no estado de autenticação
  void _listenAuthChanges() {
    _authRepository.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  /// Realiza login
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _authRepository.signIn(email, password);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Realiza logout
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authRepository.signOut();
      _currentUser = null;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Cria um novo usuário
  Future<bool> createUser(String email, String password, String nome) async {
    _setLoading(true);
    _clearError();

    try {
      _currentUser = await _authRepository.createUser(email, password, nome);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Verifica permissões para criar cliente
  bool canCreateClient() => isAdmin;

  /// Verifica permissões para editar cliente
  bool canEditClient() => isAdmin;

  /// Verifica permissões para excluir cliente
  bool canDeleteClient() => isAdmin;

  /// Verifica permissões para gerenciar contratos
  bool canManageContract() => isLoggedIn;

  /// Verifica permissões para visualizar clientes
  bool canViewClients() => isLoggedIn;

  /// Obtém mensagem de permissão negada
  String getPermissionDeniedMessage() {
    return 'Apenas o administrador (admin@gmail.com) pode realizar esta ação.';
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

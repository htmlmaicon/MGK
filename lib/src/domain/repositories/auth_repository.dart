import '../models/user_model.dart';

/// Interface do Repositório de Autenticação
/// Define os contratos para operações de autenticação
abstract class AuthRepository {
  /// Realiza login com email e senha
  Future<UserModel?> signIn(String email, String password);

  /// Realiza logout
  Future<void> signOut();

  /// Retorna o usuário atualmente logado
  UserModel? getCurrentUser();

  /// Verifica se há um usuário logado
  bool isLoggedIn();

  /// Verifica se o usuário atual é administrador
  bool isAdmin();

  /// Cria uma nova conta de usuário
  Future<UserModel?> createUser(String email, String password, String nome);

  /// Stream que monitora mudanças no estado de autenticação
  Stream<UserModel?> get authStateChanges;
}

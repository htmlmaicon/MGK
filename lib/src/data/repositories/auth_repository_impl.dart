import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

/// Implementação do AuthRepository
/// Usa AuthDataSource para realizar operações de autenticação
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl({required AuthDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<UserModel?> signIn(String email, String password) {
    return _dataSource.signIn(email, password);
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  bool isLoggedIn() {
    return _dataSource.isLoggedIn();
  }

  @override
  bool isAdmin() {
    return _dataSource.isAdmin();
  }

  @override
  Future<UserModel?> createUser(String email, String password, String nome) {
    return _dataSource.createUser(email, password, nome);
  }

  @override
  Stream<UserModel?> get authStateChanges => _dataSource.authStateChanges;
}

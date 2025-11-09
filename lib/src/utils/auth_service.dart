import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Email do administrador
  static const String adminEmail = 'admin@gmail.com';

  // Verificar se o usuário atual é administrador
  bool isAdmin() {
    final user = _auth.currentUser;
    if (user == null) return false;
    return user.email?.toLowerCase() == adminEmail.toLowerCase();
  }

  // Verificar se o usuário está logado
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  // Obter email do usuário atual
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Obter usuário atual
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Verificar permissão para criar cliente
  bool canCreateClient() {
    return isAdmin();
  }

  // Verificar permissão para editar cliente
  bool canEditClient() {
    return isAdmin();
  }

  // Verificar permissão para excluir cliente
  bool canDeleteClient() {
    return isAdmin();
  }

  // Verificar permissão para ativar/desativar contrato (todos podem)
  bool canManageContract() {
    return isLoggedIn();
  }

  // Verificar permissão para visualizar clientes (todos podem)
  bool canViewClients() {
    return isLoggedIn();
  }

  // Mostrar mensagem de permissão negada
  static String getPermissionDeniedMessage() {
    return 'Apenas o administrador (admin@gmail.com) pode realizar esta ação.';
  }
}

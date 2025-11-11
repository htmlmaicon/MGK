import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/user_model.dart';

/// DataSource para operações de autenticação com Firebase
class AuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  static const String adminEmail = 'admin@gmail.com';

  AuthDataSource({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  /// Realiza login com email e senha
  Future<UserModel?> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      return _convertFirebaseUser(userCredential.user!);
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  /// Realiza logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Retorna o usuário atualmente logado
  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _convertFirebaseUser(user);
  }

  /// Verifica se há um usuário logado
  bool isLoggedIn() {
    return _firebaseAuth.currentUser != null;
  }

  /// Verifica se o usuário atual é administrador
  bool isAdmin() {
    final user = _firebaseAuth.currentUser;
    if (user == null) return false;
    return user.email?.toLowerCase() == adminEmail.toLowerCase();
  }

  /// Cria uma nova conta de usuário
  Future<UserModel?> createUser(
    String email,
    String password,
    String nome,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      // Atualizar display name
      await userCredential.user!.updateDisplayName(nome);

      // Criar documento do usuário no Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'displayName': nome,
        'isAdmin': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return _convertFirebaseUser(userCredential.user!);
    } catch (e) {
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  /// Stream que monitora mudanças no estado de autenticação
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return _convertFirebaseUser(user);
    });
  }

  /// Converte User do Firebase para UserModel
  UserModel _convertFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      isAdmin: user.email?.toLowerCase() == adminEmail.toLowerCase(),
      createdAt: user.metadata.creationTime,
    );
  }
}

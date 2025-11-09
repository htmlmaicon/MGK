/// Modelo de domínio para Usuário
/// Representa um usuário do sistema com suas permissões
class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final bool isAdmin;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.isAdmin = false,
    this.createdAt,
  });

  /// Cria uma instância de UserModel a partir de um Map
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      isAdmin: map['isAdmin'] ?? false,
      createdAt: map['createdAt']?.toDate(),
    );
  }

  /// Converte UserModel para Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'isAdmin': isAdmin,
      'createdAt': createdAt,
    };
  }

  /// Cria uma cópia do UserModel com valores atualizados
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? isAdmin,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isAdmin: isAdmin ?? this.isAdmin,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.uid == uid && other.email == email;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ email.hashCode;
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, isAdmin: $isAdmin)';
  }
}

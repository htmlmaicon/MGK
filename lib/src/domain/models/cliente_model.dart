/// Modelo de domínio para Cliente
/// Representa a entidade Cliente no domínio da aplicação
class ClienteModel {
  final String? id;
  final String nome;
  final String cpf;
  final String email;
  final String? telefone;
  final String? endereco;
  final DateTime dataCadastro;
  final bool ativo;

  ClienteModel({
    this.id,
    required this.nome,
    required this.cpf,
    required this.email,
    this.telefone,
    this.endereco,
    required this.dataCadastro,
    this.ativo = true,
  });

  /// Cria uma instância de ClienteModel a partir de um Map
  factory ClienteModel.fromMap(Map<String, dynamic> map, String id) {
    return ClienteModel(
      id: id,
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'],
      endereco: map['endereco'],
      dataCadastro: map['dataCadastro']?.toDate() ?? DateTime.now(),
      ativo: map['ativo'] ?? true,
    );
  }

  /// Converte ClienteModel para Map
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'dataCadastro': dataCadastro,
      'ativo': ativo,
    };
  }

  /// Cria uma cópia do ClienteModel com valores atualizados
  ClienteModel copyWith({
    String? id,
    String? nome,
    String? cpf,
    String? email,
    String? telefone,
    String? endereco,
    DateTime? dataCadastro,
    bool? ativo,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      endereco: endereco ?? this.endereco,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ClienteModel &&
        other.id == id &&
        other.nome == nome &&
        other.cpf == cpf &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ nome.hashCode ^ cpf.hashCode ^ email.hashCode;
  }

  @override
  String toString() {
    return 'ClienteModel(id: $id, nome: $nome, cpf: $cpf, email: $email)';
  }
}

/// Modelo de domínio para Solicitação de Cadastro
/// Representa uma solicitação de cadastro de usuário pendente de aprovação
enum SolicitacaoStatus { pendente, aprovada, rejeitada }

class SolicitacaoModel {
  final String? id;
  final String nome;
  final String cpf;
  final String email;
  final String senha;
  final SolicitacaoStatus status;
  final DateTime solicitadoEm;
  final DateTime? processadoEm;
  final String? processadoPor;

  SolicitacaoModel({
    this.id,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.senha,
    this.status = SolicitacaoStatus.pendente,
    required this.solicitadoEm,
    this.processadoEm,
    this.processadoPor,
  });

  /// Cria uma instância de SolicitacaoModel a partir de um Map
  factory SolicitacaoModel.fromMap(Map<String, dynamic> map, String id) {
    return SolicitacaoModel(
      id: id,
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
      status: _parseStatus(map['status']),
      solicitadoEm: map['solicitadoEm']?.toDate() ?? DateTime.now(),
      processadoEm: map['processadoEm']?.toDate(),
      processadoPor: map['processadoPor'],
    );
  }

  /// Converte SolicitacaoModel para Map
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
      'status': _statusToString(status),
      'solicitadoEm': solicitadoEm,
      'processadoEm': processadoEm,
      'processadoPor': processadoPor,
    };
  }

  /// Converte string para SolicitacaoStatus
  static SolicitacaoStatus _parseStatus(String? status) {
    switch (status) {
      case 'aprovada':
        return SolicitacaoStatus.aprovada;
      case 'rejeitada':
        return SolicitacaoStatus.rejeitada;
      default:
        return SolicitacaoStatus.pendente;
    }
  }

  /// Converte SolicitacaoStatus para string
  static String _statusToString(SolicitacaoStatus status) {
    switch (status) {
      case SolicitacaoStatus.aprovada:
        return 'aprovada';
      case SolicitacaoStatus.rejeitada:
        return 'rejeitada';
      default:
        return 'pendente';
    }
  }

  /// Cria uma cópia do SolicitacaoModel com valores atualizados
  SolicitacaoModel copyWith({
    String? id,
    String? nome,
    String? cpf,
    String? email,
    String? senha,
    SolicitacaoStatus? status,
    DateTime? solicitadoEm,
    DateTime? processadoEm,
    String? processadoPor,
  }) {
    return SolicitacaoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      status: status ?? this.status,
      solicitadoEm: solicitadoEm ?? this.solicitadoEm,
      processadoEm: processadoEm ?? this.processadoEm,
      processadoPor: processadoPor ?? this.processadoPor,
    );
  }

  @override
  String toString() {
    return 'SolicitacaoModel(id: $id, nome: $nome, email: $email, status: $status)';
  }
}

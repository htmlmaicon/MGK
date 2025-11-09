import 'package:flutter_test/flutter_test.dart';
import 'package:mgk/src/domain/models/solicitacao_model.dart';

void main() {
  group('SolicitacaoModel Tests', () {
    test('Deve criar SolicitacaoModel corretamente', () {
      // Arrange
      final solicitadoEm = DateTime(2024, 1, 1);

      // Act
      final solicitacao = SolicitacaoModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        senha: 'senha123',
        status: SolicitacaoStatus.pendente,
        solicitadoEm: solicitadoEm,
      );

      // Assert
      expect(solicitacao.id, '1');
      expect(solicitacao.nome, 'João Silva');
      expect(solicitacao.cpf, '12345678900');
      expect(solicitacao.email, 'joao@email.com');
      expect(solicitacao.senha, 'senha123');
      expect(solicitacao.status, SolicitacaoStatus.pendente);
      expect(solicitacao.solicitadoEm, solicitadoEm);
    });

    test('Status deve ser pendente por padrão', () {
      // Arrange & Act
      final solicitacao = SolicitacaoModel(
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        senha: 'senha123',
        solicitadoEm: DateTime.now(),
      );

      // Assert
      expect(solicitacao.status, SolicitacaoStatus.pendente);
    });

    test('Deve converter SolicitacaoModel para Map', () {
      // Arrange
      final solicitadoEm = DateTime(2024, 1, 1);
      final solicitacao = SolicitacaoModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        senha: 'senha123',
        status: SolicitacaoStatus.aprovada,
        solicitadoEm: solicitadoEm,
      );

      // Act
      final map = solicitacao.toMap();

      // Assert
      expect(map['nome'], 'João Silva');
      expect(map['cpf'], '12345678900');
      expect(map['email'], 'joao@email.com');
      expect(map['senha'], 'senha123');
      expect(map['status'], 'aprovada');
      expect(map['solicitadoEm'], solicitadoEm);
    });

    test('Deve criar SolicitacaoModel a partir de Map', () {
      // Arrange
      final solicitadoEm = DateTime(2024, 1, 1);
      final map = {
        'nome': 'Maria Santos',
        'cpf': '98765432100',
        'email': 'maria@email.com',
        'senha': 'senha456',
        'status': 'rejeitada',
        'solicitadoEm': MockTimestamp(solicitadoEm),
      };

      // Act
      final solicitacao = SolicitacaoModel.fromMap(map, '2');

      // Assert
      expect(solicitacao.id, '2');
      expect(solicitacao.nome, 'Maria Santos');
      expect(solicitacao.cpf, '98765432100');
      expect(solicitacao.email, 'maria@email.com');
      expect(solicitacao.senha, 'senha456');
      expect(solicitacao.status, SolicitacaoStatus.rejeitada);
    });

    test('Deve criar cópia de SolicitacaoModel com valores atualizados', () {
      // Arrange
      final solicitacao = SolicitacaoModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        senha: 'senha123',
        solicitadoEm: DateTime(2024, 1, 1),
      );

      final processadoEm = DateTime(2024, 1, 2);

      // Act
      final solicitacaoAprovada = solicitacao.copyWith(
        status: SolicitacaoStatus.aprovada,
        processadoEm: processadoEm,
        processadoPor: 'admin@gmail.com',
      );

      // Assert
      expect(solicitacaoAprovada.id, '1');
      expect(solicitacaoAprovada.status, SolicitacaoStatus.aprovada);
      expect(solicitacaoAprovada.processadoEm, processadoEm);
      expect(solicitacaoAprovada.processadoPor, 'admin@gmail.com');
    });

    test('Deve converter status para string corretamente', () {
      // Arrange & Act
      final pendente = SolicitacaoModel(
        nome: 'Test',
        cpf: '123',
        email: 'test@email.com',
        senha: '123',
        status: SolicitacaoStatus.pendente,
        solicitadoEm: DateTime.now(),
      );

      final aprovada = pendente.copyWith(status: SolicitacaoStatus.aprovada);
      final rejeitada = pendente.copyWith(status: SolicitacaoStatus.rejeitada);

      // Assert
      expect(pendente.toMap()['status'], 'pendente');
      expect(aprovada.toMap()['status'], 'aprovada');
      expect(rejeitada.toMap()['status'], 'rejeitada');
    });

    test('Deve parsear status de string corretamente', () {
      // Arrange
      final mapPendente = {
        'nome': 'Test',
        'cpf': '123',
        'email': 'test@email.com',
        'senha': '123',
        'status': 'pendente',
        'solicitadoEm': MockTimestamp(DateTime.now()),
      };

      final mapAprovada = {...mapPendente, 'status': 'aprovada'};
      final mapRejeitada = {...mapPendente, 'status': 'rejeitada'};
      final mapInvalida = {...mapPendente, 'status': 'invalida'};

      // Act
      final pendente = SolicitacaoModel.fromMap(mapPendente, '1');
      final aprovada = SolicitacaoModel.fromMap(mapAprovada, '2');
      final rejeitada = SolicitacaoModel.fromMap(mapRejeitada, '3');
      final invalida = SolicitacaoModel.fromMap(mapInvalida, '4');

      // Assert
      expect(pendente.status, SolicitacaoStatus.pendente);
      expect(aprovada.status, SolicitacaoStatus.aprovada);
      expect(rejeitada.status, SolicitacaoStatus.rejeitada);
      expect(invalida.status, SolicitacaoStatus.pendente); // Default
    });

    test('Deve gerar toString corretamente', () {
      // Arrange
      final solicitacao = SolicitacaoModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        senha: 'senha123',
        status: SolicitacaoStatus.pendente,
        solicitadoEm: DateTime(2024, 1, 1),
      );

      // Act
      final string = solicitacao.toString();

      // Assert
      expect(string, contains('SolicitacaoModel'));
      expect(string, contains('id: 1'));
      expect(string, contains('nome: João Silva'));
      expect(string, contains('email: joao@email.com'));
      expect(string, contains('status: SolicitacaoStatus.pendente'));
    });
  });
}

class MockTimestamp {
  final DateTime dateTime;
  MockTimestamp(this.dateTime);
  DateTime toDate() => dateTime;
}

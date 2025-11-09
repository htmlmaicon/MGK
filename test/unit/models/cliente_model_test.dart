import 'package:flutter_test/flutter_test.dart';
import 'package:mgk/src/domain/models/cliente_model.dart';

void main() {
  group('ClienteModel Tests', () {
    test('Deve criar ClienteModel corretamente', () {
      // Arrange
      final dataCadastro = DateTime(2024, 1, 1);

      // Act
      final cliente = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        telefone: '11999999999',
        endereco: 'Rua A, 123',
        dataCadastro: dataCadastro,
        ativo: true,
      );

      // Assert
      expect(cliente.id, '1');
      expect(cliente.nome, 'João Silva');
      expect(cliente.cpf, '12345678900');
      expect(cliente.email, 'joao@email.com');
      expect(cliente.telefone, '11999999999');
      expect(cliente.endereco, 'Rua A, 123');
      expect(cliente.dataCadastro, dataCadastro);
      expect(cliente.ativo, true);
    });

    test('Deve converter ClienteModel para Map corretamente', () {
      // Arrange
      final dataCadastro = DateTime(2024, 1, 1);
      final cliente = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: dataCadastro,
      );

      // Act
      final map = cliente.toMap();

      // Assert
      expect(map['nome'], 'João Silva');
      expect(map['cpf'], '12345678900');
      expect(map['email'], 'joao@email.com');
      expect(map['dataCadastro'], dataCadastro);
      expect(map['ativo'], true);
    });

    test('Deve criar ClienteModel a partir de Map', () {
      // Arrange
      final dataCadastro = DateTime(2024, 1, 1);
      final map = {
        'nome': 'Maria Santos',
        'cpf': '98765432100',
        'email': 'maria@email.com',
        'telefone': '11988888888',
        'endereco': 'Rua B, 456',
        'dataCadastro': MockTimestamp(dataCadastro),
        'ativo': false,
      };

      // Act
      final cliente = ClienteModel.fromMap(map, '2');

      // Assert
      expect(cliente.id, '2');
      expect(cliente.nome, 'Maria Santos');
      expect(cliente.cpf, '98765432100');
      expect(cliente.email, 'maria@email.com');
      expect(cliente.telefone, '11988888888');
      expect(cliente.endereco, 'Rua B, 456');
      expect(cliente.ativo, false);
    });

    test('Deve criar cópia de ClienteModel com valores atualizados', () {
      // Arrange
      final cliente = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: DateTime(2024, 1, 1),
      );

      // Act
      final clienteAtualizado = cliente.copyWith(
        nome: 'João Pedro Silva',
        email: 'joaopedro@email.com',
      );

      // Assert
      expect(clienteAtualizado.id, '1');
      expect(clienteAtualizado.nome, 'João Pedro Silva');
      expect(clienteAtualizado.cpf, '12345678900');
      expect(clienteAtualizado.email, 'joaopedro@email.com');
    });

    test('Deve comparar ClienteModel corretamente', () {
      // Arrange
      final cliente1 = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: DateTime(2024, 1, 1),
      );

      final cliente2 = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: DateTime(2024, 1, 1),
      );

      final cliente3 = ClienteModel(
        id: '2',
        nome: 'Maria Santos',
        cpf: '98765432100',
        email: 'maria@email.com',
        dataCadastro: DateTime(2024, 1, 1),
      );

      // Assert
      expect(cliente1 == cliente2, true);
      expect(cliente1 == cliente3, false);
    });

    test('Deve gerar toString corretamente', () {
      // Arrange
      final cliente = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: DateTime(2024, 1, 1),
      );

      // Act
      final string = cliente.toString();

      // Assert
      expect(string, contains('ClienteModel'));
      expect(string, contains('id: 1'));
      expect(string, contains('nome: João Silva'));
      expect(string, contains('cpf: 12345678900'));
      expect(string, contains('email: joao@email.com'));
    });
  });
}

// Mock class para simular Timestamp do Firestore
class MockTimestamp {
  final DateTime dateTime;
  MockTimestamp(this.dateTime);
  DateTime toDate() => dateTime;
}

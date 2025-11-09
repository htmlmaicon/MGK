import 'package:flutter_test/flutter_test.dart';
import 'package:mgk/src/domain/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('Deve criar UserModel corretamente', () {
      // Arrange & Act
      final user = UserModel(
        uid: 'user123',
        email: 'user@email.com',
        displayName: 'João Silva',
        isAdmin: false,
        createdAt: DateTime(2024, 1, 1),
      );

      // Assert
      expect(user.uid, 'user123');
      expect(user.email, 'user@email.com');
      expect(user.displayName, 'João Silva');
      expect(user.isAdmin, false);
      expect(user.createdAt, DateTime(2024, 1, 1));
    });

    test('Deve criar UserModel admin corretamente', () {
      // Arrange & Act
      final admin = UserModel(
        uid: 'admin123',
        email: 'admin@gmail.com',
        displayName: 'Administrador',
        isAdmin: true,
      );

      // Assert
      expect(admin.uid, 'admin123');
      expect(admin.email, 'admin@gmail.com');
      expect(admin.isAdmin, true);
    });

    test('Deve converter UserModel para Map', () {
      // Arrange
      final user = UserModel(
        uid: 'user123',
        email: 'user@email.com',
        displayName: 'João Silva',
        isAdmin: false,
        createdAt: DateTime(2024, 1, 1),
      );

      // Act
      final map = user.toMap();

      // Assert
      expect(map['email'], 'user@email.com');
      expect(map['displayName'], 'João Silva');
      expect(map['isAdmin'], false);
      expect(map['createdAt'], DateTime(2024, 1, 1));
    });

    test('Deve criar UserModel a partir de Map', () {
      // Arrange
      final createdAt = DateTime(2024, 1, 1);
      final map = {
        'email': 'user@email.com',
        'displayName': 'João Silva',
        'isAdmin': false,
        'createdAt': MockTimestamp(createdAt),
      };

      // Act
      final user = UserModel.fromMap(map, 'user123');

      // Assert
      expect(user.uid, 'user123');
      expect(user.email, 'user@email.com');
      expect(user.displayName, 'João Silva');
      expect(user.isAdmin, false);
    });

    test('Deve criar cópia de UserModel com valores atualizados', () {
      // Arrange
      final user = UserModel(
        uid: 'user123',
        email: 'user@email.com',
        displayName: 'João Silva',
        isAdmin: false,
      );

      // Act
      final updatedUser = user.copyWith(
        displayName: 'João Pedro Silva',
        isAdmin: true,
      );

      // Assert
      expect(updatedUser.uid, 'user123');
      expect(updatedUser.email, 'user@email.com');
      expect(updatedUser.displayName, 'João Pedro Silva');
      expect(updatedUser.isAdmin, true);
    });

    test('Deve comparar UserModel corretamente', () {
      // Arrange
      final user1 = UserModel(
        uid: 'user123',
        email: 'user@email.com',
      );

      final user2 = UserModel(
        uid: 'user123',
        email: 'user@email.com',
      );

      final user3 = UserModel(
        uid: 'user456',
        email: 'other@email.com',
      );

      // Assert
      expect(user1 == user2, true);
      expect(user1 == user3, false);
    });

    test('Deve gerar toString corretamente', () {
      // Arrange
      final user = UserModel(
        uid: 'user123',
        email: 'user@email.com',
        isAdmin: true,
      );

      // Act
      final string = user.toString();

      // Assert
      expect(string, contains('UserModel'));
      expect(string, contains('uid: user123'));
      expect(string, contains('email: user@email.com'));
      expect(string, contains('isAdmin: true'));
    });

    test('isAdmin deve ser false por padrão', () {
      // Arrange & Act
      final user = UserModel(
        uid: 'user123',
        email: 'user@email.com',
      );

      // Assert
      expect(user.isAdmin, false);
    });
  });
}

class MockTimestamp {
  final DateTime dateTime;
  MockTimestamp(this.dateTime);
  DateTime toDate() => dateTime;
}

import 'package:flutter_test/flutter_test.dart';

/// Classe de validação para lógica de negócio
class Validators {
  /// Valida CPF (formato brasileiro)
  static bool isValidCPF(String cpf) {
    // Remove caracteres não numéricos
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se tem 11 dígitos
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

    // Validação dos dígitos verificadores
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cpf[i]) * (10 - i);
    }
    int digit1 = 11 - (sum % 11);
    if (digit1 >= 10) digit1 = 0;

    if (digit1 != int.parse(cpf[9])) return false;

    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cpf[i]) * (11 - i);
    }
    int digit2 = 11 - (sum % 11);
    if (digit2 >= 10) digit2 = 0;

    return digit2 == int.parse(cpf[10]);
  }

  /// Valida email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Valida senha (mínimo 6 caracteres)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Valida nome (não vazio e pelo menos 2 caracteres)
  static bool isValidName(String name) {
    return name.trim().length >= 2;
  }

  /// Valida telefone brasileiro
  static bool isValidPhone(String phone) {
    final phoneDigits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return phoneDigits.length == 10 || phoneDigits.length == 11;
  }
}

void main() {
  group('Validators Tests - Lógica de Negócio', () {
    group('CPF Validation', () {
      test('Deve validar CPF correto', () {
        expect(Validators.isValidCPF('12345678909'), true);
        expect(Validators.isValidCPF('111.444.777-35'), true);
      });

      test('Deve rejeitar CPF inválido', () {
        expect(Validators.isValidCPF('12345678900'), false);
        expect(Validators.isValidCPF('00000000000'), false);
        expect(Validators.isValidCPF('11111111111'), false);
      });

      test('Deve rejeitar CPF com menos de 11 dígitos', () {
        expect(Validators.isValidCPF('123456789'), false);
        expect(Validators.isValidCPF(''), false);
      });

      test('Deve aceitar CPF com formatação', () {
        expect(Validators.isValidCPF('123.456.789-09'), true);
      });
    });

    group('Email Validation', () {
      test('Deve validar email correto', () {
        expect(Validators.isValidEmail('user@example.com'), true);
        expect(Validators.isValidEmail('test.user@domain.com.br'), true);
        expect(Validators.isValidEmail('admin@gmail.com'), true);
      });

      test('Deve rejeitar email inválido', () {
        expect(Validators.isValidEmail(''), false);
        expect(Validators.isValidEmail('invalid'), false);
        expect(Validators.isValidEmail('invalid@'), false);
        expect(Validators.isValidEmail('@invalid.com'), false);
        expect(Validators.isValidEmail('invalid@.com'), false);
      });
    });

    group('Password Validation', () {
      test('Deve validar senha com mínimo 6 caracteres', () {
        expect(Validators.isValidPassword('123456'), true);
        expect(Validators.isValidPassword('senha123'), true);
        expect(Validators.isValidPassword('SuperSenha@2024'), true);
      });

      test('Deve rejeitar senha com menos de 6 caracteres', () {
        expect(Validators.isValidPassword(''), false);
        expect(Validators.isValidPassword('12345'), false);
        expect(Validators.isValidPassword('abc'), false);
      });
    });

    group('Name Validation', () {
      test('Deve validar nome correto', () {
        expect(Validators.isValidName('João Silva'), true);
        expect(Validators.isValidName('Maria'), true);
        expect(Validators.isValidName('José da Silva Santos'), true);
      });

      test('Deve rejeitar nome inválido', () {
        expect(Validators.isValidName(''), false);
        expect(Validators.isValidName(' '), false);
        expect(Validators.isValidName('A'), false);
      });
    });

    group('Phone Validation', () {
      test('Deve validar telefone brasileiro correto', () {
        expect(Validators.isValidPhone('11999999999'), true);
        expect(Validators.isValidPhone('1133333333'), true);
        expect(Validators.isValidPhone('(11) 99999-9999'), true);
        expect(Validators.isValidPhone('(11) 3333-3333'), true);
      });

      test('Deve rejeitar telefone inválido', () {
        expect(Validators.isValidPhone(''), false);
        expect(Validators.isValidPhone('123'), false);
        expect(Validators.isValidPhone('119999999999'), false);
      });
    });
  });
}

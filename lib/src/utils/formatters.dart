import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Formatador de CPF: 000.000.000-00
class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove tudo que não é número
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Se vazio, retorna vazio
    if (text.isEmpty) {
      return const TextEditingValue(text: '');
    }
    
    // Limita a 11 dígitos (tamanho do CPF)
    final cleanText = text.length > 11 ? text.substring(0, 11) : text;

    // Formata o CPF
    String formatted = '';
    for (int i = 0; i < cleanText.length; i++) {
      if (i == 3 || i == 6) {
        formatted += '.';
      } else if (i == 9) {
        formatted += '-';
      }
      formatted += cleanText[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatador de Data: DD/MM/AAAA
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove tudo que não é número
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Se vazio, retorna vazio
    if (text.isEmpty) {
      return const TextEditingValue(text: '');
    }
    
    // Limita a 8 dígitos (DDMMAAAA)
    final cleanText = text.length > 8 ? text.substring(0, 8) : text;

    // Formata a data
    String formatted = '';
    for (int i = 0; i < cleanText.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += cleanText[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formatador de CEP: 00000-000
class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove tudo que não é número
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Se vazio, retorna vazio
    if (text.isEmpty) {
      return const TextEditingValue(text: '');
    }
    
    // Limita a 8 dígitos (tamanho do CEP)
    final cleanText = text.length > 8 ? text.substring(0, 8) : text;

    // Formata o CEP
    String formatted = '';
    for (int i = 0; i < cleanText.length; i++) {
      if (i == 5) {
        formatted += '-';
      }
      formatted += cleanText[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Funções que retornam novas instâncias dos formatadores
CpfInputFormatter cpfFormatter() => CpfInputFormatter();
DateInputFormatter dateFormatter() => DateInputFormatter();
CepInputFormatter cepFormatter() => CepInputFormatter();

/// Formatador de moeda brasileira
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove todos os caracteres não numéricos
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Converte para double e formata
    double value = double.parse(text) / 100;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );

    String formatted = formatter.format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Validador de CPF
class CpfValidator {
  /// Valida se o CPF é válido
  static bool isValid(String cpf) {
    // Remove formatação
    String numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se tem 11 dígitos
    if (numbers.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(numbers)) return false;

    // Calcula o primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(numbers[i]) * (10 - i);
    }
    int firstDigit = 11 - (sum % 11);
    if (firstDigit >= 10) firstDigit = 0;

    // Verifica o primeiro dígito
    if (int.parse(numbers[9]) != firstDigit) return false;

    // Calcula o segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(numbers[i]) * (11 - i);
    }
    int secondDigit = 11 - (sum % 11);
    if (secondDigit >= 10) secondDigit = 0;

    // Verifica o segundo dígito
    return int.parse(numbers[10]) == secondDigit;
  }

  /// Retorna mensagem de erro se CPF for inválido
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (!isValid(value)) {
      return 'CPF inválido';
    }
    return null;
  }
}

/// Validador de Data
class DateValidator {
  /// Valida se a data é válida e não é futura
  static bool isValid(String date) {
    try {
      // Remove a máscara
      String cleanDate = date.replaceAll(RegExp(r'[^0-9]'), '');
      
      if (cleanDate.length != 8) return false;

      int day = int.parse(cleanDate.substring(0, 2));
      int month = int.parse(cleanDate.substring(2, 4));
      int year = int.parse(cleanDate.substring(4, 8));

      // Verifica se os valores são válidos
      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;
      if (year < 1900 || year > DateTime.now().year) return false;

      // Cria a data e verifica se é válida
      DateTime parsedDate = DateTime(year, month, day);
      
      // Verifica se a data criada corresponde aos valores fornecidos
      if (parsedDate.day != day || 
          parsedDate.month != month || 
          parsedDate.year != year) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retorna mensagem de erro se data for inválida
  static String? validate(String? value, {bool allowFuture = false}) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value.length < 10) {
      return 'Data incompleta';
    }
    if (!isValid(value)) {
      return 'Data inválida';
    }
    
    // Verifica se é data futura (para datas de nascimento)
    if (!allowFuture) {
      String cleanDate = value.replaceAll(RegExp(r'[^0-9]'), '');
      int day = int.parse(cleanDate.substring(0, 2));
      int month = int.parse(cleanDate.substring(2, 4));
      int year = int.parse(cleanDate.substring(4, 8));
      DateTime parsedDate = DateTime(year, month, day);
      
      if (parsedDate.isAfter(DateTime.now())) {
        return 'Data não pode ser futura';
      }
    }
    
    return null;
  }
}

/// Validador de Renda
class RendaValidator {
  /// Retorna mensagem de erro se renda for inválida
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    
    // Remove formatação
    String numbers = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (numbers.isEmpty || numbers == '0' || numbers == '00') {
      return 'Informe um valor válido';
    }
    
    return null;
  }
}

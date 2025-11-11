import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgk/src/molecules/login_field.dart';

void main() {
  group('LoginField Widget Tests', () {
    testWidgets('Deve renderizar campo de texto com label', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginField(controller: controller, label: 'Email'),
          ),
        ),
      );

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(LoginField), findsOneWidget);
    });

    testWidgets('Deve aceitar entrada de texto', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginField(controller: controller, label: 'Nome'),
          ),
        ),
      );

      // Digitar texto
      await tester.enterText(find.byType(TextField), 'João Silva');
      await tester.pump();

      // Assert
      expect(controller.text, 'João Silva');
      expect(find.text('João Silva'), findsOneWidget);
    });

    testWidgets('Deve ocultar texto quando isPassword é true', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginField(
              controller: controller,
              label: 'Senha',
              isPassword: true,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('Não deve ocultar texto quando isPassword é false', (
      tester,
    ) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginField(
              controller: controller,
              label: 'Email',
              isPassword: false,
            ),
          ),
        ),
      );

      // Assert
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, false);
    });

    testWidgets('Deve chamar callback onChanged quando texto mudar', (
      tester,
    ) async {
      // Arrange
      final controller = TextEditingController();
      String? changedText;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginField(
              controller: controller,
              label: 'Nome',
              onChanged: (text) => changedText = text,
            ),
          ),
        ),
      );

      // Digitar texto
      await tester.enterText(find.byType(TextField), 'Teste');
      await tester.pump();

      // Assert
      expect(changedText, 'Teste');
    });

    testWidgets('Deve limpar texto quando controller for limpo', (
      tester,
    ) async {
      // Arrange
      final controller = TextEditingController(text: 'Texto inicial');

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginField(controller: controller, label: 'Campo'),
          ),
        ),
      );

      // Verificar texto inicial
      expect(find.text('Texto inicial'), findsOneWidget);

      // Limpar controller
      controller.clear();
      await tester.pump();

      // Assert
      expect(controller.text, '');
      expect(find.text('Texto inicial'), findsNothing);
    });

    testWidgets('Deve manter o foco após digitação', (tester) async {
      // Arrange
      final controller = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginField(controller: controller, label: 'Campo com foco'),
          ),
        ),
      );

      // Tocar no campo
      await tester.tap(find.byType(TextField));
      await tester.pump();

      // Digitar
      await tester.enterText(find.byType(TextField), 'Texto');
      await tester.pump();

      // Assert
      expect(controller.text, 'Texto');
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, 'Texto');
    });

    testWidgets('Deve renderizar múltiplos LoginFields independentemente', (
      tester,
    ) async {
      // Arrange
      final emailController = TextEditingController();
      final senhaController = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                LoginField(controller: emailController, label: 'Email'),
                LoginField(
                  controller: senhaController,
                  label: 'Senha',
                  isPassword: true,
                ),
              ],
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.byType(LoginField), findsNWidgets(2));

      // Verificar que são independentes
      await tester.enterText(find.byType(TextField).first, 'test@email.com');
      await tester.pump();

      expect(emailController.text, 'test@email.com');
      expect(senhaController.text, '');
    });
  });
}

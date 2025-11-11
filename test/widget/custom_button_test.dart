import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mgk/src/atoms/custom_button.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('Deve renderizar botão com texto correto', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Entrar',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('Deve executar callback ao ser pressionado', (tester) async {
      // Arrange
      bool wasPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Clique aqui',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      // Pressionar o botão
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Assert
      expect(wasPressed, true);
    });

    testWidgets('Deve renderizar com cor personalizada', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Botão Azul',
              onPressed: () {},
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);
    });

    testWidgets('Deve renderizar com texto em cor personalizada', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Botão',
              onPressed: () {},
              textColor: Colors.red,
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('Botão'));
      expect(textWidget.style?.color, Colors.red);
    });

    testWidgets('Deve renderizar com ícone quando fornecido', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Com Ícone',
              onPressed: () {},
              icon: const Icon(Icons.login),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.login), findsOneWidget);
      expect(find.text('Com Ícone'), findsOneWidget);
    });

    testWidgets('Deve ter semântica apropriada para acessibilidade', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'Acessível', onPressed: () {}),
          ),
        ),
      );

      // Assert
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.label, contains('Acessível'));
    });

    testWidgets('Deve ter tamanho de fonte personalizável', (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Grande',
              onPressed: () {},
              fontSize: 24.0,
            ),
          ),
        ),
      );

      // Assert
      final textWidget = tester.widget<Text>(find.text('Grande'));
      expect(textWidget.style?.fontSize, 24.0);
    });

    testWidgets('Deve aplicar padding personalizado', (tester) async {
      // Arrange
      const customPadding = EdgeInsets.all(40);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Padding',
              onPressed: () {},
              padding: customPadding,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Container),
        ),
      );

      expect(container.padding, customPadding);
    });

    testWidgets('Deve renderizar sem ícone quando não fornecido', (
      tester,
    ) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'Sem Ícone', onPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(find.byType(Icon), findsNothing);
      expect(find.text('Sem Ícone'), findsOneWidget);
    });
  });
}

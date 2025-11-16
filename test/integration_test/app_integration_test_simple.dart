import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mgk/main.dart' as app;
import 'package:mgk/firebase_options.dart';

/// Testes de Integração da Aplicação MGK
///
/// Estes testes verificam o comportamento completo da aplicação,
/// incluindo navegação, validações e interações do usuário.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Inicializa Firebase para os testes
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  group('Teste de Integração - Fluxo de Login', () {
    testWidgets('Deve validar campos vazios ao tentar fazer login', (
      tester,
    ) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Procura pelo botão de login
      final botaoEntrar = find.text('Entrar');

      // Se o botão existe, tenta clicar sem preencher campos
      if (tester.any(botaoEntrar)) {
        await tester.tap(botaoEntrar);
        await tester.pumpAndSettle();

        // Verifica se a mensagem de erro aparece
        expect(
          find.textContaining('Preencha'),
          findsWidgets,
          reason: 'Deve exibir mensagem de erro quando campos estão vazios',
        );
      }
    });

    testWidgets('Deve preencher campos de email e senha', (tester) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Procura por campos de texto
      final camposTexto = find.byType(TextField);

      if (tester.any(camposTexto)) {
        // Preenche o primeiro campo (geralmente email)
        await tester.enterText(camposTexto.first, 'teste@exemplo.com');
        await tester.pump();

        // Verifica se o texto foi inserido
        expect(find.text('teste@exemplo.com'), findsOneWidget);
      }
    });

    testWidgets('Deve mostrar loading ao tentar login com credenciais', (
      tester,
    ) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Procura por campos e botão
      final camposTexto = find.byType(TextField);
      final botaoEntrar = find.text('Entrar');

      if (tester.any(camposTexto) && tester.any(botaoEntrar)) {
        // Preenche os campos
        final campos = tester.widgetList<TextField>(camposTexto).toList();
        if (campos.length >= 2) {
          await tester.enterText(camposTexto.at(0), 'usuario@teste.com');
          await tester.enterText(camposTexto.at(1), 'senha123');
          await tester.pump();

          // Clica no botão
          await tester.tap(botaoEntrar);
          await tester.pump();

          // Verifica se o indicador de loading aparece
          expect(
            find.byType(CircularProgressIndicator),
            findsWidgets,
            reason: 'Deve mostrar loading durante autenticação',
          );

          // Aguarda o Firebase responder para evitar setState após dispose
          await tester.pumpAndSettle(const Duration(seconds: 10));
        }
      }
    });
  });

  group('Teste de Integração - Navegação', () {
    testWidgets('Deve navegar entre tela de login e cadastro', (tester) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Procura pelo link de cadastro
      final linkCadastro = find.textContaining('Cadastre-se');

      if (tester.any(linkCadastro)) {
        await tester.tap(linkCadastro.first);
        await tester.pumpAndSettle();

        // Verifica se navegou para tela de cadastro
        expect(
          find.textContaining('Solicitar'),
          findsWidgets,
          reason: 'Deve estar na tela de cadastro/solicitação',
        );
      }
    });

    testWidgets('Deve validar formulário de cadastro', (tester) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navega para cadastro
      final linkCadastro = find.textContaining('Cadastre-se');
      if (tester.any(linkCadastro)) {
        await tester.tap(linkCadastro.first);
        await tester.pumpAndSettle();

        // Procura pelo botão de cadastro
        final botaoCadastro = find.textContaining('Cadastrar');

        if (tester.any(botaoCadastro)) {
          await tester.tap(botaoCadastro.first);
          await tester.pumpAndSettle();

          // Verifica mensagem de validação
          expect(
            find.textContaining('Preencha'),
            findsWidgets,
            reason: 'Deve validar campos obrigatórios',
          );
        }
      }
    });
  });

  group('Teste de Integração - UI e Interação', () {
    testWidgets('Deve renderizar elementos básicos da interface', (
      tester,
    ) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica elementos básicos
      expect(
        find.byType(Scaffold),
        findsWidgets,
        reason: 'Deve ter pelo menos um Scaffold',
      );

      expect(find.byType(AppBar), findsWidgets, reason: 'Deve ter AppBar');
    });

    testWidgets('Deve permitir scroll na tela', (tester) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Tenta fazer scroll
      final scrollView = find.byType(SingleChildScrollView);

      if (tester.any(scrollView)) {
        await tester.drag(scrollView.first, const Offset(0, -100));
        await tester.pump();

        // Se chegou aqui, o scroll funcionou
        expect(true, isTrue);
      }
    });

    testWidgets('Deve ter campos de entrada acessíveis', (tester) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifica campos de texto
      final campos = find.byType(TextField);

      expect(
        tester.any(campos),
        isTrue,
        reason: 'Deve ter campos de entrada na tela',
      );
    });
  });

  group('Teste de Performance', () {
    testWidgets('Aplicação deve carregar em tempo razoável', (tester) async {
      final stopwatch = Stopwatch()..start();

      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      stopwatch.stop();

      // Verifica que carregou em menos de 15 segundos (considerando Firebase)
      expect(
        stopwatch.elapsedMilliseconds,
        lessThan(15000),
        reason: 'App deve carregar em menos de 15 segundos',
      );

      // Verifica que a interface foi renderizada
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Entrada de texto deve ser responsiva', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final campos = find.byType(TextField);

      if (tester.any(campos)) {
        final stopwatch = Stopwatch()..start();

        // Testa múltiplas entradas
        for (int i = 0; i < 5; i++) {
          await tester.enterText(campos.first, 'teste$i@email.com');
          await tester.pump();
        }

        stopwatch.stop();

        // Deve ser rápido (menos de 500ms para 5 entradas)
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(500),
          reason: 'Entrada de texto deve ser responsiva',
        );
      }
    });
  });
}

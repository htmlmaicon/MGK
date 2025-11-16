import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mgk/main.dart' as app;
import 'package:mgk/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('MGK App - Teste de Integração Completo', () {
    setUpAll(() async {
      // Inicializa Firebase para os testes de integração
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    });

    testWidgets('Fluxo completo: Tela de Login -> Validação de campos vazios', (
      tester,
    ) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Verifica que a tela de login tem os elementos principais
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.text('Faça login para acessar o sistema'), findsOneWidget);

      // Tenta fazer login sem preencher os campos
      final botaoEntrar = find.text('Entrar');
      expect(botaoEntrar, findsOneWidget);

      await tester.tap(botaoEntrar);
      await tester.pumpAndSettle();

      // Verifica se a mensagem de erro aparece
      expect(find.text('Preencha todos os campos.'), findsOneWidget);
    });

    testWidgets('Fluxo: Preencher campos de login e validar entrada', (
      tester,
    ) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Encontra os campos de texto
      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == 'Email',
      );
      final senhaField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == 'Senha',
      );

      expect(emailField, findsOneWidget);
      expect(senhaField, findsOneWidget);

      // Preenche os campos
      await tester.enterText(emailField, 'teste@example.com');
      await tester.enterText(senhaField, 'senha123');
      await tester.pumpAndSettle();

      // Verifica que os textos foram inseridos
      expect(find.text('teste@example.com'), findsOneWidget);
      // Senha não aparece por estar obscurecida
    });

    testWidgets('Fluxo: Navegar para tela de cadastro', (tester) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Verifica que está na tela de login
      expect(find.text('Não tem conta? Cadastre-se'), findsOneWidget);

      // Toca no botão de cadastro
      await tester.tap(find.text('Não tem conta? Cadastre-se'));
      await tester.pumpAndSettle();

      // Verifica que navegou para a tela de cadastro
      expect(find.text('Solicitar Acesso'), findsOneWidget);
      expect(find.text('AGUARDE APROVAÇÃO'), findsOneWidget);
      expect(find.text('Cadastrar'), findsOneWidget);
    });

    testWidgets('Fluxo: Validar formulário de cadastro', (tester) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Navega para cadastro
      await tester.tap(find.text('Não tem conta? Cadastre-se'));
      await tester.pumpAndSettle();

      // Tenta criar conta sem preencher campos
      final botaoCriarConta = find.text('Cadastrar');
      expect(botaoCriarConta, findsOneWidget);

      await tester.tap(botaoCriarConta);
      await tester.pumpAndSettle();

      // Verifica mensagem de erro
      expect(find.text('Preencha todos os campos.'), findsOneWidget);
    });

    testWidgets('Fluxo: Interação com elementos da UI', (tester) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Verifica elementos principais da tela de login
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.text('Faça login para acessar o sistema'), findsOneWidget);
      expect(find.text('Sistema de Gerenciamento de Clientes'), findsOneWidget);

      // Verifica que o botão CustomButton existe
      expect(find.byType(app.MyApp), findsOneWidget);

      // Testa scroll da tela
      await tester.drag(
        find.byType(SingleChildScrollView).first,
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
    });

    testWidgets('Fluxo: Login com credenciais inválidas', (tester) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Preenche com credenciais inválidas
      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == 'Email',
      );
      final senhaField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == 'Senha',
      );

      await tester.enterText(emailField, 'usuario@invalido.com');
      await tester.enterText(senhaField, 'senhaerrada');
      await tester.pumpAndSettle();

      // Tenta fazer login
      await tester.tap(find.text('Entrar'));
      await tester.pump(); // Inicia a animação de loading

      // Verifica que o loading aparece
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Aguarda a resposta do Firebase (com timeout)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verifica que uma mensagem de erro foi exibida
      // (Pode ser "Usuário não encontrado" ou outra mensagem de erro)
      expect(
        find.byWidgetPredicate(
          (widget) => widget is SnackBar || widget is SnackBarAction,
        ),
        findsWidgets,
      );
    });

    testWidgets('Fluxo: Verificar acessibilidade dos elementos', (
      tester,
    ) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Verifica semântica do botão de login
      final SemanticsHandle handle = tester.ensureSemantics();

      expect(find.text('Entrar'), findsOneWidget);

      // Verifica que os campos têm labels apropriados
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);

      handle.dispose();
    });
  });

  group('MGK App - Teste de Navegação', () {
    testWidgets('Fluxo: Navegação entre telas sem login', (tester) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Verifica rota inicial
      expect(find.text('Faça login para acessar o sistema'), findsOneWidget);

      // Navega para cadastro
      await tester.tap(find.text('Não tem conta? Cadastre-se'));
      await tester.pumpAndSettle();

      expect(find.text('Solicitar Acesso'), findsOneWidget);

      // Volta para login (se houver botão de voltar)
      final backButton = find.byTooltip('Back');
      if (tester.any(backButton)) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();
        expect(find.text('Faça login para acessar o sistema'), findsOneWidget);
      }
    });

    testWidgets('Fluxo: Verificar transições de tela', (tester) async {
      // Inicia o app
      app.main();
      await tester.pumpAndSettle();

      // Navega para cadastro e verifica transição
      await tester.tap(find.text('Não tem conta? Cadastre-se'));

      // Pump durante a animação de transição
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      // Verifica que chegou na nova tela
      expect(find.text('Solicitar Acesso'), findsOneWidget);
      expect(find.text('AGUARDE APROVAÇÃO'), findsOneWidget);
    });
  });

  group('MGK App - Teste de Performance', () {
    testWidgets('Fluxo: Renderização inicial da tela', (tester) async {
      final Stopwatch stopwatch = Stopwatch()..start();

      app.main();
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Verifica que a tela carregou em tempo aceitável (< 3 segundos)
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));

      // Verifica que todos os elementos principais foram renderizados
      expect(find.text('Faça login para acessar o sistema'), findsOneWidget);
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('Fluxo: Performance de entrada de texto', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == 'Email',
      );

      final Stopwatch stopwatch = Stopwatch()..start();

      // Testa entrada rápida de texto
      for (int i = 0; i < 10; i++) {
        await tester.enterText(emailField, 'teste$i@example.com');
        await tester.pump();
      }

      stopwatch.stop();

      // Verifica que a entrada de texto é responsiva (< 1 segundo para 10 entradas)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });
}

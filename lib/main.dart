import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/pages/home_page.dart';
import 'src/pages/cadastro_cliente_page.dart';
import 'src/pages/posts_page.dart';
import 'src/pages/login_page.dart';
import 'src/pages/contratos_ativos_page.dart';
import 'src/pages/solicitacoes_cadastro_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'src/core/dependency_injection.dart';
import 'src/core/services/notification_service.dart';

/// Função principal da aplicação
/// Inicializa Firebase, Notificações e configura Dependency Injection com Provider
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Inicializa notificações apenas em mobile (não funciona na web)
  if (!kIsWeb) {
    // Configura handler de mensagens em background
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // Inicializa serviço de notificações
    try {
      await NotificationService().initialize();
    } catch (e) {
      print('Erro ao inicializar notificações: $e');
    }
  }
  
  runApp(const MyApp());
}

/// Widget raiz da aplicação
/// Configura MultiProvider para injeção de dependências em toda a árvore de widgets
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Injeta DataSources e Repositories
        ...DependencyInjection.providers,
        // Injeta ViewModels com ChangeNotifier
        ...DependencyInjection.changeNotifierProviders,
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "MGK - Cadastro",
        theme: ThemeData(
          primarySwatch: Colors.green,
          // Tema personalizado
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green[900],
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/cadastro': (context) => CadastroClientePage(),
          '/posts': (context) => const PostsPage(),
          '/contratos': (context) => const ContratosAtivosPage(),
          '/solicitacoes': (context) => const SolicitacoesCadastroPage(),
        },
      ),
    );
  }
}

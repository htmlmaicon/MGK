
import 'package:flutter/material.dart';
import 'src/pages/home_page.dart';
import 'src/pages/cadastro_cliente_page.dart';
import 'src/pages/posts_page.dart';
import 'src/pages/login_page.dart';
import 'src/pages/contratos_ativos_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // será criado automaticamente

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MGK - Cadastro",
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/cadastro': (context) => CadastroClientePage(),
        '/posts': (context) => const PostsPage(),
        '/contratos': (context) => const ContratosAtivosPage(),
      },
    );
  }
}
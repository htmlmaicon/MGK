import 'package:flutter/material.dart';
import 'ver_clientes_page.dart';
import '../utils/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static final AuthService _authService = AuthService();

  void _logout(BuildContext context) {
    // Mostrar diálogo de confirmação
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair do Sistema'),
          content: const Text('Tem certeza que deseja sair?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar diálogo
                Navigator.pushReplacementNamed(
                  context,
                  '/login',
                ); // Voltar para login
              },
              child: const Text('Sair', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'MGK - Cadastro',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
            tooltip: 'Sair do sistema',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Icon(Icons.account_circle, size: 100, color: Colors.green[800]),
              const SizedBox(height: 30),
              Text(
                'Bem-vindo ao Sistema de Cadastro',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Mostrar tipo de usuário
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _authService.isAdmin()
                      ? Colors.amber[100]
                      : Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _authService.isAdmin()
                        ? Colors.amber[700]!
                        : Colors.blue[300]!,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _authService.isAdmin()
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      color: _authService.isAdmin()
                          ? Colors.amber[900]
                          : Colors.blue[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _authService.isAdmin() ? 'ADMINISTRADOR' : 'USUÁRIO',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _authService.isAdmin()
                            ? Colors.amber[900]
                            : Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _authService.getCurrentUserEmail() ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _authService.isAdmin()
                    ? 'Você tem acesso total ao sistema'
                    : 'Você pode consultar e ativar contratos',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Botão Cadastrar Cliente (apenas para admin)
              if (_authService.canCreateClient())
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cadastro');
                  },
                  icon: const Icon(Icons.person_add, color: Colors.white),
                  label: const Text(
                    'Cadastrar Cliente',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              if (_authService.canCreateClient()) const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerClientesPage()),
                  );
                },
                icon: const Icon(Icons.list, color: Colors.white),
                label: const Text(
                  'Ver Clientes',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/contratos');
                },
                icon: const Icon(Icons.assignment, color: Colors.white),
                label: const Text(
                  'Contratos Ativos',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              // Botão Solicitações de Cadastro (apenas para admin)
              if (_authService.isAdmin()) const SizedBox(height: 20),
              if (_authService.isAdmin())
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/solicitacoes');
                  },
                  icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
                  label: const Text(
                    'Solicitações de Cadastro',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              const SizedBox(height: 50),
              Text(
                'Sistema de Gerenciamento de Clientes',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

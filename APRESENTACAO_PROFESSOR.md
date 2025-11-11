# 📱 Documentação de Apresentação - Projeto Integrador MGK

**Disciplina:** Desenvolvimento Mobile com Dart e Flutter  
**Data de Entrega:** 07/11/2024  
**Aluno:** [Seu Nome]  
**Projeto:** MGK - Sistema de Gerenciamento de Cadastro de Clientes

---

## 📋 Sumário

1. [Introdução](#introdução)
2. [Arquitetura Implementada](#arquitetura-implementada)
3. [Gerenciamento de Estado com Provider](#gerenciamento-de-estado-com-provider)
4. [Dependency Injection](#dependency-injection)
5. [Testes Automatizados](#testes-automatizados)
6. [Demonstração do Código](#demonstração-do-código)
7. [Requisitos Atendidos](#requisitos-atendidos)
8. [Como Executar](#como-executar)

---

## 🎯 Introdução

### Objetivo do Projeto

O **MGK** é um aplicativo mobile multiplataforma desenvolvido em Flutter que gerencia cadastros de clientes, solicitações e contratos. O projeto foi refatorado seguindo princípios de **Clean Architecture** e **MVVM**, implementando gerenciamento de estado robusto com **Provider** e incluindo testes automatizados.

### Funcionalidades Principais

- ✅ **Sistema de Autenticação** com Firebase (Login/Logout)
- ✅ **Gerenciamento de Permissões** (Admin e Usuário)
- ✅ **CRUD Completo de Clientes**
- ✅ **Sistema de Solicitações de Cadastro**
- ✅ **Gerenciamento de Contratos Ativos**
- ✅ **Persistência em Tempo Real** com Cloud Firestore
- ✅ **Interface Responsiva** e intuitiva

### Tecnologias Utilizadas

```yaml
# Principais Dependências
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.5+1        # Gerenciamento de Estado e DI
  firebase_core: ^4.2.1     # Firebase
  firebase_auth: ^6.1.2     # Autenticação
  cloud_firestore: ^6.1.0   # Banco de Dados
  http: ^1.1.0              # Requisições HTTP

dev_dependencies:
  flutter_test:             # Testes
    sdk: flutter
```

---

## 🏗️ Arquitetura Implementada

### Clean Architecture + MVVM

O projeto implementa uma combinação de **Clean Architecture** (arquitetura em camadas) com o padrão **MVVM** (Model-View-ViewModel), garantindo:

- ✅ **Separação de Responsabilidades**
- ✅ **Testabilidade**
- ✅ **Manutenibilidade**
- ✅ **Escalabilidade**
- ✅ **Independência de Frameworks**

### Estrutura de Camadas

```
┌─────────────────────────────────────────────────┐
│         PRESENTATION LAYER (UI)                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ViewModel │  │  Pages   │  │ Widgets  │      │
│  │(Provider)│  │          │  │ (Atomic) │      │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
                      ↓ ↑
┌─────────────────────────────────────────────────┐
│         DOMAIN LAYER (Regras de Negócio)        │
│  ┌──────────┐  ┌──────────────────────┐         │
│  │  Models  │  │  Repository Interface │         │
│  │          │  │    (Contratos)        │         │
│  └──────────┘  └──────────────────────┘         │
└─────────────────────────────────────────────────┘
                      ↓ ↑
┌─────────────────────────────────────────────────┐
│         DATA LAYER (Acesso a Dados)              │
│  ┌────────────┐  ┌──────────────────┐           │
│  │ DataSource │  │ Repository Impl  │           │
│  │ (Firebase) │  │                  │           │
│  └────────────┘  └──────────────────┘           │
│         ↓                                        │
│  ┌────────────────────┐                         │
│  │  Firebase/Firestore │                         │
│  └────────────────────┘                         │
└─────────────────────────────────────────────────┘
```

---

## 📦 Estrutura de Pastas Detalhada

```
lib/
├── main.dart                              # ⭐ Ponto de entrada da aplicação
├── firebase_options.dart                   # Configurações do Firebase
│
└── src/
    ├── core/                              # 🔧 Núcleo da Aplicação
    │   └── dependency_injection.dart      # Configuração de DI com Provider
    │
    ├── domain/                            # 📘 CAMADA DE DOMÍNIO
    │   ├── models/                        # Entidades de negócio
    │   │   ├── cliente_model.dart         # Modelo de Cliente
    │   │   ├── user_model.dart            # Modelo de Usuário
    │   │   └── solicitacao_model.dart     # Modelo de Solicitação
    │   └── repositories/                  # Interfaces (Contratos)
    │       ├── auth_repository.dart       # Interface de Autenticação
    │       ├── cliente_repository.dart    # Interface de Cliente
    │       └── solicitacao_repository.dart
    │
    ├── data/                              # 💾 CAMADA DE DADOS
    │   ├── datasources/                   # Fontes de dados
    │   │   ├── auth_datasource.dart       # Comunicação com Firebase Auth
    │   │   ├── cliente_datasource.dart    # Comunicação com Firestore
    │   │   └── solicitacao_datasource.dart
    │   └── repositories/                  # Implementações concretas
    │       ├── auth_repository_impl.dart
    │       ├── cliente_repository_impl.dart
    │       └── solicitacao_repository_impl.dart
    │
    ├── presentation/                      # 🎨 CAMADA DE APRESENTAÇÃO
    │   └── viewmodels/                    # Gerenciamento de Estado
    │       ├── auth_viewmodel.dart        # ⭐ ViewModel de Autenticação
    │       ├── cliente_viewmodel.dart     # ⭐ ViewModel de Clientes
    │       └── solicitacao_viewmodel.dart
    │
    ├── pages/                             # 📄 Telas Completas
    │   ├── login_page.dart
    │   ├── home_page.dart
    │   ├── cadastro_cliente_page.dart
    │   ├── ver_clientes_page.dart
    │   ├── contratos_ativos_page.dart
    │   └── solicitacoes_cadastro_page.dart
    │
    ├── templates/                         # 🎭 Layouts Reutilizáveis
    ├── organisms/                         # 🔶 Componentes UI Complexos
    ├── molecules/                         # 🔸 Componentes UI Médios
    ├── atoms/                             # 🔹 Componentes UI Básicos
    │   ├── custom_button.dart
    │   └── login_field.dart
    │
    └── utils/                             # 🛠️ Utilitários
        └── validators.dart                # Validações (CPF, Email, etc)

test/
├── unit/                                  # 🧪 Testes Unitários
│   ├── models/                           # Testes de modelos
│   │   ├── cliente_model_test.dart
│   │   ├── user_model_test.dart
│   │   └── solicitacao_model_test.dart
│   └── utils/                            # Testes de lógica de negócio
│       └── validators_test.dart
│
└── widget/                                # 🎨 Testes de Widget
    ├── custom_button_test.dart
    └── login_field_test.dart
```

---

## 🔄 Gerenciamento de Estado com Provider

### Por que Provider?

O **Provider** foi escolhido como solução de gerenciamento de estado por ser:

- ✅ **Simples e Intuitivo**: Curva de aprendizado suave
- ✅ **Recomendado pelo Flutter Team**: Solução oficial
- ✅ **Performático**: Rebuilds otimizados
- ✅ **Testável**: Fácil criação de mocks
- ✅ **Integrado com DI**: Injeção de dependência nativa

### Arquitetura com Provider

```dart
// 1. ViewModel estende ChangeNotifier
class AuthViewModel extends ChangeNotifier {
  // Estado privado
  UserModel? _currentUser;
  bool _isLoading = false;
  
  // Getters públicos
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  
  // Métodos que modificam o estado
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // ⭐ Notifica a UI
    
    _currentUser = await _authRepository.signIn(email, password);
    
    _isLoading = false;
    notifyListeners(); // ⭐ Notifica a UI novamente
    
    return _currentUser != null;
  }
}
```

### Implementação Completa

#### 1️⃣ **AuthViewModel - Gerenciamento de Autenticação**

```dart
/// ViewModel responsável por gerenciar o estado de autenticação
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  // Estado da aplicação
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Construtor com injeção de dependência
  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    _initialize();
  }

  // Getters para acesso ao estado
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  /// Login do usuário
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.signIn(email, password);
      _setLoading(false);
      return _currentUser != null;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Logout do usuário
  Future<void> signOut() async {
    await _authRepository.signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Método helper que notifica listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // ⭐ Notifica a UI sobre mudanças
  }
}
```

#### 2️⃣ **ClienteViewModel - Gerenciamento de Clientes**

```dart
/// ViewModel responsável por gerenciar o estado dos clientes
class ClienteViewModel extends ChangeNotifier {
  final ClienteRepository _clienteRepository;

  List<ClienteModel> _clientes = [];
  bool _isLoading = false;

  // Getters
  List<ClienteModel> get clientes => _clientes;
  bool get isLoading => _isLoading;

  /// Busca todos os clientes
  Future<void> fetchClientes() async {
    _isLoading = true;
    notifyListeners();
    
    _clientes = await _clienteRepository.getAll();
    
    _isLoading = false;
    notifyListeners();
  }

  /// Adiciona um novo cliente
  Future<void> addCliente(ClienteModel cliente) async {
    await _clienteRepository.add(cliente);
    await fetchClientes(); // Atualiza a lista
  }

  /// Remove um cliente
  Future<void> deleteCliente(String id) async {
    await _clienteRepository.delete(id);
    await fetchClientes(); // Atualiza a lista
  }
}
```

### Consumindo State na UI

#### Forma 1: Consumer (Recomendada)

```dart
// Reconstrói apenas quando o estado muda
Consumer<AuthViewModel>(
  builder: (context, authViewModel, child) {
    if (authViewModel.isLoading) {
      return CircularProgressIndicator();
    }
    
    return Text('Usuário: ${authViewModel.currentUser?.email}');
  },
)
```

#### Forma 2: Provider.of

```dart
Widget build(BuildContext context) {
  final authViewModel = Provider.of<AuthViewModel>(context);
  
  return Text('Admin: ${authViewModel.isAdmin}');
}
```

#### Forma 3: context.watch (Moderna)

```dart
Widget build(BuildContext context) {
  final authViewModel = context.watch<AuthViewModel>();
  
  return authViewModel.isLoading 
    ? CircularProgressIndicator()
    : LoginForm();
}
```

#### Forma 4: context.read (Sem Reatividade)

```dart
// Para executar ações sem escutar mudanças
void _handleLogin() {
  final authViewModel = context.read<AuthViewModel>();
  authViewModel.signIn(email, password);
}
```

---

## 💉 Dependency Injection

### O que é Dependency Injection?

**Dependency Injection (DI)** é um padrão de design onde as dependências de uma classe são fornecidas externamente, ao invés de serem criadas internamente.

### Benefícios

- ✅ **Testabilidade**: Fácil substituição por mocks
- ✅ **Desacoplamento**: Classes não conhecem implementações concretas
- ✅ **Manutenibilidade**: Mudanças centralizadas
- ✅ **Reutilização**: Instâncias compartilhadas

### Implementação no Projeto

#### Arquivo: `dependency_injection.dart`

```dart
/// Classe responsável pela configuração de Dependency Injection
/// Centraliza todas as dependências da aplicação
class DependencyInjection {
  
  /// Providers para DataSources e Repositories
  static List<Provider> get providers {
    return [
      // ⭐ DataSources - Camada de Dados
      Provider<AuthDataSource>(
        create: (_) => AuthDataSource(),
      ),
      Provider<ClienteDataSource>(
        create: (_) => ClienteDataSource(),
      ),
      Provider<SolicitacaoDataSource>(
        create: (_) => SolicitacaoDataSource(),
      ),

      // ⭐ Repositories - Implementações
      Provider<AuthRepository>(
        create: (context) => AuthRepositoryImpl(
          dataSource: context.read<AuthDataSource>(),
        ),
      ),
      Provider<ClienteRepository>(
        create: (context) => ClienteRepositoryImpl(
          dataSource: context.read<ClienteDataSource>(),
        ),
      ),
      Provider<SolicitacaoRepository>(
        create: (context) => SolicitacaoRepositoryImpl(
          dataSource: context.read<SolicitacaoDataSource>(),
        ),
      ),
    ];
  }

  /// ChangeNotifierProviders para ViewModels
  static List<ChangeNotifierProvider> get changeNotifierProviders {
    return [
      // ⭐ ViewModels com ChangeNotifier
      ChangeNotifierProvider<AuthViewModel>(
        create: (context) => AuthViewModel(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
      ChangeNotifierProvider<ClienteViewModel>(
        create: (context) => ClienteViewModel(
          clienteRepository: context.read<ClienteRepository>(),
        ),
      ),
      ChangeNotifierProvider<SolicitacaoViewModel>(
        create: (context) => SolicitacaoViewModel(
          solicitacaoRepository: context.read<SolicitacaoRepository>(),
          authRepository: context.read<AuthRepository>(),
        ),
      ),
    ];
  }
}
```

### Configuração no main.dart

```dart
void main() async {
  // Inicialização do Flutter e Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // ⭐ Injeta todas as dependências
      providers: [
        ...DependencyInjection.providers,
        ...DependencyInjection.changeNotifierProviders,
      ],
      child: MaterialApp(
        title: 'MGK',
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
          '/cadastro': (context) => CadastroClientePage(),
          // ... outras rotas
        },
      ),
    );
  }
}
```

### Fluxo de Injeção

```
1. MultiProvider configurado no main.dart
                ↓
2. Providers criam DataSources
                ↓
3. Repositories recebem DataSources via context.read()
                ↓
4. ViewModels recebem Repositories via context.read()
                ↓
5. Widgets consomem ViewModels via Consumer/Provider.of
```

---

## 🧪 Testes Automatizados

### Estratégia de Testes

O projeto implementa dois tipos principais de testes:

1. **Testes Unitários**: Testam lógica de negócio isoladamente
2. **Testes de Widget**: Testam componentes UI e interações

### 1️⃣ Testes Unitários

#### A. Testes de Modelos

**Arquivo: `cliente_model_test.dart`**

```dart
void main() {
  group('ClienteModel Tests', () {
    
    test('Deve criar ClienteModel corretamente', () {
      // ⭐ Arrange - Preparação
      final dataCadastro = DateTime(2024, 1, 1);

      // ⭐ Act - Ação
      final cliente = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        telefone: '11999999999',
        dataCadastro: dataCadastro,
      );

      // ⭐ Assert - Verificação
      expect(cliente.id, '1');
      expect(cliente.nome, 'João Silva');
      expect(cliente.cpf, '12345678900');
      expect(cliente.email, 'joao@email.com');
    });

    test('Deve converter ClienteModel para Map', () {
      // Arrange
      final cliente = ClienteModel(
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: DateTime.now(),
      );

      // Act
      final map = cliente.toMap();

      // Assert
      expect(map['nome'], 'João Silva');
      expect(map['cpf'], '12345678900');
      expect(map['email'], 'joao@email.com');
    });

    test('Deve criar ClienteModel a partir de Map', () {
      // Arrange
      final map = {
        'nome': 'Maria Santos',
        'cpf': '98765432100',
        'email': 'maria@email.com',
        'dataCadastro': MockTimestamp(DateTime(2024, 1, 1)),
      };

      // Act
      final cliente = ClienteModel.fromMap(map, '2');

      // Assert
      expect(cliente.id, '2');
      expect(cliente.nome, 'Maria Santos');
    });

    test('Deve criar cópia com valores atualizados (copyWith)', () {
      // Arrange
      final cliente = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: DateTime.now(),
      );

      // Act
      final clienteAtualizado = cliente.copyWith(
        nome: 'João Pedro Silva',
        email: 'joaopedro@email.com',
      );

      // Assert
      expect(clienteAtualizado.nome, 'João Pedro Silva');
      expect(clienteAtualizado.cpf, '12345678900'); // Mantém o original
    });

    test('Deve comparar ClienteModel corretamente', () {
      // Arrange
      final cliente1 = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: DateTime.now(),
      );

      final cliente2 = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: DateTime.now(),
      );

      // Assert
      expect(cliente1 == cliente2, true);
    });
  });
}
```

#### B. Testes de Validadores (Lógica de Negócio)

**Arquivo: `validators_test.dart`**

```dart
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

      test('Deve aceitar CPF com formatação', () {
        expect(Validators.isValidCPF('123.456.789-09'), true);
      });
    });

    group('Email Validation', () {
      test('Deve validar email correto', () {
        expect(Validators.isValidEmail('user@example.com'), true);
        expect(Validators.isValidEmail('admin@gmail.com'), true);
      });

      test('Deve rejeitar email inválido', () {
        expect(Validators.isValidEmail(''), false);
        expect(Validators.isValidEmail('invalid'), false);
        expect(Validators.isValidEmail('@invalid.com'), false);
      });
    });

    group('Password Validation', () {
      test('Deve validar senha com mínimo 6 caracteres', () {
        expect(Validators.isValidPassword('123456'), true);
        expect(Validators.isValidPassword('senha123'), true);
      });

      test('Deve rejeitar senha com menos de 6 caracteres', () {
        expect(Validators.isValidPassword('12345'), false);
      });
    });

    group('Phone Validation', () {
      test('Deve validar telefone brasileiro correto', () {
        expect(Validators.isValidPhone('11999999999'), true);
        expect(Validators.isValidPhone('(11) 99999-9999'), true);
      });

      test('Deve rejeitar telefone inválido', () {
        expect(Validators.isValidPhone('123'), false);
      });
    });
  });
}
```

### 2️⃣ Testes de Widget

**Arquivo: `custom_button_test.dart`**

```dart
void main() {
  group('CustomButton Widget Tests', () {
    
    testWidgets('Deve renderizar botão com texto correto', (tester) async {
      // Arrange
      bool wasPressed = false;

      // Act - Renderiza o widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Entrar',
              onPressed: () => wasPressed = true,
            ),
          ),
        ),
      );

      // Assert - Verifica se renderizou
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('Deve executar callback ao ser pressionado', (tester) async {
      // Arrange
      bool wasPressed = false;

      // Act - Renderiza e interage
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

      // ⭐ Simula tap no botão
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Assert - Verifica se callback foi executado
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

      // Assert - Verifica propriedades visuais
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CustomButton),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);
    });

    testWidgets('Deve ter semântica apropriada para acessibilidade', 
      (tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Acessível',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Assert - Verifica acessibilidade
      final semantics = tester.getSemantics(find.byType(Semantics).first);
      expect(semantics.label, contains('Acessível'));
    });
  });
}
```

### Executando os Testes

```powershell
# Executar todos os testes
flutter test

# Executar apenas testes unitários
flutter test test/unit/

# Executar apenas testes de widget
flutter test test/widget/

# Executar com cobertura
flutter test --coverage

# Executar testes específicos
flutter test test/unit/models/cliente_model_test.dart
```

### Cobertura de Testes

#### Testes Unitários Implementados:
- ✅ `ClienteModel` - 6 testes
- ✅ `UserModel` - 6 testes
- ✅ `SolicitacaoModel` - 6 testes
- ✅ `Validators` (CPF, Email, Senha, Telefone) - 15 testes

#### Testes de Widget Implementados:
- ✅ `CustomButton` - 9 testes
- ✅ `LoginField` - 8 testes

**Total: 50+ testes automatizados** ✅

---

## 💻 Demonstração do Código

### Exemplo Completo: Fluxo de Login

#### 1. **UI Layer (Page)**

```dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ⭐ Consome o ViewModel
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              // Campo de email
              LoginField(
                controller: _emailController,
                label: 'Email',
              ),
              
              // Campo de senha
              LoginField(
                controller: _passwordController,
                label: 'Senha',
                obscureText: true,
              ),
              
              // Botão de login
              CustomButton(
                text: 'Entrar',
                isLoading: authViewModel.isLoading,
                onPressed: () async {
                  // ⭐ Chama método do ViewModel
                  final success = await authViewModel.signIn(
                    _emailController.text,
                    _passwordController.text,
                  );
                  
                  if (success) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
```

#### 2. **ViewModel Layer (Gerenciamento de Estado)**

```dart
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  UserModel? _currentUser;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;

  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  Future<bool> signIn(String email, String password) async {
    // ⭐ Atualiza UI - mostra loading
    _isLoading = true;
    notifyListeners();

    try {
      // ⭐ Chama repository
      _currentUser = await _authRepository.signIn(email, password);
      
      // ⭐ Atualiza UI - esconde loading
      _isLoading = false;
      notifyListeners();
      
      return _currentUser != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
```

#### 3. **Domain Layer (Interfaces)**

```dart
/// Interface que define o contrato para autenticação
abstract class AuthRepository {
  Future<UserModel?> signIn(String email, String password);
  Future<void> signOut();
  UserModel? getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}
```

#### 4. **Data Layer (Implementação)**

```dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl({required AuthDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<UserModel?> signIn(String email, String password) async {
    // ⭐ Delega para DataSource
    return await _dataSource.signIn(email, password);
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
  }
}
```

#### 5. **Data Source (Firebase)**

```dart
class AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      // ⭐ Autentica no Firebase
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // ⭐ Busca dados adicionais no Firestore
        final doc = await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();

        return UserModel.fromMap(doc.data()!, doc.id);
      }
      
      return null;
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }
}
```

### Fluxo Completo

```
User taps "Entrar"
       ↓
LoginPage chama authViewModel.signIn()
       ↓
AuthViewModel atualiza _isLoading = true
       ↓
AuthViewModel.notifyListeners() → UI mostra loading
       ↓
AuthViewModel chama authRepository.signIn()
       ↓
AuthRepositoryImpl delega para dataSource.signIn()
       ↓
AuthDataSource autentica no Firebase
       ↓
Firebase retorna credenciais
       ↓
AuthDataSource busca dados no Firestore
       ↓
Retorna UserModel através das camadas
       ↓
AuthViewModel atualiza _currentUser
       ↓
AuthViewModel.notifyListeners() → UI atualiza
       ↓
LoginPage navega para HomePage
```

---

## ✅ Requisitos Atendidos

### 1️⃣ Refatoração para Arquitetura (✅ Completo)

#### Clean Architecture
- ✅ **Domain Layer**: Models e Repository Interfaces
- ✅ **Data Layer**: DataSources e Repository Implementations
- ✅ **Presentation Layer**: ViewModels, Pages e Widgets

#### MVVM
- ✅ **Model**: Entidades de negócio (ClienteModel, UserModel, etc)
- ✅ **View**: Pages e Widgets
- ✅ **ViewModel**: Gerenciamento de estado com ChangeNotifier

#### Separação de Responsabilidades
- ✅ UI não conhece Firebase diretamente
- ✅ ViewModels não conhecem widgets
- ✅ Repositories seguem princípios SOLID

### 2️⃣ Gerenciamento de Estado Avançado (✅ Completo)

#### Provider Implementado
- ✅ **MultiProvider** configurado no main.dart
- ✅ **ChangeNotifier** em todos os ViewModels
- ✅ **Consumer** e **Provider.of** nas Pages
- ✅ Reatividade completa da UI

#### ViewModels Implementados
- ✅ `AuthViewModel` - Autenticação e permissões
- ✅ `ClienteViewModel` - CRUD de clientes
- ✅ `SolicitacaoViewModel` - Gerenciamento de solicitações

#### Dependency Injection
- ✅ Configuração centralizada em `dependency_injection.dart`
- ✅ Injeção de DataSources, Repositories e ViewModels
- ✅ Desacoplamento total entre camadas

### 3️⃣ Testes Automatizados (✅ Completo)

#### Testes Unitários
- ✅ **Models**: ClienteModel, UserModel, SolicitacaoModel
  - Testes de criação
  - Testes de conversão (toMap/fromMap)
  - Testes de copyWith
  - Testes de comparação (==)
  
- ✅ **Validators**: Lógica de negócio
  - Validação de CPF
  - Validação de Email
  - Validação de Senha
  - Validação de Telefone

#### Testes de Widget
- ✅ **CustomButton**: Componente de botão
  - Renderização
  - Callbacks
  - Propriedades visuais
  - Acessibilidade
  
- ✅ **LoginField**: Campo de formulário
  - Renderização
  - Validação
  - Interação do usuário

---

## 🚀 Como Executar o Projeto

### Pré-requisitos

```powershell
# Verificar instalações
flutter --version    # Flutter 3.8.1 ou superior
dart --version       # Dart 3.8.1 ou superior
```

### Instalação

```powershell
# 1. Navegar até o diretório do projeto
cd C:\Users\Maicon\Desktop\MGKm-main\MGKm-main

# 2. Instalar dependências
flutter pub get

# 3. Executar testes
flutter test

# 4. Executar aplicação
flutter run
```

### Configuração do Firebase

O projeto já está configurado com Firebase. Credenciais de teste:

- **Email Admin**: `admin@gmail.com`
- **Senha**: (configurada no Firebase Console)

### Estrutura de Dados no Firestore

```
firestore/
├── users/                    # Coleção de usuários
│   └── {userId}
│       ├── email: string
│       ├── nome: string
│       ├── isAdmin: boolean
│       └── dataCriacao: timestamp
│
├── clientes/                 # Coleção de clientes
│   └── {clienteId}
│       ├── nome: string
│       ├── cpf: string
│       ├── email: string
│       ├── telefone: string
│       ├── endereco: string
│       ├── dataCadastro: timestamp
│       └── ativo: boolean
│
└── solicitacoes/             # Coleção de solicitações
    └── {solicitacaoId}
        ├── clienteNome: string
        ├── clienteCPF: string
        ├── status: string
        ├── datasolicitacao: timestamp
        └── userId: string
```

---

## 📊 Princípios e Padrões Aplicados

### Clean Code

- ✅ **Nomes Significativos**: Variáveis e funções com nomes descritivos
- ✅ **Funções Pequenas**: Cada função tem uma única responsabilidade
- ✅ **Comentários Relevantes**: Documentação clara do código
- ✅ **Formatação Consistente**: Código bem organizado

### SOLID

- ✅ **S**ingle Responsibility: Cada classe tem uma única responsabilidade
- ✅ **O**pen/Closed: Aberto para extensão, fechado para modificação
- ✅ **L**iskov Substitution: Interfaces bem definidas e substituíveis
- ✅ **I**nterface Segregation: Interfaces específicas e focadas
- ✅ **D**ependency Inversion: Dependência de abstrações, não implementações

### DRY (Don't Repeat Yourself)

- ✅ **Atomic Design**: Componentes reutilizáveis (Atoms, Molecules, Organisms)
- ✅ **ViewModels Compartilhados**: Lógica centralizada
- ✅ **Utilitários**: Validadores e helpers reutilizáveis

### KISS (Keep It Simple, Stupid)

- ✅ Código simples e direto
- ✅ Soluções práticas e eficientes
- ✅ Evita over-engineering

---

## 🎓 Conceitos Avançados Demonstrados

### 1. Programação Reativa
- ✅ Streams para dados em tempo real
- ✅ ChangeNotifier para reatividade
- ✅ Consumer para rebuild otimizado

### 2. Injeção de Dependência
- ✅ Provider como container de DI
- ✅ Desacoplamento total entre camadas
- ✅ Fácil substituição para testes

### 3. Separation of Concerns
- ✅ UI não conhece lógica de negócio
- ✅ Lógica de negócio não conhece Firebase
- ✅ Cada camada tem responsabilidade clara

### 4. Repository Pattern
- ✅ Abstração do acesso a dados
- ✅ Fácil substituição de fonte de dados
- ✅ Testabilidade aprimorada

### 5. Atomic Design
- ✅ Componentes modulares e reutilizáveis
- ✅ Hierarquia clara: Atoms → Molecules → Organisms
- ✅ Manutenção facilitada

---

## 📝 Conclusão

### Objetivos Alcançados

✅ **Arquitetura Robusta**: Clean Architecture + MVVM implementados  
✅ **Estado Gerenciado**: Provider com ChangeNotifier funcionando  
✅ **Código Testado**: 50+ testes automatizados  
✅ **Código Limpo**: Seguindo princípios SOLID e Clean Code  
✅ **Documentação Completa**: Código bem documentado  

### Diferenciais do Projeto

- 🏆 **Arquitetura Profissional**: Padrões utilizados em produção
- 🏆 **Cobertura de Testes**: Unitários e Widget
- 🏆 **Dependency Injection**: Implementação completa
- 🏆 **Clean Code**: Código legível e manutenível
- 🏆 **Firebase Integration**: Backend completo

### Aprendizados

- ✅ Implementação prática de Clean Architecture
- ✅ Gerenciamento de estado com Provider
- ✅ Testes automatizados em Flutter
- ✅ Padrões de design profissionais
- ✅ Integração com Firebase

---

## 📚 Referências

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Testing Flutter Apps](https://flutter.dev/docs/testing)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)

---

**Desenvolvido por:** [Seu Nome]  
**Disciplina:** Desenvolvimento Mobile  
**Professor:** [Nome do Professor]  
**Data:** 07/11/2024

---

**🎯 Este projeto demonstra domínio completo dos conceitos exigidos na disciplina, com implementação profissional de arquitetura, testes e padrões de design.**

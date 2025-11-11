# Documentação do Projeto - MGK Sistema de Cadastro

## Projeto Integrador - Desenvolvimento Mobile com Dart e Flutter

**Disciplina:** Desenvolvimento Mobile  
**Data de Entrega:** 07/11/2024  
**Equipe:** MGK

---

## Sumário

1. [Visão Geral](#visão-geral)
2. [Arquitetura](#arquitetura)
3. [Gerenciamento de Estado](#gerenciamento-de-estado)
4. [Dependency Injection](#dependency-injection)
5. [Testes](#testes)
6. [Estrutura de Pastas](#estrutura-de-pastas)
7. [Como Executar](#como-executar)
8. [Tecnologias Utilizadas](#tecnologias-utilizadas)

---

## Visão Geral

O **MGK** é um sistema de gerenciamento de cadastro de clientes desenvolvido em Flutter, que implementa conceitos avançados de arquitetura de software, incluindo **Clean Architecture**, **MVVM**, gerenciamento de estado com **Provider**, e testes automatizados.

### Funcionalidades Principais

- ✅ Sistema de autenticação com Firebase
- ✅ Gerenciamento de permissões (Admin e Usuário)
- ✅ CRUD de clientes
- ✅ Sistema de solicitações de cadastro
- ✅ Gerenciamento de contratos ativos
- ✅ Integração com Firestore para persistência de dados
- ✅ Interface responsiva e intuitiva

---

## Arquitetura

O projeto segue os princípios da **Clean Architecture** combinada com o padrão **MVVM (Model-View-ViewModel)**, garantindo separação de responsabilidades, testabilidade e manutenibilidade.

### Camadas da Arquitetura

#### 1. **Domain (Domínio)**

Camada central que contém a lógica de negócio e é independente de frameworks externos.

**Componentes:**

- **Models:** Entidades de negócio (`ClienteModel`, `UserModel`, `SolicitacaoModel`)
- **Repositories (Interfaces):** Contratos que definem operações de dados

**Princípios:**

- ✅ Independente de frameworks
- ✅ Contém regras de negócio
- ✅ Define contratos através de interfaces

```dart
// Exemplo: Cliente Model
class ClienteModel {
  final String? id;
  final String nome;
  final String cpf;
  final String email;
  // ... outros campos
}
```

#### 2. **Data (Dados)**

Camada responsável pela implementação concreta dos repositórios e acesso a dados.

**Componentes:**

- **DataSources:** Comunicação direta com APIs externas (Firebase)
- **Repositories Implementation:** Implementação dos contratos definidos no domínio

**Responsabilidades:**

- ✅ Comunicação com Firebase
- ✅ Transformação de dados externos para modelos de domínio
- ✅ Tratamento de erros de rede/persistência

```dart
// Exemplo: DataSource
class ClienteDataSource {
  final FirebaseFirestore _firestore;

  Future<List<ClienteModel>> getAll() async {
    final snapshot = await _firestore.collection('clientes').get();
    return snapshot.docs.map((doc) =>
      ClienteModel.fromMap(doc.data(), doc.id)
    ).toList();
  }
}
```

#### 3. **Presentation (Apresentação)**

Camada de interface do usuário e gerenciamento de estado.

**Componentes:**

- **ViewModels:** Gerenciam estado da UI usando `ChangeNotifier`
- **Pages:** Telas completas da aplicação
- **Templates:** Estruturas de layout reutilizáveis
- **Organisms:** Componentes UI complexos
- **Molecules:** Componentes UI médios
- **Atoms:** Componentes UI básicos

**Organização (Atomic Design):**

```
presentation/
├── viewmodels/        # Lógica de apresentação
├── pages/             # Telas completas
├── templates/         # Layouts
├── organisms/         # Componentes complexos
├── molecules/         # Componentes médios
└── atoms/             # Componentes básicos
```

### Diagrama de Arquitetura

```
┌─────────────────────────────────────────────────┐
│              PRESENTATION LAYER                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ViewModel │  │  Pages   │  │ Widgets  │      │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────────────────────────────────────────────┘
                      ↓ ↑
┌─────────────────────────────────────────────────┐
│               DOMAIN LAYER                       │
│  ┌──────────┐  ┌──────────────────────┐         │
│  │  Models  │  │  Repository Interface │         │
│  └──────────┘  └──────────────────────┘         │
└─────────────────────────────────────────────────┘
                      ↓ ↑
┌─────────────────────────────────────────────────┐
│                DATA LAYER                        │
│  ┌────────────┐  ┌──────────────────┐           │
│  │ DataSource │  │ Repository Impl  │           │
│  └────────────┘  └──────────────────┘           │
│         ↓                                        │
│  ┌────────────────────┐                         │
│  │  Firebase/Firestore │                         │
│  └────────────────────┘                         │
└─────────────────────────────────────────────────┘
```

---

## Gerenciamento de Estado

O projeto utiliza **Provider** como solução de gerenciamento de estado, oferecendo:

- ✅ Reatividade eficiente
- ✅ Injeção de dependência simples
- ✅ Fácil testabilidade
- ✅ Performance otimizada

### Implementação com Provider

#### ViewModels com ChangeNotifier

```dart
class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  UserModel? _currentUser;
  bool _isLoading = false;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;

  // Métodos que notificam mudanças
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _currentUser = await _authRepository.signIn(email, password);
    _setLoading(false);
    return _currentUser != null;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Notifica widgets observadores
  }
}
```

#### Consumindo Estado nos Widgets

```dart
// 1. Usando Consumer
Consumer<AuthViewModel>(
  builder: (context, authViewModel, child) {
    if (authViewModel.isLoading) {
      return CircularProgressIndicator();
    }
    return Text(authViewModel.currentUser?.email ?? '');
  },
)

// 2. Usando Provider.of
final authViewModel = Provider.of<AuthViewModel>(context);

// 3. Usando context.watch (mais recente)
final authViewModel = context.watch<AuthViewModel>();

// 4. Usando context.read (não reage a mudanças)
final authViewModel = context.read<AuthViewModel>();
```

### ViewModels Implementados

#### 1. **AuthViewModel**

Gerencia autenticação e permissões

- Login/Logout
- Verificação de permissões (Admin/Usuário)
- Criação de novos usuários

#### 2. **ClienteViewModel**

Gerencia operações CRUD de clientes

- Listar clientes
- Adicionar/Editar/Remover clientes
- Pesquisa de clientes
- Stream de atualizações em tempo real

#### 3. **SolicitacaoViewModel**

Gerencia solicitações de cadastro

- Listar solicitações pendentes
- Aprovar/Rejeitar solicitações
- Criar novas solicitações

---

## Dependency Injection

O sistema de **Dependency Injection (DI)** centralizado facilita a manutenção e testes.

### Estrutura de DI

```dart
class DependencyInjection {
  // DataSources
  static List<Provider> get providers => [
    Provider<AuthDataSource>(create: (_) => AuthDataSource()),
    Provider<ClienteDataSource>(create: (_) => ClienteDataSource()),
    // ... outros datasources
  ];

  // ViewModels
  static List<ChangeNotifierProvider> get changeNotifierProviders => [
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        authRepository: context.read<AuthRepository>(),
      ),
    ),
    // ... outros viewmodels
  ];
}
```

### Uso no main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ...DependencyInjection.providers,
        ...DependencyInjection.changeNotifierProviders,
      ],
      child: MyApp(),
    ),
  );
}
```

### Benefícios da DI

- ✅ **Testabilidade:** Fácil substituição de dependências por mocks
- ✅ **Manutenibilidade:** Centralização da configuração
- ✅ **Escalabilidade:** Fácil adição de novas dependências
- ✅ **Desacoplamento:** Classes não criam suas próprias dependências

---

## Testes

O projeto implementa uma estratégia completa de testes automatizados.

### Tipos de Testes Implementados

#### 1. **Testes Unitários**

Testam a lógica de negócio isoladamente.

**Cobertura:**

- ✅ Modelos de domínio (`ClienteModel`, `UserModel`, `SolicitacaoModel`)
- ✅ Validadores (CPF, Email, Senha, Telefone)
- ✅ Conversão de dados (toMap, fromMap)
- ✅ Lógica de copyWith e comparação

**Exemplo:**

```dart
test('Deve validar CPF correto', () {
  expect(Validators.isValidCPF('12345678909'), true);
  expect(Validators.isValidCPF('111.444.777-35'), true);
});

test('Deve criar ClienteModel corretamente', () {
  final cliente = ClienteModel(
    nome: 'João Silva',
    cpf: '12345678900',
    email: 'joao@email.com',
  );

  expect(cliente.nome, 'João Silva');
  expect(cliente.cpf, '12345678900');
});
```

#### 2. **Testes de Widget**

Testam componentes UI e suas interações.

**Cobertura:**

- ✅ `CustomButton` - Botão personalizado
- ✅ `LoginField` - Campo de login
- ✅ Callbacks e interações do usuário
- ✅ Acessibilidade (Semantics)

**Exemplo:**

```dart
testWidgets('Deve executar callback ao ser pressionado', (tester) async {
  bool wasPressed = false;

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: CustomButton(
          text: 'Clique',
          onPressed: () => wasPressed = true,
        ),
      ),
    ),
  );

  await tester.tap(find.byType(CustomButton));
  await tester.pump();

  expect(wasPressed, true);
});
```

### Executando os Testes

```powershell
# Executar todos os testes
flutter test

# Executar testes específicos
flutter test test/unit/
flutter test test/widget/

# Executar com cobertura
flutter test --coverage
```

### Estrutura de Testes

```
test/
├── unit/                    # Testes unitários
│   ├── models/             # Testes de modelos
│   │   ├── cliente_model_test.dart
│   │   ├── user_model_test.dart
│   │   └── solicitacao_model_test.dart
│   └── utils/              # Testes de utilitários
│       └── validators_test.dart
└── widget/                  # Testes de widget
    ├── custom_button_test.dart
    └── login_field_test.dart
```

---

## Estrutura de Pastas

```
lib/
├── main.dart                        # Ponto de entrada
├── firebase_options.dart            # Configuração Firebase
└── src/
    ├── core/                        # Núcleo da aplicação
    │   └── dependency_injection.dart
    │
    ├── domain/                      # Camada de domínio
    │   ├── models/                  # Entidades de negócio
    │   │   ├── cliente_model.dart
    │   │   ├── user_model.dart
    │   │   └── solicitacao_model.dart
    │   └── repositories/            # Interfaces dos repositórios
    │       ├── auth_repository.dart
    │       ├── cliente_repository.dart
    │       └── solicitacao_repository.dart
    │
    ├── data/                        # Camada de dados
    │   ├── datasources/             # Fontes de dados
    │   │   ├── auth_datasource.dart
    │   │   ├── cliente_datasource.dart
    │   │   └── solicitacao_datasource.dart
    │   └── repositories/            # Implementações
    │       ├── auth_repository_impl.dart
    │       ├── cliente_repository_impl.dart
    │       └── solicitacao_repository_impl.dart
    │
    ├── presentation/                # Camada de apresentação
    │   └── viewmodels/              # ViewModels
    │       ├── auth_viewmodel.dart
    │       ├── cliente_viewmodel.dart
    │       └── solicitacao_viewmodel.dart
    │
    ├── pages/                       # Páginas da aplicação
    ├── templates/                   # Templates de layout
    ├── organisms/                   # Componentes complexos
    ├── molecules/                   # Componentes médios
    ├── atoms/                       # Componentes básicos
    └── utils/                       # Utilitários
        ├── auth_service.dart
        ├── cep_service.dart
        └── json_placeholder_service.dart

test/
├── unit/                            # Testes unitários
│   ├── models/
│   └── utils/
└── widget/                          # Testes de widget
```

---

## Como Executar

### Pré-requisitos

- Flutter SDK 3.8.1 ou superior
- Dart SDK 3.8.1 ou superior
- Firebase CLI configurado
- Android Studio ou VS Code
- Dispositivo/Emulador Android ou iOS

### Instalação

```powershell
# 1. Clonar o repositório
git clone https://github.com/htmlmaicon/MGK.git
cd MGK

# 2. Instalar dependências
flutter pub get

# 3. Configurar Firebase
flutterfire configure

# 4. Executar testes
flutter test

# 5. Executar aplicação
flutter run
```

### Configuração do Firebase

1. Criar projeto no [Firebase Console](https://console.firebase.google.com/)
2. Adicionar aplicativo Android/iOS
3. Baixar arquivos de configuração
4. Executar `flutterfire configure`
5. Configurar Firestore e Authentication

### Credenciais de Teste

- **Administrador:**
  - Email: `admin@gmail.com`
  - Senha: (configurada no Firebase)

---

## Tecnologias Utilizadas

### Core

- **Flutter:** Framework UI multiplataforma
- **Dart:** Linguagem de programação

### Gerenciamento de Estado

- **Provider (6.1.5+1):** Gerenciamento de estado e DI

### Backend/Database

- **Firebase Core (4.2.1):** Inicialização do Firebase
- **Firebase Auth (6.1.2):** Autenticação de usuários
- **Cloud Firestore (6.1.0):** Banco de dados NoSQL

### Testes

- **flutter_test:** Framework de testes do Flutter

### Outras Dependências

- **http (1.1.0):** Requisições HTTP
- **sqflite (2.2.8+4):** Banco de dados local SQLite
- **cupertino_icons (1.0.8):** Ícones iOS

---

## Padrões e Princípios Aplicados

### Clean Code

- ✅ Nomes significativos e descritivos
- ✅ Funções pequenas e focadas
- ✅ Comentários apenas quando necessário
- ✅ Formatação consistente
- ✅ Tratamento adequado de erros

### SOLID

- ✅ **S**ingle Responsibility: Cada classe tem uma única responsabilidade
- ✅ **O**pen/Closed: Aberto para extensão, fechado para modificação
- ✅ **L**iskov Substitution: Interfaces bem definidas
- ✅ **I**nterface Segregation: Interfaces específicas
- ✅ **D**ependency Inversion: Dependência de abstrações

### DRY (Don't Repeat Yourself)

- ✅ Reutilização de componentes (Atomic Design)
- ✅ ViewModels compartilhados
- ✅ Utilitários centralizados

---

## Conclusão

Este projeto demonstra a aplicação prática de conceitos avançados de desenvolvimento mobile:

### Requisitos Atendidos ✅

1. **Refatoração para Arquitetura:**

   - ✅ Clean Architecture implementada
   - ✅ MVVM aplicado com separação clara de camadas
   - ✅ Domain, Data e Presentation bem definidos

2. **Gerenciamento de Estado Avançado:**

   - ✅ Provider implementado com MultiProvider
   - ✅ ViewModels com ChangeNotifier
   - ✅ Dependency Injection centralizada

3. **Testes Automatizados:**
   - ✅ Testes unitários para models e lógica de negócio
   - ✅ Testes de widget para componentes UI
   - ✅ Cobertura de casos importantes

### Próximos Passos

- Implementar testes de integração
- Adicionar CI/CD pipeline
- Melhorar cobertura de testes
- Implementar offline-first com sincronização
- Adicionar analytics e crash reporting

---

**Desenvolvido com ❤️ usando Flutter e Clean Architecture**

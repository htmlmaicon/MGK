# 📖 Documentação Técnica - MGK Sistema de Cadastro

## 📚 Visão Geral

Este documento fornece uma explicação detalhada dos aspectos técnicos e decisões de design do projeto MGK, complementando o roteiro de apresentação.

---

## 🏗️ 1. ARQUITETURA DA APLICAÇÃO

### 1.1 Arquitetura Híbrida: MVVM + Clean Architecture + DDD

O projeto implementa uma arquitetura em camadas que combina os melhores aspectos de diferentes padrões:

#### **Clean Architecture (Camadas)**

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│    (ViewModels + ChangeNotifier)        │
├─────────────────────────────────────────┤
│           Domain Layer                  │
│  (Entities, Interfaces, Use Cases)      │
├─────────────────────────────────────────┤
│            Data Layer                   │
│  (Repositories, DataSources, DTOs)      │
└─────────────────────────────────────────┘
```

**Vantagens:**
- ✅ Separação clara de responsabilidades
- ✅ Testabilidade (cada camada pode ser testada isoladamente)
- ✅ Independência de frameworks externos
- ✅ Facilita manutenção e evolução do código

#### **MVVM (Model-View-ViewModel)**

```
View (Flutter Widgets)
    ↓ observa
ViewModel (ChangeNotifier)
    ↓ usa
Model (Domain + Data)
```

**Implementação:**
- **View**: Widgets Flutter (`pages/`, `organisms/`, `molecules/`, `atoms/`)
- **ViewModel**: Classes com ChangeNotifier (`presentation/viewmodels/`)
- **Model**: Domain entities e repositories

**Exemplo prático:**
```dart
// View observa o ViewModel
Consumer<AuthViewModel>(
  builder: (context, viewModel, child) {
    if (viewModel.isLoading) {
      return CircularProgressIndicator();
    }
    return LoginForm();
  },
)

// ViewModel notifica mudanças
class AuthViewModel extends ChangeNotifier {
  void signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners(); // View será atualizada
    // ...
  }
}
```

#### **DDD (Domain-Driven Design) - Conceitual**

Aplicamos conceitos de DDD:

1. **Entities** (Entidades): `ClienteModel`, `SolicitacaoModel`, `UserModel`
2. **Repositories** (Interfaces): `AuthRepository`, `ClienteRepository`
3. **Value Objects**: CPF, Email (validações no modelo)
4. **Aggregates**: Cliente com suas solicitações

---

### 1.2 Estrutura de Pastas e Responsabilidades

```
lib/src/
├── 🎯 domain/                    # CAMADA DE DOMÍNIO
│   ├── models/                   # Entidades de negócio
│   │   ├── cliente_model.dart    # Modelo de Cliente
│   │   ├── solicitacao_model.dart
│   │   └── user_model.dart
│   └── repositories/             # Contratos (interfaces)
│       ├── auth_repository.dart
│       ├── cliente_repository.dart
│       └── solicitacao_repository.dart
│
├── 💾 data/                      # CAMADA DE DADOS
│   ├── datasources/              # Acesso a dados externos
│   │   ├── auth_datasource.dart  # Firebase Auth
│   │   ├── cliente_datasource.dart # Firestore
│   │   └── solicitacao_datasource.dart
│   └── repositories/             # Implementações
│       ├── auth_repository_impl.dart
│       ├── cliente_repository_impl.dart
│       └── solicitacao_repository_impl.dart
│
├── 🎨 presentation/              # CAMADA DE APRESENTAÇÃO
│   └── viewmodels/               # Gerenciamento de estado
│       ├── auth_viewmodel.dart   # Estado de autenticação
│       ├── cliente_viewmodel.dart
│       └── solicitacao_viewmodel.dart
│
├── 🧩 ATOMIC DESIGN               # Componentização UI
│   ├── atoms/                    # Componentes básicos
│   │   ├── custom_button.dart
│   │   ├── custom_input.dart
│   │   └── custom_text.dart
│   ├── molecules/                # Combinação de átomos
│   │   ├── cep_field.dart
│   │   └── login_field.dart
│   ├── organisms/                # Componentes complexos
│   │   ├── login_form.dart
│   │   └── client_form.dart
│   ├── templates/                # Layouts de página
│   │   └── login_template.dart
│   └── pages/                    # Páginas completas
│       ├── login_page.dart
│       └── home_page.dart
│
└── ⚙️ core/                      # Funcionalidades centrais
    ├── dependency_injection.dart # DI com Provider
    └── services/
        └── notification_service.dart
```

---

### 1.3 Fluxo de Dados

#### Exemplo: Login de Usuário

```
1. User interage com LoginPage (View)
   ↓
2. LoginPage chama AuthViewModel.signIn()
   ↓
3. AuthViewModel usa AuthRepository (interface)
   ↓
4. AuthRepositoryImpl implementa a lógica
   ↓
5. AuthDataSource comunica com Firebase
   ↓
6. Dados retornam através das camadas
   ↓
7. AuthViewModel.notifyListeners()
   ↓
8. View é atualizada automaticamente
```

**Código ilustrativo:**
```dart
// 1. View (login_page.dart)
ElevatedButton(
  onPressed: () {
    final viewModel = context.read<AuthViewModel>();
    viewModel.signIn(email, password);
  },
  child: Text('Login'),
)

// 2-3. ViewModel (auth_viewmodel.dart)
Future<bool> signIn(String email, String password) async {
  _setLoading(true);
  _currentUser = await _authRepository.signIn(email, password);
  _setLoading(false);
  return _currentUser != null;
}

// 4. Repository Implementation (auth_repository_impl.dart)
@override
Future<UserModel?> signIn(String email, String password) {
  return _dataSource.signIn(email, password);
}

// 5. DataSource (auth_datasource.dart)
Future<UserModel?> signIn(String email, String password) async {
  final credential = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
  return _userFromFirebase(credential.user);
}
```

---

### 1.4 Injeção de Dependências

Utilizamos **Provider** para gerenciar dependências de forma centralizada.

**Vantagens:**
- Fácil substituição de implementações (útil para testes)
- Gerenciamento automático do ciclo de vida
- Acesso a dependências em qualquer lugar da árvore de widgets

**Implementação:**
```dart
// dependency_injection.dart
class DependencyInjection {
  static List<Provider> get providers {
    return [
      // 1. DataSources (acesso a dados)
      Provider<AuthDataSource>(create: (_) => AuthDataSource()),
      
      // 2. Repositories (lógica de negócio)
      Provider<AuthRepository>(
        create: (context) => AuthRepositoryImpl(
          dataSource: context.read<AuthDataSource>()
        ),
      ),
    ];
  }

  static List<ChangeNotifierProvider> get changeNotifierProviders {
    return [
      // 3. ViewModels (gerenciamento de estado)
      ChangeNotifierProvider<AuthViewModel>(
        create: (context) => AuthViewModel(
          authRepository: context.read<AuthRepository>()
        ),
      ),
    ];
  }
}

// main.dart
MultiProvider(
  providers: [
    ...DependencyInjection.providers,
    ...DependencyInjection.changeNotifierProviders,
  ],
  child: MyApp(),
)
```

---

## 🧪 2. ESTRATÉGIA DE TESTES

### 2.1 Pirâmide de Testes

```
        /\
       /  \     Integração (Poucos)
      /____\    
     /      \   Widget (Médio)
    /________\  
   /          \ Unitário (Muitos)
  /____________\
```

### 2.2 Testes Unitários

**Objetivo:** Validar lógica de negócio isolada (modelos, validações, cálculos)

**Localização:** `test/unit/`

**Exemplo - Teste de Modelo:**
```dart
// test/unit/models/cliente_model_test.dart
void main() {
  group('ClienteModel Tests', () {
    test('Deve criar ClienteModel corretamente', () {
      // Arrange (preparar)
      final dataCadastro = DateTime(2024, 1, 1);

      // Act (executar)
      final cliente = ClienteModel(
        id: '1',
        nome: 'João Silva',
        cpf: '12345678900',
        email: 'joao@email.com',
        dataCadastro: dataCadastro,
      );

      // Assert (verificar)
      expect(cliente.id, '1');
      expect(cliente.nome, 'João Silva');
      expect(cliente.cpf, '12345678900');
    });

    test('Deve converter para Map corretamente', () {
      final cliente = ClienteModel(/* ... */);
      final map = cliente.toMap();
      
      expect(map['nome'], 'João Silva');
      expect(map['cpf'], '12345678900');
    });

    test('Deve criar a partir de Map', () {
      final map = {'nome': 'Maria', 'cpf': '98765432100'};
      final cliente = ClienteModel.fromMap(map, '2');
      
      expect(cliente.id, '2');
      expect(cliente.nome, 'Maria');
    });
  });
}
```

**O que testamos:**
- ✅ Criação de objetos
- ✅ Serialização (toMap)
- ✅ Deserialização (fromMap)
- ✅ Métodos copyWith
- ✅ Comparação de igualdade
- ✅ Validações de negócio

---

### 2.3 Testes de Widget

**Objetivo:** Validar comportamento e renderização de componentes UI

**Localização:** `test/widget/`

**Exemplo - Teste de Botão:**
```dart
// test/widget/custom_button_test.dart
void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('Deve renderizar com texto correto', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(text: 'Entrar', onPressed: () {}),
          ),
        ),
      );

      // Assert
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets('Deve executar callback ao ser pressionado', (tester) async {
      // Arrange
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

      // Act
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Assert
      expect(wasPressed, true);
    });

    testWidgets('Deve ter semântica para acessibilidade', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CustomButton(text: 'Acessível', onPressed: () {}),
        ),
      );

      // Verifica propriedades de acessibilidade
      final semantics = tester.widget<Semantics>(
        find.ancestor(
          of: find.byType(InkWell),
          matching: find.byType(Semantics),
        ).first,
      );

      expect(semantics.properties.button, isTrue);
      expect(semantics.properties.label, 'Botão Acessível');
    });
  });
}
```

**O que testamos:**
- ✅ Renderização correta
- ✅ Interações (tap, scroll, input)
- ✅ Estados (loading, erro, sucesso)
- ✅ Acessibilidade (Semantics)
- ✅ Estilos e customizações

---

### 2.4 Testes de Integração

**Objetivo:** Validar fluxos completos da aplicação

**Localização:** `test/integration_test/`

**Exemplo - Fluxo de Login:**
```dart
// test/integration_test/app_integration_test_simple.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Teste de Integração - Login', () {
    testWidgets('Fluxo completo de login com validação', (tester) async {
      // Inicia a aplicação
      app.main();
      await tester.pumpAndSettle();

      // 1. Tenta login sem preencher campos
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Preencha'), findsWidgets);

      // 2. Preenche campos
      final campos = find.byType(TextField);
      await tester.enterText(campos.at(0), 'teste@email.com');
      await tester.enterText(campos.at(1), 'senha123');
      
      // 3. Submete formulário
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      // 4. Verifica loading
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      // 5. Aguarda resposta do Firebase
      await tester.pumpAndSettle(Duration(seconds: 10));
    });

    testWidgets('Deve navegar entre telas', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navega para cadastro
      await tester.tap(find.textContaining('Cadastre-se'));
      await tester.pumpAndSettle();

      // Verifica que navegou
      expect(find.textContaining('Solicitar'), findsWidgets);
    });
  });

  group('Teste de Performance', () {
    testWidgets('App deve carregar rapidamente', (tester) async {
      final stopwatch = Stopwatch()..start();
      
      app.main();
      await tester.pumpAndSettle(Duration(seconds: 5));
      
      stopwatch.stop();
      
      expect(stopwatch.elapsedMilliseconds, lessThan(15000));
    });
  });
}
```

**O que testamos:**
- ✅ Fluxos de usuário (login, cadastro, navegação)
- ✅ Integração com Firebase
- ✅ Validações de formulários
- ✅ Performance da aplicação
- ✅ Estados assíncronos

---

### 2.5 Abordagem TDD/BDD

**Test-Driven Development (TDD):**
1. Escrever teste que falha (Red)
2. Implementar código mínimo para passar (Green)
3. Refatorar mantendo testes verdes (Refactor)

**Behavior-Driven Development (BDD):**
Testes escritos em linguagem natural:
```dart
test('Deve criar ClienteModel corretamente', () {
  // Given (Dado que)
  final dataCadastro = DateTime(2024, 1, 1);

  // When (Quando)
  final cliente = ClienteModel(id: '1', nome: 'João', ...);

  // Then (Então)
  expect(cliente.id, '1');
  expect(cliente.nome, 'João');
});
```

---

## 🎨 3. UI/UX POLIDA E ACESSÍVEL

### 3.1 Atomic Design - Detalhado

#### **Átomos (Atoms)** - Componentes básicos indivisíveis

```dart
// lib/src/atoms/custom_button.dart
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: "Botão $text",
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.green[100]?.withOpacity(0.5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
```

**Átomos do projeto:**
- `custom_button.dart` - Botão reutilizável
- `custom_input.dart` - Campo de entrada
- `custom_text.dart` - Texto estilizado
- `custom_icon.dart` - Ícone personalizado
- `custom_appbar.dart` - AppBar customizada

#### **Moléculas (Molecules)** - Combinação de átomos

```dart
// lib/src/molecules/cep_field.dart
class CepField extends StatelessWidget {
  final TextEditingController cepController;
  final Function(String) onSearchCep;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(  // Átomo
            controller: cepController,
            labelText: "CEP",
          ),
        ),
        IconButton(  // Átomo
          icon: isLoading 
            ? CircularProgressIndicator()  // Átomo
            : Icon(Icons.search),  // Átomo
          onPressed: () => onSearchCep(cepController.text),
        ),
      ],
    );
  }
}
```

**Moléculas do projeto:**
- `cep_field.dart` - Campo CEP + botão busca
- `login_field.dart` - Campo login com validação
- `text_field.dart` - TextField customizado
- `submit_button.dart` - Botão de submissão

#### **Organismos (Organisms)** - Componentes complexos

```dart
// lib/src/organisms/login_form.dart
class LoginForm extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LoginField(  // Molécula
          controller: emailController,
          label: "Email",
        ),
        LoginField(  // Molécula
          controller: senhaController,
          label: "Senha",
          isPassword: true,
        ),
        SizedBox(height: 16),
        loading 
          ? CircularProgressIndicator()  // Átomo
          : CustomButton(  // Átomo
              text: "Entrar",
              onPressed: _login,
            ),
      ],
    );
  }
}
```

**Organismos do projeto:**
- `login_form.dart` - Formulário completo de login
- `register_form.dart` - Formulário de cadastro
- `client_form.dart` - Formulário de cliente
- `contracts_list_organism.dart` - Lista de contratos
- `solicitations_list_organism.dart` - Lista de solicitações

#### **Templates** - Layouts de página

```dart
// lib/src/templates/login_template.dart
class LoginTemplate extends StatelessWidget {
  final Widget form;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Login"),  // Átomo
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              form,  // Organismo injetado
              if (footer != null) footer!,
            ],
          ),
        ),
      ),
    );
  }
}
```

#### **Pages** - Páginas completas

```dart
// lib/src/pages/login_page.dart
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginTemplate(  // Template
      form: LoginForm(),  // Organismo
      footer: TextButton(
        onPressed: () => Navigator.push(...),
        child: Text("Cadastre-se"),
      ),
    );
  }
}
```

---

### 3.2 Microinterações e Animações

#### **1. Feedback de Toque (Ripple Effect)**
```dart
InkWell(
  onTap: onPressed,
  borderRadius: borderRadius,
  splashColor: Colors.green[100]?.withOpacity(0.5),
  highlightColor: Colors.green[200],
  child: /* ... */,
)
```

#### **2. Estados de Loading**
```dart
_loading 
  ? const CircularProgressIndicator()
  : CustomButton(text: "Entrar", onPressed: _login)
```

#### **3. Animações de Erro**
```dart
if (error != null)
  Padding(
    padding: EdgeInsets.only(left: 12, top: 4),
    child: Text(
      error!,
      style: TextStyle(color: Colors.red, fontSize: 12),
    ),
  )
```

#### **4. Transições de Navegação**
```dart
Navigator.pushReplacement(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
)
```

---

### 3.3 Acessibilidade (WCAG)

#### **Diretrizes WCAG Implementadas:**

##### **1. Perceptível**
```dart
// Contraste adequado de cores
backgroundColor: Colors.green,  // #4CAF50
textColor: Colors.white,        // #FFFFFF
// Contraste: 4.07:1 (Passa WCAG AA)

// Textos alternativos
Semantics(
  label: "Botão de login",
  hint: "Pressione para fazer login",
  child: CustomButton(...),
)
```

##### **2. Operável**
```dart
// Áreas de toque adequadas (mínimo 44x44 pts)
Container(
  padding: EdgeInsets.symmetric(
    horizontal: 40,  // 80px total
    vertical: 20,    // 40px total
  ),
  // Área de toque: > 44x44 ✓
)

// Navegação por teclado (automático no Flutter)
TextField(
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
)
```

##### **3. Compreensível**
```dart
// Labels descritivos
CustomTextField(
  labelText: "Endereço de email",
  hintText: "exemplo@email.com",
)

// Mensagens de erro claras
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, preencha o email';
  }
  if (!value.contains('@')) {
    return 'Email inválido. Use o formato: exemplo@email.com';
  }
  return null;
}
```

##### **4. Robusto**
```dart
// Semantics para leitores de tela
Semantics(
  button: true,
  enabled: !isLoading,
  label: "Botão $text",
  child: InkWell(...),
)

// Estados claros
if (isLoading) {
  return Semantics(
    label: "Carregando",
    child: CircularProgressIndicator(),
  );
}
```

#### **Recursos de Acessibilidade:**
- ✅ Semantics em todos os componentes interativos
- ✅ Contraste de cores adequado (WCAG AA)
- ✅ Tamanhos de toque apropriados (≥44pt)
- ✅ Labels descritivos e hints
- ✅ Mensagens de erro claras
- ✅ Suporte a leitores de tela
- ✅ Navegação por teclado
- ✅ Estados visuais distintos

---

## ⚡ 4. OTIMIZAÇÃO E PERFORMANCE

### 4.1 Uso de `const` Constructors

**Por que usar const?**
- Widget não precisa ser reconstruído
- Economiza memória (reutiliza instância)
- Melhora performance de renderização

**Exemplos:**
```dart
// ✅ BOM - Widget const
const SizedBox(height: 16)
const Icon(Icons.search, color: Colors.green)
const EdgeInsets.symmetric(horizontal: 40, vertical: 20)
const BorderRadius.all(Radius.circular(15))

// ✅ BOM - Constructor const
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    // ...
  });
}

// ❌ EVITAR - Widget sem const
SizedBox(height: 16)  // Será recriado a cada build
```

---

### 4.2 Keys para Otimização

**Quando usar Keys:**
- Listas dinâmicas
- Widgets que mudam de posição
- Preservar estado durante rebuild

**Tipos de Keys:**
```dart
// ValueKey - Para valores únicos simples
ListView.builder(
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(clientes[index].id),
      // ...
    );
  },
)

// ObjectKey - Para objetos complexos
key: ObjectKey(cliente)

// UniqueKey - Sempre único (usar com cautela)
key: UniqueKey()

// GlobalKey - Acesso ao State de outro widget
final _formKey = GlobalKey<FormState>();
Form(key: _formKey, /* ... */)
```

---

### 4.3 Otimização de Widgets

#### **1. Evitar Widgets Pesados no Build**
```dart
// ❌ MAU - Cria função a cada build
Widget build(BuildContext context) {
  return ListView(
    children: clientes.map((c) => ClienteTile(c)).toList(),
  );
}

// ✅ BOM - Usa ListView.builder
Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: clientes.length,
    itemBuilder: (context, index) => ClienteTile(clientes[index]),
  );
}
```

#### **2. Separar Widgets que Mudam**
```dart
// ❌ MAU - Todo o widget rebuilda
class HomePage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(...),  // Rebuilda desnecessariamente
        _counter,
        Button(onPressed: () => setState(() => _counter++)),
      ],
    );
  }
}

// ✅ BOM - Apenas contador rebuilda
class HomePage extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppBar(...),  // Const, não rebuilda
        CounterWidget(counter: _counter),  // Só este rebuilda
        const Button(...),  // Const, não rebuilda
      ],
    );
  }
}
```

#### **3. Usar RepaintBoundary para Isolação**
```dart
RepaintBoundary(
  child: ComplexAnimation(),  // Não afeta widgets vizinhos
)
```

---

### 4.4 Lazy Loading e Assíncronas

#### **1. FutureBuilder para Dados Únicos**
```dart
FutureBuilder<List<Cliente>>(
  future: _carregarClientes(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Erro: ${snapshot.error}');
    }
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) => ClienteTile(snapshot.data![index]),
    );
  },
)
```

#### **2. StreamBuilder para Dados em Tempo Real**
```dart
StreamBuilder<List<Cliente>>(
  stream: _clientesStream(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) => ClienteTile(snapshot.data![index]),
    );
  },
)
```

#### **3. Paginação para Grandes Listas**
```dart
class ClientesList extends StatefulWidget {
  @override
  _ClientesListState createState() => _ClientesListState();
}

class _ClientesListState extends State<ClientesList> {
  final _scrollController = ScrollController();
  List<Cliente> _clientes = [];
  int _page = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _carregarMais();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      _carregarMais();
    }
  }

  Future<void> _carregarMais() async {
    if (_loading) return;
    setState(() => _loading = true);
    
    final novosClientes = await _api.getClientes(page: _page);
    setState(() {
      _clientes.addAll(novosClientes);
      _page++;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _clientes.length + (_loading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _clientes.length) {
          return const CircularProgressIndicator();
        }
        return ClienteTile(_clientes[index]);
      },
    );
  }
}
```

---

### 4.5 Otimização de Build

#### **1. Build Modes**
```bash
# Debug - Desenvolvimento (com hot reload)
flutter run

# Profile - Análise de performance
flutter run --profile

# Release - Produção (otimizado)
flutter run --release
flutter build apk --release
flutter build ios --release
```

#### **2. Split APKs por ABI (Android)**
```bash
# Gera APKs separados para cada arquitetura
flutter build apk --release --split-per-abi

# Resulta em:
# - app-armeabi-v7a-release.apk (~20MB)
# - app-arm64-v8a-release.apk (~22MB)
# - app-x86_64-release.apk (~25MB)
```

#### **3. Análise de Tamanho**
```bash
# Analisa tamanho do app
flutter build apk --analyze-size
flutter build appbundle --analyze-size

# Gera relatório de dependências
flutter pub deps
```

---

### 4.6 Identificação de Gargalos com DevTools

#### **1. Performance Overlay**
```dart
// Em MaterialApp
MaterialApp(
  showPerformanceOverlay: true,  // Mostra FPS
  // ...
)
```

#### **2. Timeline Performance**
```bash
# Inicia app em modo profile
flutter run --profile

# Abre DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

**Métricas importantes:**
- **60 FPS**: Verde (bom)
- **30-60 FPS**: Amarelo (aceitável)
- **< 30 FPS**: Vermelho (problema)

#### **3. Memory Profiling**
- Identificar memory leaks
- Ver alocações de memória
- Analisar uso de widgets

#### **4. Network Profiling**
- Monitorar requisições HTTP
- Ver tempo de resposta
- Identificar requisições desnecessárias

---

### 4.7 Boas Práticas de Performance

```dart
// ✅ 1. Evitar setState desnecessário
// MAU
setState(() {
  _valor = novoValor;
  _outroValor = _valor * 2;  // Cálculo no setState
});

// BOM
_outroValor = novoValor * 2;  // Cálculo fora do setState
setState(() {
  _valor = novoValor;
});

// ✅ 2. Usar const sempre que possível
const EdgeInsets.all(16)
const Duration(seconds: 2)

// ✅ 3. Cache de dados
class ClienteService {
  List<Cliente>? _cache;
  DateTime? _lastUpdate;

  Future<List<Cliente>> getClientes() async {
    if (_cache != null && 
        DateTime.now().difference(_lastUpdate!) < Duration(minutes: 5)) {
      return _cache!;
    }
    
    _cache = await _api.fetchClientes();
    _lastUpdate = DateTime.now();
    return _cache!;
  }
}

// ✅ 4. Dispose de Controllers
@override
void dispose() {
  _textController.dispose();
  _scrollController.dispose();
  _animationController.dispose();
  super.dispose();
}

// ✅ 5. Lazy initialization
late final _controller = TextEditingController();

// ✅ 6. Evitar closures pesadas
// MAU
onPressed: () {
  var dados = calcularDadosComplexos();
  Navigator.push(...);
}

// BOM
void _onPressed() {
  var dados = calcularDadosComplexos();
  Navigator.push(...);
}
// ...
onPressed: _onPressed
```

---

## 📊 5. MÉTRICAS E RESULTADOS

### 5.1 Cobertura de Testes
```bash
# Gerar relatório de cobertura
flutter test --coverage

# Visualizar com lcov (Linux/Mac)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Metas de cobertura:**
- Modelos: > 90%
- ViewModels: > 80%
- Widgets: > 70%
- Integração: Fluxos críticos

### 5.2 Performance Metrics

**Tempo de carregamento:**
- Cold start: < 3 segundos
- Hot reload: < 1 segundo
- Navegação entre telas: < 300ms

**Uso de memória:**
- Idle: < 100MB
- Operação normal: < 200MB
- Peak: < 300MB

**Frame rate:**
- Alvo: 60 FPS
- Mínimo aceitável: 30 FPS
- Jank: < 5% dos frames

---

## 🎯 6. CONCLUSÃO E BOAS PRÁTICAS

### Checklist de Qualidade

**Arquitetura:**
- ✅ Separação em camadas clara
- ✅ Dependências injetadas
- ✅ Código testável
- ✅ Fácil manutenção

**Testes:**
- ✅ Unitários para lógica de negócio
- ✅ Widget para componentes UI
- ✅ Integração para fluxos críticos
- ✅ Cobertura adequada

**UI/UX:**
- ✅ Atomic Design implementado
- ✅ Componentes reutilizáveis
- ✅ Acessibilidade WCAG
- ✅ Microinterações

**Performance:**
- ✅ Const widgets
- ✅ Keys apropriadas
- ✅ Lazy loading
- ✅ Build otimizado

---

## 📚 Referências

- [Flutter Documentation](https://docs.flutter.dev/)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [MVVM Pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)
- [Atomic Design](https://bradfrost.com/blog/post/atomic-web-design/)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Flutter Performance](https://docs.flutter.dev/perf)
- [Provider Package](https://pub.dev/packages/provider)
- [Testing Flutter Apps](https://docs.flutter.dev/testing)

---

**Última atualização:** 2024
**Versão:** 1.0.0

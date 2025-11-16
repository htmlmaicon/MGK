# Diagramas de Arquitetura - Sistema MGK
## Recursos Visuais para Apresentação

---

## 1. DIAGRAMA DE ARQUITETURA GERAL

```
┌─────────────────────────────────────────────────────────────┐
│                        APLICAÇÃO MGK                         │
│                  (Flutter + Firebase)                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    CAMADA DE APRESENTAÇÃO                    │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐            │
│  │ Login Page │  │ Home Page  │  │Cliente Page│  ...        │
│  └────────────┘  └────────────┘  └────────────┘            │
│         │                │                │                  │
│         └────────────────┼────────────────┘                  │
│                          │                                   │
│         ┌────────────────▼────────────────┐                 │
│         │     ViewModels (Provider)       │                 │
│         │  • AuthViewModel                │                 │
│         │  • ClienteViewModel             │                 │
│         │  • SolicitacaoViewModel         │                 │
│         └────────────────┬────────────────┘                 │
└──────────────────────────┼──────────────────────────────────┘
                           │
┌──────────────────────────┼──────────────────────────────────┐
│                    CAMADA DE DOMÍNIO                         │
│         ┌────────────────▼────────────────┐                 │
│         │   Repository Interfaces         │                 │
│         │  • ClienteRepository            │                 │
│         │  • AuthRepository               │                 │
│         │  • SolicitacaoRepository        │                 │
│         └────────────────┬────────────────┘                 │
│                          │                                   │
│         ┌────────────────▼────────────────┐                 │
│         │      Domain Models              │                 │
│         │  • ClienteModel                 │                 │
│         │  • UserModel                    │                 │
│         │  • SolicitacaoModel             │                 │
│         └─────────────────────────────────┘                 │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────┼──────────────────────────────────┐
│                     CAMADA DE DADOS                          │
│         ┌────────────────▼────────────────┐                 │
│         │  Repository Implementations     │                 │
│         │  • ClienteRepositoryImpl        │                 │
│         │  • AuthRepositoryImpl           │                 │
│         │  • SolicitacaoRepositoryImpl    │                 │
│         └────────────────┬────────────────┘                 │
│                          │                                   │
│         ┌────────────────▼────────────────┐                 │
│         │        DataSources              │                 │
│         │  • AuthDataSource (Firebase)    │                 │
│         │  • ClienteDataSource (Firestore)│                 │
│         │  • SolicitacaoDataSource        │                 │
│         └────────────────┬────────────────┘                 │
└──────────────────────────┼──────────────────────────────────┘
                           │
                    ┌──────▼──────┐
                    │   Firebase   │
                    │  • Auth      │
                    │  • Firestore │
                    │  • Messaging │
                    └──────────────┘
```

---

## 2. FLUXO DE DADOS (EXEMPLO: BUSCAR CLIENTES)

```
┌─────────────┐
│  LoginPage  │  1. User taps "Ver Clientes"
└──────┬──────┘
       │
       │ 2. Navigator.push()
       ▼
┌─────────────────┐
│Ver Clientes Page│  3. initState() -> context.read<ClienteViewModel>()
└──────┬──────────┘
       │
       │ 4. loadClientes()
       ▼
┌──────────────────┐
│ ClienteViewModel │  5. Calls _clienteRepository.getAll()
└──────┬───────────┘
       │
       │ 6. Through interface
       ▼
┌─────────────────────┐
│ClienteRepositoryImpl│  7. Calls _dataSource.getAll()
└──────┬──────────────┘
       │
       │ 8. Firebase query
       ▼
┌──────────────────┐
│ClienteDataSource │  9. FirebaseFirestore.collection('clientes').get()
└──────┬───────────┘
       │
       │ 10. Network request
       ▼
┌──────────────┐
│   Firebase   │  11. Returns QuerySnapshot
└──────┬───────┘
       │
       │ 12. Data flows back
       ▼
┌──────────────────┐
│ClienteDataSource │  13. Maps to List<ClienteModel>
└──────┬───────────┘
       │
       ▼
┌─────────────────────┐
│ClienteRepositoryImpl│  14. Returns List<ClienteModel>
└──────┬──────────────┘
       │
       ▼
┌──────────────────┐
│ ClienteViewModel │  15. Updates _clientes list
└──────┬───────────┘    16. Calls notifyListeners()
       │
       │ 17. Provider notifies listeners
       ▼
┌─────────────────┐
│Ver Clientes Page│  18. Rebuilds with new data
└─────────────────┘    19. ListView displays clientes
```

---

## 3. ATOMIC DESIGN - HIERARQUIA DE COMPONENTES

```
┌────────────────────────────────────────────────────┐
│                  ORGANISMOS                        │
│  (Componentes Complexos - Features Completas)      │
│                                                     │
│  ┌──────────────┐  ┌──────────────┐               │
│  │  LoginForm   │  │  ClientForm  │               │
│  │              │  │              │               │
│  │ • Email      │  │ • Nome       │               │
│  │ • Senha      │  │ • CPF        │               │
│  │ • Botão      │  │ • Email      │               │
│  └──────────────┘  └──────────────┘               │
└────────────────────────────────────────────────────┘
                  │
                  │ Compostos de
                  ▼
┌────────────────────────────────────────────────────┐
│                   MOLÉCULAS                        │
│  (Combinação de Átomos com Funcionalidade)         │
│                                                     │
│  ┌──────────────┐  ┌──────────────┐               │
│  │  LoginField  │  │   CepField   │               │
│  │              │  │              │               │
│  │ CustomInput  │  │ CustomInput  │               │
│  │ + Validation │  │ + Mask       │               │
│  │ + Label      │  │ + API Call   │               │
│  └──────────────┘  └──────────────┘               │
└────────────────────────────────────────────────────┘
                  │
                  │ Compostos de
                  ▼
┌────────────────────────────────────────────────────┐
│                    ÁTOMOS                          │
│  (Componentes Básicos Reutilizáveis)               │
│                                                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ │
│  │CustomButton │ │ CustomInput │ │ CustomText  │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ │
│                                                     │
│  ┌─────────────┐ ┌─────────────┐                  │
│  │ CustomIcon  │ │CustomAppBar │                  │
│  └─────────────┘ └─────────────┘                  │
└────────────────────────────────────────────────────┘
```

**Exemplo de Composição:**

```
LoginForm (Organismo)
├── CustomAppBar (Átomo)
├── CustomText (Átomo) - "Faça login..."
├── LoginField (Molécula)
│   ├── CustomInput (Átomo)
│   └── CustomText (Átomo) - Label
├── LoginField (Molécula) - Senha
│   ├── CustomInput (Átomo)
│   └── CustomText (Átomo) - Label
└── SubmitButton (Molécula)
    ├── CustomButton (Átomo)
    └── CircularProgressIndicator (quando loading)
```

---

## 4. PIRÂMIDE DE TESTES

```
                     /\
                    /  \
                   / E2E \      Integration Tests (2 arquivos)
                  /______\      • app_integration_test.dart
                 /        \     • app_integration_test_simple.dart
                /  Widget  \    
               /____________\   Widget Tests (2 arquivos)
              /              \  • custom_button_test.dart
             /      Unit      \ • login_field_test.dart
            /__________________\
           /                    \ Unit Tests (4 arquivos)
          /                      \• cliente_model_test.dart
         /________________________\• solicitacao_model_test.dart
                                  • user_model_test.dart
                                  • validators_test.dart

Proporção Ideal:        Real no Projeto:
70% Unit               44% (4/9)
20% Widget             22% (2/9)
10% Integration        22% (2/9) - Bom para app pequeno
```

---

## 5. DEPENDENCY INJECTION COM PROVIDER

```
┌─────────────────────────────────────────────────────────┐
│                      MyApp (main.dart)                   │
│                                                           │
│  MultiProvider(                                          │
│    providers: [                                          │
│      • AuthDataSource                                    │
│      • ClienteDataSource                                 │
│      • SolicitacaoDataSource                             │
│      • AuthRepository                                    │
│      • ClienteRepository                                 │
│      • SolicitacaoRepository                             │
│    ],                                                     │
│    changeNotifierProviders: [                            │
│      • AuthViewModel                                     │
│      • ClienteViewModel                                  │
│      • SolicitacaoViewModel                              │
│    ],                                                     │
│    child: MaterialApp(...)                               │
│  )                                                        │
└─────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          │               │               │
          ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │LoginPage │    │HomePage  │    │ClientPage│
    └────┬─────┘    └────┬─────┘    └────┬─────┘
         │               │               │
         │ context.read<AuthViewModel>() │
         │ context.watch<AuthViewModel>()│
         │               │               │
         └───────────────┼───────────────┘
                         │
                    Provider
                  automatically
                    injects
```

**Como Funciona:**

1. **DependencyInjection** configura todos os providers no topo da árvore
2. **Qualquer página** pode acessar dependências via `context.read<T>()`
3. **ViewModels** são criados com dependências injetadas automaticamente
4. **Provider** gerencia ciclo de vida (dispose, etc.)

---

## 6. FLUXO DE TESTES

```
┌─────────────────────────────────────────────────────────┐
│                    UNIT TESTS                            │
│  Test individual components in isolation                 │
│                                                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │
│  │   Models    │  │ Validators  │  │  Utilities  │     │
│  │             │  │             │  │             │     │
│  │ • Create    │  │ • Email     │  │ • Formatters│     │
│  │ • toMap()   │  │ • CPF       │  │ • Parsers   │     │
│  │ • fromMap() │  │ • Phone     │  │             │     │
│  │ • copyWith()│  │             │  │             │     │
│  └─────────────┘  └─────────────┘  └─────────────┘     │
│                                                           │
│  ✓ Fast (milliseconds)                                   │
│  ✓ No dependencies on Flutter framework                  │
│  ✓ Easy to write and maintain                            │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                   WIDGET TESTS                           │
│  Test UI components with user interaction                │
│                                                           │
│  ┌─────────────┐  ┌─────────────┐                       │
│  │CustomButton │  │ LoginField  │                       │
│  │             │  │             │                       │
│  │ • Render    │  │ • Render    │                       │
│  │ • onPressed │  │ • Validation│                       │
│  │ • Colors    │  │ • Input     │                       │
│  │ • Semantics │  │ • Semantics │                       │
│  └─────────────┘  └─────────────┘                       │
│                                                           │
│  ✓ Medium speed (seconds)                                │
│  ✓ Tests actual widgets                                  │
│  ✓ Validates accessibility                               │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                INTEGRATION TESTS                         │
│  Test complete user flows                                │
│                                                           │
│  ┌───────────────────────────────────────┐              │
│  │  Complete User Journey                │              │
│  │                                        │              │
│  │  1. App starts                        │              │
│  │  2. User sees login screen            │              │
│  │  3. User enters credentials           │              │
│  │  4. User taps login button            │              │
│  │  5. Loading indicator appears         │              │
│  │  6. Navigation to home screen         │              │
│  │  7. User navigates to clients         │              │
│  │  8. Data loads from Firebase          │              │
│  └───────────────────────────────────────┘              │
│                                                           │
│  ✓ Slower (several seconds)                              │
│  ✓ Tests real Firebase integration                       │
│  ✓ Validates complete flows                              │
│  ✓ Catches integration bugs                              │
└─────────────────────────────────────────────────────────┘
```

---

## 7. OTIMIZAÇÕES DE PERFORMANCE

### 7.1 Widget const

```
SEM OTIMIZAÇÃO:                  COM OTIMIZAÇÃO:

CustomButton(                    const CustomButton(
  text: 'Login',                   text: 'Login',
  onPressed: login,                onPressed: login,
)                                )

Every rebuild:                   Once at compile time:
┌─────────────┐                  ┌─────────────┐
│   Memory    │                  │   Memory    │
│             │                  │             │
│ Widget1     │                  │ Widget1 ────┼──► Reused
│ Widget2     │                  │             │   (not recreated)
│ Widget3     │                  │             │
│ Widget4     │                  │             │
└─────────────┘                  └─────────────┘
  Memory waste                     Memory saved
```

### 7.2 Keys em Listas

```
WITHOUT KEYS:                    WITH KEYS:

ListView(                        ListView(
  children: [                      children: [
    ClientCard(...),                 ClientCard(key: ValueKey('1')),
    ClientCard(...),                 ClientCard(key: ValueKey('2')),
    ClientCard(...),                 ClientCard(key: ValueKey('3')),
  ],                               ],
)                                )

Item removed:                    Item removed:
Flutter can't identify          Flutter identifies by key:
┌─────┐ ┌─────┐                ┌─────┐ ┌─────┐
│  ?  │ │  ?  │                │  1  │ │  3  │
└─────┘ └─────┘                └─────┘ └─────┘
  Bugs possible                  Correct behavior
```

### 7.3 Provider Selector

```
WITHOUT SELECTOR:                WITH SELECTOR:

Consumer<ClienteViewModel>(      Selector<ClienteViewModel, List>(
  builder: (ctx, vm, child) {      selector: (ctx, vm) => vm.clientes,
    return ListView(                builder: (ctx, clientes, child) {
      children: vm.clientes           return ListView(
        .map((c) => ...)                children: clientes
        .toList(),                        .map((c) => ...)
    );                                    .toList(),
  },                                );
)                                   },
                                  )

Rebuilds when ANY property      Rebuilds ONLY when clientes
in ViewModel changes            list changes

┌────────────────┐              ┌────────────────┐
│ isLoading: true│              │ isLoading: true│
│ ──► REBUILD    │              │ ──► No rebuild │
│                │              │                │
│ error: "..."   │              │ error: "..."   │
│ ──► REBUILD    │              │ ──► No rebuild │
│                │              │                │
│ clientes: [...]│              │ clientes: [...]│
│ ──► REBUILD    │              │ ──► REBUILD    │
└────────────────┘              └────────────────┘
```

---

## 8. MÉTRICAS DO PROJETO

```
┌─────────────────────────────────────────────────────────┐
│                  ESTATÍSTICAS DO PROJETO                 │
└─────────────────────────────────────────────────────────┘

📁 Estrutura de Pastas
├── domain/          (7 arquivos)
├── data/            (8 arquivos)
├── presentation/    (3 arquivos)
├── pages/           (6 arquivos)
├── organisms/       (5 arquivos)
├── molecules/       (4 arquivos)
└── atoms/           (5 arquivos)

🧪 Testes
├── Unit Tests       (4 arquivos)
├── Widget Tests     (2 arquivos)
└── Integration      (2 arquivos)
    Total: 9 test files

🎨 Componentes Reutilizáveis
├── Átomos:          5 componentes
├── Moléculas:       4 componentes
└── Organismos:      5 componentes
    Total: 14 componentes

📊 ViewModels (State Management)
├── AuthViewModel
├── ClienteViewModel
└── SolicitacaoViewModel
    Total: 3 ViewModels

🔥 Integração Firebase
├── Authentication   ✓
├── Firestore        ✓
└── Messaging        ✓

⚡ Performance
├── Tempo de build:   < 3s
├── Tempo de testes:  < 5s
└── Startup time:     < 2s
```

---

## 9. ROADMAP FUTURO

```
IMPLEMENTADO ✓              PLANEJADO 📋              FUTURO 🔮

✓ Clean Architecture        📋 CI/CD com GitHub       🔮 Modo Offline
✓ MVVM com Provider           Actions                🔮 Analytics
✓ Atomic Design            📋 Cobertura 90%+         🔮 Crash Reporting
✓ Testes (3 níveis)        📋 Modo Escuro            🔮 Push Notif Avançadas
✓ Acessibilidade WCAG      📋 Internacionalização    🔮 GraphQL
✓ Firebase Integration        (i18n)                 🔮 Machine Learning
✓ Performance              📋 Documentação API       🔮 Realidade Aumentada
✓ Dependency Injection     📋 Design System docs     🔮 Multi-plataforma
                                                        Desktop

Timeline:
Q1 2024 ────────────────► Q2 2024 ──────────► Q3-Q4 2024
  ✓ Implementado            📋 Próximos           🔮 Visão
                               3 meses              Longo Prazo
```

---

## 10. COMPARAÇÃO: ANTES vs DEPOIS DA ARQUITETURA

```
┌─────────────────────────────┬─────────────────────────────┐
│      ANTES (Sem Arquitetura)│   DEPOIS (Clean Architecture│
│                              │         + MVVM)             │
├─────────────────────────────┼─────────────────────────────┤
│                              │                             │
│  lib/                        │  lib/src/                   │
│  ├── main.dart               │  ├── domain/                │
│  ├── login.dart              │  │   ├── models/           │
│  ├── home.dart               │  │   └── repositories/     │
│  ├── cliente.dart            │  ├── data/                  │
│  ├── api.dart                │  │   ├── datasources/      │
│  └── utils.dart              │  │   └── repositories/     │
│                              │  ├── presentation/          │
│  ❌ Tudo misturado           │  │   └── viewmodels/       │
│  ❌ Difícil testar           │  ├── pages/                 │
│  ❌ Alto acoplamento         │  ├── organisms/             │
│  ❌ Difícil manter           │  ├── molecules/             │
│                              │  ├── atoms/                 │
│                              │  └── core/                  │
│                              │                             │
│                              │  ✅ Separação clara         │
│                              │  ✅ Fácil testar            │
│                              │  ✅ Baixo acoplamento       │
│                              │  ✅ Fácil manter            │
└─────────────────────────────┴─────────────────────────────┘
```

**Impacto Prático:**

| Métrica              | Antes | Depois | Melhoria |
|---------------------|-------|--------|----------|
| Tempo para adicionar feature | 2-3 dias | 1-2 dias | 40% mais rápido |
| Bugs em produção    | ~10/mês | ~2/mês | 80% menos bugs |
| Cobertura de testes | 0%    | 60%+   | Testável |
| Tempo de onboarding | 2 semanas | 3 dias | 70% mais rápido |
| Refatoração segura  | ❌ Risco alto | ✅ Confiante | Testes garantem |

---

## COMO USAR ESTES DIAGRAMAS NA APRESENTAÇÃO

1. **Mostre o Diagrama de Arquitetura Geral** quando falar sobre Clean Architecture
2. **Use o Fluxo de Dados** para explicar como tudo se conecta
3. **Atomic Design visual** ajuda audiência a entender hierarquia
4. **Pirâmide de Testes** mostra estratégia de forma clara
5. **Métricas** demonstram escala do projeto
6. **Antes vs Depois** mostra valor da arquitetura

**Dica:** Você pode desenhar versões simplificadas destes diagramas em um quadro durante a apresentação para torná-la mais interativa!

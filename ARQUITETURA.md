# Arquitetura do Projeto MGK

## Diagrama de Camadas (Clean Architecture + MVVM)

```
┌───────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                         │
│                    (Camada de Apresentação)                       │
├───────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                        ViewModels                            │ │
│  │              (ChangeNotifier + Provider)                     │ │
│  ├─────────────────────────────────────────────────────────────┤ │
│  │  • AuthViewModel        → Gerencia autenticação             │ │
│  │  • ClienteViewModel     → Gerencia CRUD de clientes         │ │
│  │  • SolicitacaoViewModel → Gerencia solicitações             │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                              ↓ ↑                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                         UI Widgets                           │ │
│  │                   (Atomic Design Pattern)                    │ │
│  ├─────────────────────────────────────────────────────────────┤ │
│  │  Pages      → Telas completas (HomePage, LoginPage)         │ │
│  │  Templates  → Estruturas de layout reutilizáveis            │ │
│  │  Organisms  → Componentes complexos (Forms, Lists)          │ │
│  │  Molecules  → Componentes médios (LoginField, Cards)        │ │
│  │  Atoms      → Componentes básicos (CustomButton, Input)     │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌───────────────────────────────────────────────────────────────────┐
│                          DOMAIN LAYER                             │
│                       (Camada de Domínio)                         │
│                    [Independente de Frameworks]                   │
├───────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                       Domain Models                          │ │
│  │                  (Entidades de Negócio)                      │ │
│  ├─────────────────────────────────────────────────────────────┤ │
│  │  • ClienteModel      → Representa um cliente                │ │
│  │  • UserModel         → Representa um usuário                │ │
│  │  • SolicitacaoModel  → Representa uma solicitação           │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                              ↓ ↑                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                   Repository Interfaces                      │ │
│  │                    (Contratos Abstratos)                     │ │
│  ├─────────────────────────────────────────────────────────────┤ │
│  │  • AuthRepository        → Interface de autenticação        │ │
│  │  • ClienteRepository     → Interface de clientes            │ │
│  │  • SolicitacaoRepository → Interface de solicitações        │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌───────────────────────────────────────────────────────────────────┐
│                           DATA LAYER                              │
│                       (Camada de Dados)                           │
├───────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                 Repository Implementations                   │ │
│  │              (Implementações Concretas)                      │ │
│  ├─────────────────────────────────────────────────────────────┤ │
│  │  • AuthRepositoryImpl        → Implementa AuthRepository    │ │
│  │  • ClienteRepositoryImpl     → Implementa ClienteRepository │ │
│  │  • SolicitacaoRepositoryImpl → Implementa SolicitacaoRepo   │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                              ↓ ↑                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │                       DataSources                            │ │
│  │              (Comunicação com APIs Externas)                 │ │
│  ├─────────────────────────────────────────────────────────────┤ │
│  │  • AuthDataSource        → Firebase Auth                    │ │
│  │  • ClienteDataSource     → Firestore (clientes)             │ │
│  │  • SolicitacaoDataSource → Firestore (solicitações)         │ │
│  └─────────────────────────────────────────────────────────────┘ │
│                              ↓ ↑                                  │
└───────────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌───────────────────────────────────────────────────────────────────┐
│                      EXTERNAL SERVICES                            │
│                     (Serviços Externos)                           │
├───────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │   Firebase  │  │  Firestore  │  │   Firebase  │              │
│  │     Auth    │  │   Database  │  │   Storage   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

---

## Fluxo de Dados

### 1. Fluxo de Leitura (Query)

```
User Action (Widget)
       ↓
ViewModel (calls repository)
       ↓
Repository Interface
       ↓
Repository Implementation
       ↓
DataSource (Firebase/Firestore)
       ↓
External Service
       ↓
DataSource (receives data)
       ↓
Repository (converts to Model)
       ↓
ViewModel (notifyListeners)
       ↓
Widget (rebuilds with new data)
```

### 2. Fluxo de Escrita (Command)

```
User Input (Widget)
       ↓
ViewModel (validates & calls repository)
       ↓
Repository Interface
       ↓
Repository Implementation
       ↓
DataSource (saves to Firebase/Firestore)
       ↓
External Service
       ↓
Success/Error Response
       ↓
DataSource
       ↓
Repository
       ↓
ViewModel (updates state & notifies)
       ↓
Widget (shows feedback)
```

---

## Dependency Injection Flow

```
main.dart
    ↓
MultiProvider
    ├── Provider<DataSources>
    │   ├── AuthDataSource
    │   ├── ClienteDataSource
    │   └── SolicitacaoDataSource
    │
    ├── Provider<Repositories>
    │   ├── AuthRepository (impl)
    │   ├── ClienteRepository (impl)
    │   └── SolicitacaoRepository (impl)
    │
    └── ChangeNotifierProvider<ViewModels>
        ├── AuthViewModel
        ├── ClienteViewModel
        └── SolicitacaoViewModel
            ↓
        Widgets (access via Provider.of or context.watch)
```

---

## Exemplo Prático: Login Flow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User presses "Login" button                             │
│    LoginPage Widget                                         │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. Widget calls ViewModel                                  │
│    authViewModel.signIn(email, password)                   │
│    AuthViewModel (Presentation Layer)                       │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. ViewModel calls Repository                              │
│    _authRepository.signIn(email, password)                 │
│    AuthRepository Interface (Domain Layer)                  │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. Repository calls DataSource                             │
│    _dataSource.signIn(email, password)                     │
│    AuthDataSource (Data Layer)                             │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. DataSource calls Firebase                               │
│    FirebaseAuth.signInWithEmailAndPassword()               │
│    Firebase Auth (External Service)                        │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. Firebase returns User                                   │
│    UserCredential                                          │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 7. DataSource converts to Domain Model                     │
│    UserModel.fromFirebaseUser()                            │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 8. Repository returns Model to ViewModel                   │
│    return UserModel                                        │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 9. ViewModel updates state                                 │
│    _currentUser = user                                     │
│    notifyListeners()                                       │
└─────────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────────┐
│ 10. Widget rebuilds with new state                         │
│     Consumer<AuthViewModel> rebuilds                       │
│     Navigator.pushNamed('/home')                           │
└─────────────────────────────────────────────────────────────┘
```

---

## Benefícios da Arquitetura

### 1. Separação de Responsabilidades
- **Presentation:** Apenas UI e interação com usuário
- **Domain:** Lógica de negócio pura
- **Data:** Acesso e persistência de dados

### 2. Testabilidade
```
✓ ViewModels → Testar lógica de apresentação (mock repositories)
✓ Repositories → Testar conversão de dados (mock datasources)
✓ DataSources → Testar comunicação com APIs (mock clients)
✓ Models → Testar serialização e validações
✓ Widgets → Testar UI e interações
```

### 3. Manutenibilidade
- Mudanças isoladas em cada camada
- Fácil identificação de bugs
- Código organizado e previsível

### 4. Escalabilidade
- Fácil adição de novas features
- Reutilização de componentes
- Substituição de tecnologias sem afetar outras camadas

### 5. Independência de Frameworks
- Domain Layer não conhece Flutter
- Fácil migração para outras plataformas
- Lógica de negócio reutilizável

---

## Convenções de Nomenclatura

### Models
```
ClienteModel, UserModel, SolicitacaoModel
```

### Repositories (Interface)
```
AuthRepository, ClienteRepository, SolicitacaoRepository
```

### Repositories (Implementation)
```
AuthRepositoryImpl, ClienteRepositoryImpl, SolicitacaoRepositoryImpl
```

### DataSources
```
AuthDataSource, ClienteDataSource, SolicitacaoDataSource
```

### ViewModels
```
AuthViewModel, ClienteViewModel, SolicitacaoViewModel
```

### Widgets
```
HomePage, LoginPage, CustomButton, LoginField
```

---

## Conclusão

Esta arquitetura garante:
- ✅ Código limpo e organizado
- ✅ Fácil manutenção e evolução
- ✅ Alta testabilidade
- ✅ Baixo acoplamento
- ✅ Alta coesão
- ✅ Seguindo princípios SOLID
- ✅ Preparado para crescimento

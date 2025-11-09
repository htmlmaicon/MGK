# MGK - Sistema de Cadastro

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Sistema completo de gerenciamento de clientes desenvolvido com **Flutter**, seguindo princípios de **Clean Architecture**, **MVVM** e **Provider** para gerenciamento de estado.

---

## 🎯 Projeto Integrador - Entrega Parcial 1

### ✅ Requisitos Atendidos

#### 1. Arquitetura
- ✅ **Clean Architecture** implementada
- ✅ **MVVM Pattern** com separação de camadas
- ✅ Camadas: Domain, Data, Presentation
- ✅ Separação clara de responsabilidades

#### 2. Gerenciamento de Estado
- ✅ **Provider** implementado com MultiProvider
- ✅ ViewModels com ChangeNotifier
- ✅ Dependency Injection centralizada
- ✅ Estado reativo e eficiente

#### 3. Testes Automatizados
- ✅ **57 testes** implementados
- ✅ Testes unitários (modelos e validações)
- ✅ Testes de widget (componentes UI)
- ✅ Cobertura de casos críticos

---

## 📚 Documentação

- 📖 [**Documentação Completa do Projeto**](DOCUMENTACAO_PROJETO.md)
- 🏗️ [**Arquitetura Detalhada**](ARQUITETURA.md)
- 🧪 [**Guia de Testes**](GUIA_TESTES.md)
- 🔐 [**Sistema de Permissões**](SISTEMA_PERMISSOES.md)
- 🔥 [**Regras do Firestore**](FIRESTORE_RULES.md)

---

## 🚀 Funcionalidades

### Autenticação e Autorização
- Login com Firebase Authentication
- Sistema de permissões (Admin/Usuário)
- Recuperação de senha
- Solicitações de cadastro com aprovação

### Gerenciamento de Clientes
- CRUD completo de clientes
- Busca e filtros
- Edição inline
- Validação de dados

### Contratos
- Visualização de contratos ativos
- Ativação/desativação de contratos
- Histórico de alterações

### Interface
- **Atomic Design**: Componentes reutilizáveis
- **Responsive**: Adaptável a diferentes telas
- **Acessibilidade**: Suporte a leitores de tela
- **Microinterações**: Feedback visual

---

## 🏗️ Arquitetura

### Camadas

```
┌─────────────────────────────────────────┐
│       PRESENTATION LAYER                │
│  • ViewModels (ChangeNotifier)          │
│  • Widgets (Atomic Design)              │
└─────────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────────┐
│          DOMAIN LAYER                   │
│  • Models (Entities)                    │
│  • Repository Interfaces                │
└─────────────────────────────────────────┘
              ↓ ↑
┌─────────────────────────────────────────┐
│           DATA LAYER                    │
│  • Repository Implementations           │
│  • DataSources (Firebase)               │
└─────────────────────────────────────────┘
```

### Padrões Implementados

- ✅ **Clean Architecture**
- ✅ **MVVM (Model-View-ViewModel)**
- ✅ **Repository Pattern**
- ✅ **Dependency Injection**
- ✅ **Atomic Design**
- ✅ **SOLID Principles**

---

## 🛠️ Tecnologias

### Core
- **Flutter** 3.8.1
- **Dart** 3.8.1

### State Management
- **Provider** 6.1.5+1

### Backend
- **Firebase Core** 4.2.1
- **Firebase Auth** 6.1.2
- **Cloud Firestore** 6.1.0

### Testing
- **flutter_test**
- 57 testes automatizados

---

## 📦 Como Executar

### Pré-requisitos

```bash
Flutter SDK: 3.8.1+
Dart SDK: 3.8.1+
Android Studio / VS Code
```

### Instalação

```powershell
# 1. Clone o repositório
git clone https://github.com/htmlmaicon/MGK.git
cd MGK

# 2. Instale as dependências
flutter pub get

# 3. Configure o Firebase
flutterfire configure

# 4. Execute os testes
flutter test

# 5. Execute a aplicação
flutter run
```

### Credenciais de Teste

**Administrador:**
- Email: `admin@gmail.com`
- Senha: (configurada no Firebase)

---

## 🧪 Testes

### Executar Todos os Testes

```powershell
flutter test
```

### Testes por Tipo

```powershell
# Testes Unitários
flutter test test/unit/

# Testes de Widget
flutter test test/widget/

# Com cobertura
flutter test --coverage
```

### Resultados

- ✅ **40 testes unitários**
- ✅ **17 testes de widget**
- ✅ **Total: 57 testes**

Veja o [Guia de Testes](GUIA_TESTES.md) para mais detalhes.

---

## 📁 Estrutura do Projeto

```
lib/
├── main.dart                    # Entry point
├── src/
│   ├── core/                    # DI e configurações
│   ├── domain/                  # Camada de domínio
│   │   ├── models/              # Entidades
│   │   └── repositories/        # Interfaces
│   ├── data/                    # Camada de dados
│   │   ├── datasources/         # Firebase
│   │   └── repositories/        # Implementações
│   ├── presentation/            # Camada de apresentação
│   │   └── viewmodels/          # ViewModels
│   ├── pages/                   # Telas
│   ├── templates/               # Layouts
│   ├── organisms/               # Componentes complexos
│   ├── molecules/               # Componentes médios
│   ├── atoms/                   # Componentes básicos
│   └── utils/                   # Utilitários

test/
├── unit/                        # Testes unitários
└── widget/                      # Testes de widget
```

---

## 🎨 Atomic Design

### Atoms (Componentes Básicos)
- CustomButton
- CustomInput

### Molecules (Componentes Médios)
- LoginField
- Cards

### Organisms (Componentes Complexos)
- RegisterForm
- ClientsList
- SolicitationsList

### Templates
- LoginTemplate
- RegisterTemplate
- ClientsTemplate

### Pages (Telas Completas)
- HomePage
- LoginPage
- CadastroClientePage

---

## 🔐 Sistema de Permissões

### Administrador
- ✅ Criar/Editar/Remover clientes
- ✅ Aprovar/Rejeitar solicitações
- ✅ Gerenciar contratos
- ✅ Visualizar todos os dados

### Usuário
- ✅ Visualizar clientes
- ✅ Ativar/Desativar contratos
- ❌ Criar/Editar clientes
- ❌ Aprovar solicitações

---

## 📊 Métricas do Projeto

- **Linhas de Código:** ~5000+
- **Arquivos Dart:** 50+
- **Testes:** 57
- **Modelos de Domínio:** 3
- **ViewModels:** 3
- **Repositories:** 3
- **DataSources:** 3

---

## 🚧 Próximos Passos

- [ ] Testes de integração
- [ ] CI/CD pipeline
- [ ] Offline-first com sincronização
- [ ] Analytics e crash reporting
- [ ] Internacionalização (i18n)
- [ ] Dark mode

---

## 👥 Equipe

**MGK Development Team**

---

## 📄 Licença

Este projeto está sob a licença MIT.

---

## 📞 Contato

Para dúvidas ou sugestões, entre em contato através do GitHub.

---

**Desenvolvido com ❤️ usando Flutter e Clean Architecture**

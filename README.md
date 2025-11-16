# MGK - Sistema de Cadastro

Sistema de gerenciamento de clientes com funcionalidades de cadastro e consulta, desenvolvido com arquitetura limpa e padrões modernos de Flutter.

## 📚 Documentação de Apresentação

Para apresentação dos aspectos técnicos e decisões de design, consulte:

- **[README_APRESENTACAO.md](./README_APRESENTACAO.md)** - 🎯 **COMECE AQUI** - Guia completo de uso da documentação
- **[ROTEIRO_APRESENTACAO.md](./ROTEIRO_APRESENTACAO.md)** - ⏱️ Roteiro passo a passo (5-7 min)
- **[APRESENTACAO_ASPECTOS_TECNICOS.md](./APRESENTACAO_ASPECTOS_TECNICOS.md)** - 📖 Material técnico completo
- **[DIAGRAMAS_ARQUITETURA.md](./DIAGRAMAS_ARQUITETURA.md)** - 📊 Diagramas visuais e fluxos
- **[COLA_RAPIDA.md](./COLA_RAPIDA.md)** - ⚡ Referência rápida para apresentações

## 🏗️ Arquitetura

O projeto implementa **Clean Architecture** combinada com **MVVM** (Model-View-ViewModel):

```
lib/src/
├── domain/           # Camada de Domínio (Entidades e Contratos)
│   ├── models/      # ClienteModel, UserModel, SolicitacaoModel
│   └── repositories/# Interfaces dos repositórios
├── data/            # Camada de Dados (Implementações)
│   ├── datasources/ # Firebase, APIs
│   └── repositories/# Implementação dos contratos
├── presentation/    # Camada de Apresentação (MVVM)
│   └── viewmodels/  # ViewModels com ChangeNotifier
├── pages/           # Views (UI)
├── organisms/       # Atomic Design - Componentes complexos
├── molecules/       # Atomic Design - Componentes médios
├── atoms/           # Atomic Design - Componentes básicos
└── core/            # Serviços e Dependency Injection
```

### Benefícios da Arquitetura:
- ✅ **Modularidade**: Cada camada tem responsabilidade única
- ✅ **Testabilidade**: 9 arquivos de teste (Unit, Widget, Integration)
- ✅ **Manutenibilidade**: Código organizado e fácil de navegar
- ✅ **Escalabilidade**: Fácil adicionar novas funcionalidades

## 🧪 Testes

O projeto possui cobertura de testes em 3 níveis:

- **Testes Unitários** (4 arquivos): Models, validators, utilities
- **Testes de Widget** (2 arquivos): Componentes UI e acessibilidade
- **Testes de Integração** (2 arquivos): Fluxos completos e Firebase

```bash
# Executar todos os testes
flutter test

# Executar apenas testes unitários
flutter test test/unit/

# Executar apenas testes de widget
flutter test test/widget/
```

## 🎨 Funcionalidades Implementadas

### UI/UX
- **Atomic Design**: 15+ componentes organizados em átomos, moléculas e organismos
- **Microinterações**: Feedback visual com InkWell ripple effects
- **Acessibilidade WCAG**: Semantics em todos os componentes interativos
- **Design System**: Tema consistente com Material Design

### Consumo de API
- **Firebase**: Authentication, Firestore, Cloud Messaging
- **ViaCEP**: Integração para busca automática de endereços
- **JSONPlaceholder**: Consumo de API pública para exibição de posts
- **FutureBuilder**: Tratamento de estados assíncronos (carregando, erro, dados)

### Formulários e Validação
- Formulário completo com validação em todos os campos
- Validação customizada com mensagens de erro específicas
- Máscaras de entrada para CPF, telefone, CEP
- Campos para diferentes tipos de clientes (Agricultor, Assalariado, Aposentado/Pensionista)

### Gerenciamento de Estado
- **Provider**: Dependency Injection e state management
- **ViewModels**: ChangeNotifier para notificação de mudanças
- **Streams**: Dados em tempo real do Firebase

## 🚀 Tecnologias Utilizadas

- **Flutter SDK** (3.8.1)
- **Firebase** (Auth, Firestore, Messaging)
- **Provider** (State Management + DI)
- **HTTP** para consumo de APIs RESTful
- **SQLite** (sqflite) para persistência local
- **Material Design**

## 📊 Métricas do Projeto

- ✓ **9 arquivos** de teste
- ✓ **15+ componentes** reutilizáveis
- ✓ **3 ViewModels** com ChangeNotifier
- ✓ **6 páginas** funcionais
- ✓ **< 3 segundos** de build (testado)
- ✓ **10 pastas** estruturadas
- ✓ **100%** acessibilidade com Semantics

## 💻 Como executar

### Pré-requisitos
- Flutter SDK 3.8.1 ou superior
- Dart 3.8.1 ou superior
- Firebase configurado (arquivo `firebase_options.dart`)

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/htmlmaicon/MGK.git
cd MGK
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure o Firebase (se necessário):
```bash
flutterfire configure
```

4. Execute o aplicativo:
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 🧪 Executar Testes

```bash
# Todos os testes
flutter test

# Com cobertura
flutter test --coverage

# Testes específicos
flutter test test/unit/
flutter test test/widget/
flutter test test/integration_test/
```

## 📁 Estrutura do Projeto

```
MGK/
├── lib/
│   ├── main.dart                    # Ponto de entrada
│   ├── firebase_options.dart        # Configuração Firebase
│   └── src/
│       ├── atoms/                   # Componentes básicos
│       ├── molecules/               # Componentes compostos
│       ├── organisms/               # Componentes complexos
│       ├── pages/                   # Telas da aplicação
│       ├── domain/                  # Modelos e contratos
│       ├── data/                    # Implementações
│       ├── presentation/            # ViewModels
│       ├── core/                    # DI e serviços
│       └── utils/                   # Utilitários
├── test/
│   ├── unit/                        # Testes unitários
│   ├── widget/                      # Testes de widget
│   └── integration_test/            # Testes de integração
├── APRESENTACAO_ASPECTOS_TECNICOS.md
├── ROTEIRO_APRESENTACAO.md
├── DIAGRAMAS_ARQUITETURA.md
├── COLA_RAPIDA.md
└── README_APRESENTACAO.md
```
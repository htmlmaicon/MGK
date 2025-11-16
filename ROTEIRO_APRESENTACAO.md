# 🎥 Roteiro de Apresentação - MGK Sistema de Cadastro
## Aspectos Técnicos e Decisões de Design (10 minutos)

---

## 📋 ESTRUTURA DA APRESENTAÇÃO

### ⏰ Cronograma Sugerido
- **Introdução (30 seg)**: Apresentação do projeto
- **Arquitetura (2 min)**: MVVM + Clean Architecture + DDD
- **Testes (2 min)**: Unitários, Widget e Integração
- **UI/UX (2 min)**: Atomic Design + Acessibilidade
- **Otimização (2 min)**: Performance e boas práticas
- **Demonstração (1 min)**: Execução dos testes
- **Conclusão (30 seg)**: Resultados e aprendizados

---

## 🎬 ROTEIRO DETALHADO

### 1. INTRODUÇÃO (30 segundos)

**[TELA: Mostrar o README ou estrutura do projeto]**

**Fala:**
> "Olá! Vou apresentar os aspectos técnicos do MGK, um sistema de gerenciamento de clientes desenvolvido em Flutter. Vamos explorar a arquitetura, estratégias de teste, design de UI/UX e otimizações de performance implementadas."

---

### 2. ARQUITETURA DA APLICAÇÃO (2 minutos)

**[TELA: Mostrar estrutura de pastas `lib/src/`]**

#### 2.1 Visão Geral da Arquitetura (45 segundos)

**Fala:**
> "O projeto implementa uma arquitetura híbrida que combina MVVM, Clean Architecture e conceitos de DDD. Vamos ver cada camada:"

**[MOSTRAR: Estrutura de pastas no terminal ou IDE]**

```bash
lib/src/
├── domain/          # Camada de Domínio (Entidades, Repositórios)
├── data/            # Camada de Dados (Implementações, DataSources)
├── presentation/    # Camada de Apresentação (ViewModels)
├── pages/           # Páginas da aplicação
├── templates/       # Templates (Atomic Design)
├── organisms/       # Organismos (Atomic Design)
├── molecules/       # Moléculas (Atomic Design)
├── atoms/           # Átomos (Atomic Design)
└── core/            # Injeção de Dependências e Serviços
```

#### 2.2 Clean Architecture (45 segundos)

**Fala:**
> "A Clean Architecture garante separação de responsabilidades em três camadas principais:"

**[MOSTRAR: Arquivo `auth_repository.dart` da camada domain]**

**Pontos a destacar:**
- **Domain**: Regras de negócio puras (interfaces de repositórios, modelos)
- **Data**: Implementações concretas (Firebase, APIs, Banco local)
- **Presentation**: ViewModels com ChangeNotifier para gerenciar estado

**[MOSTRAR: Arquivo `auth_viewmodel.dart`]**

**Fala:**
> "Os ViewModels seguem o padrão MVVM, usando ChangeNotifier para notificar mudanças de estado. Por exemplo, o AuthViewModel gerencia autenticação, mantendo o estado do usuário logado."

#### 2.3 Injeção de Dependências (30 segundos)

**[MOSTRAR: Arquivo `dependency_injection.dart`]**

**Fala:**
> "Utilizamos Provider para injeção de dependências, centralizando a criação de DataSources, Repositories e ViewModels. Isso facilita testes e manutenção."

**Código a destacar:**
```dart
// Exemplo de configuração
Provider<AuthRepository>(
  create: (context) => AuthRepositoryImpl(
    dataSource: context.read<AuthDataSource>()
  ),
)
```

---

### 3. ESTRATÉGIA DE TESTES (2 minutos)

**[TELA: Mostrar estrutura da pasta `test/`]**

#### 3.1 Tipos de Testes (30 segundos)

**Fala:**
> "Implementamos três níveis de testes para garantir qualidade do código:"

**[MOSTRAR: Estrutura de testes]**

```bash
test/
├── unit/              # Testes Unitários (modelos, validações)
├── widget/            # Testes de Widget (componentes UI)
└── integration_test/  # Testes de Integração (fluxos completos)
```

#### 3.2 Testes Unitários (30 segundos)

**[MOSTRAR: Arquivo `cliente_model_test.dart`]**

**Fala:**
> "Testes unitários validam lógica de negócio isolada. Por exemplo, testamos serialização, deserialização e métodos dos modelos."

**Código a destacar:**
```dart
test('Deve criar ClienteModel corretamente', () {
  final cliente = ClienteModel(
    id: '1',
    nome: 'João Silva',
    cpf: '12345678900',
    // ...
  );
  expect(cliente.id, '1');
  expect(cliente.nome, 'João Silva');
});
```

#### 3.3 Testes de Widget (30 segundos)

**[MOSTRAR: Arquivo `custom_button_test.dart`]**

**Fala:**
> "Testes de Widget verificam comportamento e renderização de componentes. Validamos interações, estados e acessibilidade."

**Código a destacar:**
```dart
testWidgets('Deve executar callback ao ser pressionado', (tester) async {
  bool wasPressed = false;
  await tester.pumpWidget(
    MaterialApp(
      home: CustomButton(
        text: 'Clique',
        onPressed: () => wasPressed = true,
      ),
    ),
  );
  await tester.tap(find.byType(CustomButton));
  expect(wasPressed, true);
});
```

#### 3.4 Testes de Integração (30 segundos)

**[MOSTRAR: Arquivo `app_integration_test_simple.dart`]**

**Fala:**
> "Testes de integração verificam fluxos completos da aplicação, incluindo navegação e interação com Firebase. Validamos desde o login até operações CRUD."

**Destacar:**
- Teste de validação de formulário
- Teste de loading durante autenticação
- Teste de performance (tempo de carregamento)

---

### 4. UI/UX POLIDA E ACESSÍVEL (2 minutos)

#### 4.1 Atomic Design (45 segundos)

**[TELA: Mostrar estrutura atoms → molecules → organisms]**

**Fala:**
> "Aplicamos Atomic Design para componentização progressiva:"

**[MOSTRAR arquivos de exemplo de cada nível]**

- **Átomos**: Componentes básicos reutilizáveis
  - `custom_button.dart` - Botão customizável
  - `custom_input.dart` - Campo de entrada
  - `custom_text.dart` - Texto estilizado

**[MOSTRAR: `custom_button.dart`]**

- **Moléculas**: Combinação de átomos
  - `cep_field.dart` - Campo CEP com botão de busca
  - `login_field.dart` - Campo de login com validação

**[MOSTRAR: `cep_field.dart`]**

- **Organismos**: Componentes complexos
  - `login_form.dart` - Formulário completo de login
  - `client_form.dart` - Formulário de cadastro

**[MOSTRAR: `login_form.dart`]**

#### 4.2 Microinterações e Animações (30 segundos)

**Fala:**
> "Implementamos microinterações para feedback visual:"

**[MOSTRAR no código ou executando o app]**

**Pontos a destacar:**
```dart
// Exemplo de InkWell com splash
InkWell(
  onTap: onPressed,
  borderRadius: borderRadius,
  splashColor: Colors.green[100]?.withOpacity(0.5),
  // ...
)

// Loading durante operações assíncronas
_loading ? const CircularProgressIndicator() : CustomButton(...)

// Estados de erro com feedback visual
if (error != null)
  Padding(
    padding: const EdgeInsets.only(left: 12, top: 4),
    child: Text(error!, style: TextStyle(color: Colors.red)),
  )
```

#### 4.3 Acessibilidade (WCAG) (45 segundos)

**[MOSTRAR: Implementação de Semantics no `custom_button.dart`]**

**Fala:**
> "Priorizamos acessibilidade seguindo diretrizes WCAG:"

**Código a destacar:**
```dart
Semantics(
  button: true,
  label: "Botão $text",
  child: InkWell(
    // Implementação do botão
  ),
)
```

**Pontos implementados:**
- ✅ **Semantics**: Labels descritivos para leitores de tela
- ✅ **Contraste**: Cores com contraste adequado (verde e branco)
- ✅ **Tamanhos**: Áreas de toque adequadas (padding mínimo 40px)
- ✅ **Feedback**: Indicadores visuais para todas as ações
- ✅ **Navegação**: Ordem lógica de foco entre elementos

---

### 5. OTIMIZAÇÃO E PERFORMANCE (2 minutos)

#### 5.1 Uso de Const e Keys (45 segundos)

**Fala:**
> "Aplicamos otimizações do Flutter para melhor performance:"

**[MOSTRAR exemplos no código]**

**Pontos a destacar:**
```dart
// 1. Uso de const para widgets imutáveis
const CustomButton({super.key, required this.text, ...})

const EdgeInsets.symmetric(horizontal: 40, vertical: 20)
const BorderRadius.all(Radius.circular(15))

// 2. Keys para identificação de widgets
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,  // Key para otimizar rebuild
    // ...
  });
}

// 3. Widgets const sempre que possível
const SizedBox(height: 16)
const Icon(Icons.search, color: Colors.green)
```

#### 5.2 Lazy Loading e Otimizações Assíncronas (45 segundos)

**Fala:**
> "Implementamos estratégias para operações assíncronas eficientes:"

**[MOSTRAR exemplo de FutureBuilder ou StreamBuilder]**

**Pontos a destacar:**
```dart
// FutureBuilder para carregar dados sob demanda
FutureBuilder(
  future: _carregarClientes(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    // ...
  },
)

// StreamBuilder para dados em tempo real (Firebase)
StreamBuilder<UserModel?>(
  stream: authStateChanges,
  builder: (context, snapshot) {
    // Atualiza UI automaticamente
  },
)
```

#### 5.3 Estratégias de Build (30 segundos)

**Fala:**
> "Otimizamos o processo de build e identificação de gargalos:"

**[PODE MOSTRAR: Terminal ou mencionar]**

**Práticas implementadas:**
```bash
# 1. Build otimizado para release
flutter build apk --release --split-per-abi

# 2. Análise de performance com DevTools
flutter run --profile
# Depois abrir DevTools para análise

# 3. Análise estática do código
flutter analyze

# 4. Testes de performance nos integration tests
testWidgets('Aplicação deve carregar em tempo razoável', (tester) async {
  final stopwatch = Stopwatch()..start();
  app.main();
  await tester.pumpAndSettle(const Duration(seconds: 5));
  stopwatch.stop();
  expect(stopwatch.elapsedMilliseconds, lessThan(15000));
});
```

---

### 6. DEMONSTRAÇÃO PRÁTICA (1 minuto)

**[TELA: Terminal ou IDE]**

**Fala:**
> "Vamos executar os testes para demonstrar a qualidade do código:"

**[EXECUTAR os comandos abaixo (se Flutter disponível)]**

```bash
# Testes unitários
flutter test test/unit/

# Testes de widget
flutter test test/widget/

# Relatório de cobertura
flutter test --coverage
```

**OU se não puder executar:**

**Fala:**
> "Nossos testes cobrem modelos, widgets e fluxos completos da aplicação, garantindo que cada mudança seja validada antes de ir para produção."

**[MOSTRAR: Arquivo de teste ou estrutura]**

---

### 7. CONCLUSÃO (30 segundos)

**[TELA: Resumo visual ou código do projeto]**

**Fala:**
> "Em resumo, o projeto MGK implementa:
> 
> ✅ **Arquitetura robusta**: MVVM + Clean Architecture para código manutenível
> 
> ✅ **Testes abrangentes**: Unitários, Widget e Integração garantindo qualidade
> 
> ✅ **UI/UX profissional**: Atomic Design com acessibilidade WCAG
> 
> ✅ **Performance otimizada**: Uso de const, keys e boas práticas Flutter
> 
> Essa estrutura facilita manutenção, escalabilidade e garante uma experiência de usuário de alta qualidade. Obrigado!"

---

## 📝 CHECKLIST PARA GRAVAÇÃO

### Antes de gravar:
- [ ] Abrir o projeto no VS Code ou IDE preferida
- [ ] Preparar terminal para executar comandos
- [ ] Ter os arquivos-chave abertos em abas:
  - [ ] `lib/src/` (estrutura de pastas)
  - [ ] `auth_viewmodel.dart`
  - [ ] `dependency_injection.dart`
  - [ ] `cliente_model_test.dart`
  - [ ] `custom_button_test.dart`
  - [ ] `app_integration_test_simple.dart`
  - [ ] `custom_button.dart` (com Semantics)
  - [ ] `cep_field.dart`
- [ ] Testar execução de testes (se possível)

### Durante a gravação:
- [ ] Falar de forma clara e pausada
- [ ] Mostrar código enquanto explica
- [ ] Navegar entre arquivos para ilustrar conceitos
- [ ] Destacar pontos-chave no código
- [ ] Manter ritmo constante (não muito rápido)

### Dicas técnicas:
- [ ] Aumentar tamanho da fonte no IDE (Ctrl/Cmd + +)
- [ ] Usar zoom ou highlight no código importante
- [ ] Gravar em resolução mínima 1080p
- [ ] Testar áudio antes de começar
- [ ] Fazer pausas naturais entre seções

---

## 🎯 PONTOS-CHAVE A ENFATIZAR

### Arquitetura:
- **Separação de responsabilidades** em camadas
- **Testabilidade** através de interfaces
- **Manutenibilidade** com código organizado
- **Escalabilidade** com estrutura modular

### Testes:
- **Pirâmide de testes** (mais unitários, menos integração)
- **Cobertura** de casos críticos
- **TDD implícito** na estrutura de testes
- **Automação** da validação de qualidade

### UI/UX:
- **Componentização** progressiva (Atomic Design)
- **Reutilização** de componentes
- **Acessibilidade** como prioridade
- **Feedback visual** constante ao usuário

### Performance:
- **Otimização de builds** com const
- **Identificação de gargalos** com testes de performance
- **Lazy loading** para dados assíncronos
- **Boas práticas Flutter** em todo o código

---

## 📚 REFERÊNCIAS RÁPIDAS

### Arquivos principais a mostrar:
1. `/lib/src/presentation/viewmodels/auth_viewmodel.dart` - MVVM
2. `/lib/src/domain/repositories/auth_repository.dart` - Clean Architecture
3. `/lib/src/core/dependency_injection.dart` - DI
4. `/test/unit/models/cliente_model_test.dart` - Teste Unitário
5. `/test/widget/custom_button_test.dart` - Teste Widget
6. `/test/integration_test/app_integration_test_simple.dart` - Teste Integração
7. `/lib/src/atoms/custom_button.dart` - Atomic Design + Acessibilidade
8. `/lib/src/molecules/cep_field.dart` - Atomic Design
9. `/lib/src/organisms/login_form.dart` - Atomic Design

### Comandos úteis:
```bash
# Estrutura do projeto
tree -L 3 lib/src/

# Executar testes
flutter test

# Análise estática
flutter analyze

# Build otimizado
flutter build apk --release
```

---

## ⏱️ CONTROLE DE TEMPO

| Seção | Tempo Planejado | Tempo Real |
|-------|----------------|------------|
| Introdução | 30s | ___ |
| Arquitetura | 2min | ___ |
| Testes | 2min | ___ |
| UI/UX | 2min | ___ |
| Otimização | 2min | ___ |
| Demonstração | 1min | ___ |
| Conclusão | 30s | ___ |
| **TOTAL** | **10min** | ___ |

---

## 💡 DICAS FINAIS

1. **Pratique antes**: Grave um teste para ajustar tempo e fluidez
2. **Prepare o ambiente**: Feche abas desnecessárias, desative notificações
3. **Mostre código**: Não apenas fale, mostre os exemplos no código
4. **Seja confiante**: Você conhece o projeto, demonstre isso
5. **Respire**: Faça pausas naturais entre seções
6. **Seja autêntico**: Use suas próprias palavras, este roteiro é um guia

**BOA SORTE NA GRAVAÇÃO! 🎬✨**

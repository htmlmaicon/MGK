# Roteiro de Apresentação - Aspectos Técnicos MGK
## Guia Passo a Passo (5-7 minutos)

---

## 🎯 OBJETIVO
Apresentar os aspectos técnicos e decisões de design do sistema MGK, demonstrando domínio de arquitetura, testes, UI/UX e performance.

---

## ⏱️ GESTÃO DO TEMPO

| Tópico | Duração | Minutos Acumulados |
|--------|---------|-------------------|
| Introdução | 0:30 | 0:30 |
| Arquitetura | 2:00 | 2:30 |
| Testes | 1:30 | 4:00 |
| UI/UX | 1:30 | 5:30 |
| Performance | 1:00 | 6:30 |
| Conclusão | 0:30 | 7:00 |

---

## 📋 CHECKLIST PRÉ-APRESENTAÇÃO

### Preparação Técnica
- [ ] Abrir IDE com o projeto MGK
- [ ] Abrir arquivo `APRESENTACAO_ASPECTOS_TECNICOS.md`
- [ ] Terminal pronto para executar comandos
- [ ] Navegador com DevTools aberto (opcional)
- [ ] Testar conexão (se apresentação online)

### Arquivos para Mostrar Durante Apresentação
- [ ] `lib/src/core/dependency_injection.dart`
- [ ] `lib/src/domain/models/cliente_model.dart`
- [ ] `lib/src/presentation/viewmodels/cliente_viewmodel.dart`
- [ ] `test/unit/models/cliente_model_test.dart`
- [ ] `test/widget/custom_button_test.dart`
- [ ] `lib/src/atoms/custom_button.dart`

### Comandos para Demonstração
```bash
# Comando 1: Mostrar estrutura do projeto
tree lib/src -L 2

# Comando 2: Executar testes unitários
flutter test test/unit/ --coverage

# Comando 3: Executar testes de widget
flutter test test/widget/

# Comando 4: Executar todos os testes
flutter test
```

---

## 🎤 ROTEIRO DETALHADO

### [0:00 - 0:30] INTRODUÇÃO (30 segundos)

**O QUE DIZER:**

> "Bom dia/tarde! Vou apresentar os aspectos técnicos e decisões de design do sistema MGK, um aplicativo de gerenciamento de clientes desenvolvido em Flutter. Vamos cobrir quatro pontos principais: Arquitetura, Estratégia de Testes, UI/UX, e Performance."

**O QUE MOSTRAR:**
- Slide de título ou README do projeto
- Visão geral rápida da aplicação rodando (opcional)

**TRANSIÇÃO:**
> "Vamos começar pela arquitetura escolhida."

---

### [0:30 - 2:30] 1. ARQUITETURA DA APLICAÇÃO (2 minutos)

#### [0:30 - 1:00] Clean Architecture + MVVM (30 segundos)

**O QUE DIZER:**

> "Implementamos uma arquitetura que combina **Clean Architecture** com **MVVM**. Isso nos dá separação clara de responsabilidades e alta testabilidade."

**O QUE MOSTRAR:**
- Mostrar estrutura de pastas no IDE:
```
lib/src/
├── domain/      ← Entidades e contratos
├── data/        ← Implementações
├── presentation/← ViewModels
├── pages/       ← UI
├── atoms/       ← Atomic Design
├── molecules/
└── organisms/
```

**PONTOS-CHAVE:**
- ✅ "Domain não tem dependências externas - camada mais pura"
- ✅ "Data implementa contratos definidos no Domain"
- ✅ "Presentation gerencia estado com ViewModels"
- ✅ "Pages apenas renderizam, sem lógica de negócio"

#### [1:00 - 1:45] Divisão de Responsabilidades (45 segundos)

**O QUE DIZER:**

> "Vou mostrar um exemplo concreto dessa separação com o ClienteModel."

**O QUE MOSTRAR:**

1. **Abrir `lib/src/domain/models/cliente_model.dart`:**
```dart
class ClienteModel {
  final String nome;
  final String cpf;
  // ... entidade pura, sem dependências
}
```
Dizer: "Entidade de domínio pura, sem dependências do Flutter ou Firebase"

2. **Abrir `lib/src/domain/repositories/cliente_repository.dart`:**
```dart
abstract class ClienteRepository {
  Future<List<ClienteModel>> getAll();
  // ... apenas contrato
}
```
Dizer: "Interface que define o contrato - não sabemos de onde vêm os dados"

3. **Abrir `lib/src/data/repositories/cliente_repository_impl.dart`:**
Dizer: "Implementação concreta que busca dados do Firebase"

4. **Abrir `lib/src/presentation/viewmodels/cliente_viewmodel.dart`:**
```dart
class ClienteViewModel extends ChangeNotifier {
  final ClienteRepository _clienteRepository;
  // ... gerencia estado
}
```
Dizer: "ViewModel comunica com repository através da interface, usa ChangeNotifier para notificar mudanças"

#### [1:45 - 2:30] Dependency Injection (45 segundos)

**O QUE DIZER:**

> "Para conectar tudo, usamos **Dependency Injection** com Provider."

**O QUE MOSTRAR:**

Abrir `lib/src/core/dependency_injection.dart`:
```dart
class DependencyInjection {
  static List<Provider> get providers => [
    Provider<AuthDataSource>(...),
    Provider<AuthRepository>(...),
  ];
  
  static List<ChangeNotifierProvider> get changeNotifierProviders => [
    ChangeNotifierProvider<AuthViewModel>(...),
  ];
}
```

**PONTOS-CHAVE:**
- ✅ "Configuração centralizada de todas as dependências"
- ✅ "Facilita testes com mocks"
- ✅ "Provider gerencia ciclo de vida automaticamente"

**TRANSIÇÃO:**
> "Com essa arquitetura sólida, conseguimos testar cada camada isoladamente. Vamos falar sobre os testes."

---

### [2:30 - 4:00] 2. ESTRATÉGIA DE TESTES (1:30 minutos)

#### [2:30 - 3:00] Pirâmide de Testes (30 segundos)

**O QUE DIZER:**

> "Seguimos a **pirâmide de testes**: muitos testes unitários na base, alguns testes de widget no meio, e poucos testes de integração no topo. Temos **9 arquivos de teste** cobrindo três níveis."

**O QUE MOSTRAR:**

Mostrar estrutura de testes:
```
test/
├── unit/           (4 arquivos) ← Base da pirâmide
├── widget/         (2 arquivos) ← Meio
└── integration_test/ (2 arquivos) ← Topo
```

**PONTOS-CHAVE:**
- ✅ "Testes unitários: rápidos, testam lógica isolada"
- ✅ "Testes de widget: validam componentes UI"
- ✅ "Testes de integração: fluxos completos"

#### [3:00 - 3:30] Demonstração de Testes (30 segundos)

**O QUE DIZER:**

> "Vou mostrar um exemplo de teste unitário e executar os testes."

**O QUE MOSTRAR:**

1. **Abrir `test/unit/models/cliente_model_test.dart`:**
```dart
test('Deve criar ClienteModel corretamente', () {
  // Arrange, Act, Assert pattern
  final cliente = ClienteModel(...);
  expect(cliente.nome, 'João Silva');
});
```
Dizer: "Testes unitários validam lógica de negócio isoladamente"

2. **Executar testes no terminal:**
```bash
flutter test test/unit/
```
Dizer: "Todos os testes unitários passam em milissegundos"

#### [3:30 - 4:00] Cobertura e Qualidade (30 segundos)

**O QUE DIZER:**

> "Os testes garantem qualidade de duas formas principais:"

**PONTOS-CHAVE:**
- ✅ "**Durante refatorações:** testes impedem que quebremos funcionalidades existentes"
- ✅ "**Durante novas features:** testes existentes previnem regressões"
- ✅ "Usamos **TDD** em componentes críticos: Red, Green, Refactor"

**O QUE MOSTRAR:**

Abrir `test/widget/custom_button_test.dart` rapidamente:
```dart
testWidgets('Deve ter semântica apropriada', (tester) async {
  // Teste de acessibilidade
  expect(semantics.properties.button, isTrue);
});
```
Dizer: "Até acessibilidade é testada automaticamente"

**TRANSIÇÃO:**
> "Falando em acessibilidade, vamos ver as decisões de UI/UX."

---

### [4:00 - 5:30] 3. UI/UX POLIDA E ACESSÍVEL (1:30 minutos)

#### [4:00 - 4:45] Atomic Design (45 segundos)

**O QUE DIZER:**

> "Organizamos componentes usando **Atomic Design**: átomos, moléculas e organismos. Isso promove máxima reutilização."

**O QUE MOSTRAR:**

Mostrar hierarquia no IDE:
```
lib/src/
├── atoms/      ← CustomButton, CustomInput (básicos)
├── molecules/  ← LoginField, CepField (compostos)
└── organisms/  ← LoginForm, ClientForm (complexos)
```

**EXEMPLO PRÁTICO:**

Abrir `lib/src/atoms/custom_button.dart`:
```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  // ... altamente reutilizável
}
```

**PONTOS-CHAVE:**
- ✅ "Átomos são componentes básicos e reutilizáveis"
- ✅ "Moléculas combinam átomos"
- ✅ "Organismos são features completas"
- ✅ "Isso garante consistência visual em toda aplicação"

#### [4:45 - 5:15] Acessibilidade WCAG (30 segundos)

**O QUE DIZER:**

> "Implementamos **acessibilidade** desde o início, seguindo diretrizes **WCAG**."

**O QUE MOSTRAR:**

No mesmo arquivo `custom_button.dart`:
```dart
Semantics(
  button: true,
  label: "Botão $text",
  child: InkWell(
    splashColor: Colors.green[100]?.withOpacity(0.5),
    // ...
  ),
)
```

**PONTOS-CHAVE:**
- ✅ "**Semantics** em todos os componentes interativos"
- ✅ "Compatível com **leitores de tela** (TalkBack, VoiceOver)"
- ✅ "**Contraste de cores** segue WCAG AA (mínimo 4.5:1)"
- ✅ "**InkWell** fornece feedback tátil visual"

#### [5:15 - 5:30] Microinterações (15 segundos)

**O QUE DIZER:**

> "Microinterações melhoram a experiência: ripple effects nos botões, loading states durante operações assíncronas, e transições suaves entre telas."

**SE HOUVER TEMPO:**
Rodar a aplicação e mostrar rapidamente o ripple effect

**TRANSIÇÃO:**
> "Agora vamos falar sobre como otimizamos a performance."

---

### [5:30 - 6:30] 4. OTIMIZAÇÃO E PERFORMANCE (1 minuto)

#### [5:30 - 6:00] Estratégias de Otimização (30 segundos)

**O QUE DIZER:**

> "Aplicamos várias estratégias de otimização no Flutter."

**O QUE MOSTRAR:**

Abrir `lib/src/atoms/custom_button.dart` novamente:
```dart
const CustomButton({  // ← const constructor
  super.key,          // ← Key para otimização
  required this.text,
  // ...
});
```

**PONTOS-CHAVE:**
- ✅ "**const constructors:** widgets são criados uma vez só, em tempo de compilação"
- ✅ "**Keys:** Flutter identifica widgets corretamente em listas"
- ✅ "**Provider com Selector:** rebuilds seletivos, não tudo"
- ✅ "**Lazy loading:** ListView.builder para listas longas"

#### [6:00 - 6:30] DevTools e Métricas (30 segundos)

**O QUE DIZER:**

> "Usamos **DevTools** para identificar gargalos e validamos performance com testes."

**O QUE MOSTRAR:**

Se possível, abrir um teste de performance:
```dart
testWidgets('Performance de renderização', (tester) async {
  final Stopwatch stopwatch = Stopwatch()..start();
  app.main();
  await tester.pumpAndSettle();
  stopwatch.stop();
  
  // Verifica que carregou em < 3 segundos
  expect(stopwatch.elapsedMilliseconds, lessThan(3000));
});
```

**PONTOS-CHAVE:**
- ✅ "Tela inicial carrega em **< 3 segundos** (testado)"
- ✅ "Entrada de texto responsiva (< 1s para 10 entradas)"
- ✅ "DevTools Timeline identifica frames perdidos (jank)"
- ✅ "DevTools Memory detecta memory leaks"

**TRANSIÇÃO:**
> "Vamos concluir com as métricas do projeto."

---

### [6:30 - 7:00] 5. CONCLUSÃO (30 segundos)

**O QUE DIZER:**

> "Para resumir, implementamos:"

**PONTOS-CHAVE (falar rapidamente):**
- ✅ "Arquitetura sólida com **Clean Architecture + MVVM**"
- ✅ "**9 arquivos de teste** em 3 níveis (Unit, Widget, Integration)"
- ✅ "UI/UX profissional com **Atomic Design** e **acessibilidade WCAG**"
- ✅ "Performance otimizada com **const, keys, e DevTools**"

**MÉTRICAS:**
- "15+ componentes reutilizáveis"
- "3 ViewModels com ChangeNotifier"
- "6 páginas funcionais"
- "Tempo de build < 3 segundos"

**FECHAMENTO:**

> "Essa arquitetura nos dá confiança para refatorar, adicionar features rapidamente, e garantir qualidade através de testes automatizados. Obrigado! Alguma pergunta?"

---

## 💡 DICAS IMPORTANTES

### Durante a Apresentação

**✅ FAZER:**
- Falar com clareza e pausadamente
- Mostrar código real, não apenas slides
- Destacar benefícios práticos de cada decisão
- Manter contato visual com a audiência
- Gerenciar tempo com relógio visível

**❌ EVITAR:**
- Ler slides palavra por palavra
- Entrar em detalhes técnicos muito profundos
- Ficar preso em um único ponto por muito tempo
- Mostrar código sem explicar o que ele faz
- Ultrapassar 7 minutos

### Respostas para Perguntas Comuns

**P: "Por que Clean Architecture e não MVC/MVP?"**
R: "Clean Architecture nos dá separação mais clara de responsabilidades, facilita testes de cada camada isoladamente, e permite trocar implementações sem afetar o domínio. É mais adequado para aplicações médias/grandes."

**P: "Por que Provider e não BLoC/Redux?"**
R: "Provider é mais simples e idiomático do Flutter, tem menos boilerplate, e é suficiente para nossa complexidade. Para apps muito grandes, BLoC seria considerado."

**P: "Quantos por cento de cobertura de testes?"**
R: "Não medimos cobertura percentual ainda, mas temos testes abrangentes nos três níveis. Próximo passo é gerar relatório de cobertura e buscar 80%+."

**P: "Como garantem acessibilidade?"**
R: "Semantics em todos os widgets interativos, contraste de cores WCAG AA, tamanhos de fonte escaláveis, e testes automatizados de acessibilidade."

**P: "Quais são os principais desafios encontrados?"**
R: "Inicialmente, estruturar a arquitetura com separação correta de responsabilidades. Depois, garantir que todos entendam onde cada código deve ir. Documentação e padrões ajudaram muito."

---

## 📊 ALTERNATIVA: SE TIVER MAIS TEMPO (10 minutos)

### Demonstração Adicional (+ 3 minutos)

Se houver tempo extra, você pode:

1. **Rodar a aplicação** (1 min)
   - Mostrar fluxo de login
   - Demonstrar ripple effects
   - Mostrar formulário com validação

2. **Executar todos os testes** (1 min)
   ```bash
   flutter test --coverage
   ```
   - Mostrar output no terminal
   - Explicar cobertura

3. **DevTools** (1 min)
   - Abrir Flutter DevTools
   - Mostrar widget tree
   - Demonstrar performance overlay

---

## 📚 MATERIAL DE BACKUP

### Se Algo Der Errado

**Sem conexão com internet:**
- Todos os arquivos estão localmente
- Documentação está em APRESENTACAO_ASPECTOS_TECNICOS.md

**Erro ao executar testes:**
- Mostre os arquivos de teste
- Explique o que eles testam
- Pule para próximo tópico

**IDE trava:**
- Use navegador de arquivos
- Mostre estrutura de pastas
- Explique verbalmente

### Tópicos Extras (se perguntarem)

- **Integração Firebase**: Auth, Firestore, Messaging
- **Gerenciamento de estado**: Provider vs outras soluções
- **Estrutura de dados no Firestore**
- **CI/CD**: Possível implementação futura
- **Internacionalização**: Próximo passo
- **Modo escuro**: Planejado

---

## ✅ CHECKLIST PÓS-APRESENTAÇÃO

- [ ] Enviar slides/documentação para participantes
- [ ] Responder perguntas em email/chat
- [ ] Documentar feedback recebido
- [ ] Atualizar documentação com sugestões
- [ ] Celebrar! 🎉

---

**Boa sorte na apresentação! 🚀**

*Lembre-se: confiança vem da preparação. Você conhece o projeto melhor que ninguém!*

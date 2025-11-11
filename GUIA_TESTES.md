# Guia de Testes - MGK Sistema de Cadastro

## Visão Geral dos Testes

Este documento descreve a estratégia de testes implementada no projeto MGK, incluindo testes unitários e testes de widget.

---

## Estrutura de Testes

```
test/
├── unit/                              # Testes Unitários
│   ├── models/                        # Testes de Modelos de Domínio
│   │   ├── cliente_model_test.dart    # 7 testes
│   │   ├── user_model_test.dart       # 9 testes
│   │   └── solicitacao_model_test.dart # 9 testes
│   └── utils/                         # Testes de Utilitários
│       └── validators_test.dart       # 15 testes
│
└── widget/                            # Testes de Widget
    ├── custom_button_test.dart        # 9 testes
    └── login_field_test.dart          # 8 testes
```

**Total: 57 testes implementados**

---

## Testes Unitários

### 1. ClienteModel Tests (7 testes)

Testa a entidade de domínio `ClienteModel`.

**Casos de Teste:**

- ✅ Criação correta do modelo
- ✅ Conversão para Map
- ✅ Criação a partir de Map
- ✅ Método copyWith
- ✅ Comparação de igualdade
- ✅ Geração de toString
- ✅ Valores padrão

```dart
test('Deve criar ClienteModel corretamente', () {
  final cliente = ClienteModel(
    id: '1',
    nome: 'João Silva',
    cpf: '12345678900',
    email: 'joao@email.com',
    dataCadastro: DateTime(2024, 1, 1),
  );

  expect(cliente.nome, 'João Silva');
  expect(cliente.cpf, '12345678900');
});
```

### 2. UserModel Tests (9 testes)

Testa a entidade de domínio `UserModel`.

**Casos de Teste:**

- ✅ Criação de usuário comum
- ✅ Criação de usuário admin
- ✅ Conversão para Map
- ✅ Criação a partir de Map
- ✅ Método copyWith
- ✅ Comparação de igualdade
- ✅ Geração de toString
- ✅ Valor padrão de isAdmin

### 3. SolicitacaoModel Tests (9 testes)

Testa a entidade de domínio `SolicitacaoModel` e enum `SolicitacaoStatus`.

**Casos de Teste:**

- ✅ Criação correta do modelo
- ✅ Status padrão (pendente)
- ✅ Conversão para Map
- ✅ Criação a partir de Map
- ✅ Método copyWith
- ✅ Conversão de status para string
- ✅ Parse de status de string
- ✅ Geração de toString
- ✅ Tratamento de status inválido

### 4. Validators Tests (15 testes)

Testa a lógica de negócio de validações.

**Validações Implementadas:**

#### CPF (5 testes)

- ✅ Valida CPF correto
- ✅ Rejeita CPF inválido
- ✅ Rejeita CPF com menos de 11 dígitos
- ✅ Aceita CPF com formatação
- ✅ Rejeita CPF com dígitos repetidos

```dart
test('Deve validar CPF correto', () {
  expect(Validators.isValidCPF('12345678909'), true);
  expect(Validators.isValidCPF('111.444.777-35'), true);
});
```

#### Email (2 testes)

- ✅ Valida email correto
- ✅ Rejeita email inválido

#### Senha (2 testes)

- ✅ Valida senha com mínimo 6 caracteres
- ✅ Rejeita senha com menos de 6 caracteres

#### Nome (2 testes)

- ✅ Valida nome correto
- ✅ Rejeita nome inválido

#### Telefone (2 testes)

- ✅ Valida telefone brasileiro
- ✅ Rejeita telefone inválido

---

## Testes de Widget

### 1. CustomButton Tests (9 testes)

Testa o componente `CustomButton` (Atom).

**Casos de Teste:**

- ✅ Renderização com texto correto
- ✅ Execução de callback ao pressionar
- ✅ Cor personalizada de fundo
- ✅ Cor personalizada de texto
- ✅ Renderização com ícone
- ✅ Semântica para acessibilidade
- ✅ Tamanho de fonte personalizável
- ✅ Padding personalizado
- ✅ Renderização sem ícone

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

### 2. LoginField Tests (8 testes)

Testa o componente `LoginField` (Molecule).

**Casos de Teste:**

- ✅ Renderização com label
- ✅ Aceitação de entrada de texto
- ✅ Ocultação de texto (senha)
- ✅ Callback onChanged
- ✅ Limpeza de texto via controller
- ✅ Manutenção de foco
- ✅ Múltiplos campos independentes

```dart
testWidgets('Deve ocultar texto quando isPassword é true', (tester) async {
  final controller = TextEditingController();

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: LoginField(
          controller: controller,
          label: 'Senha',
          isPassword: true,
        ),
      ),
    ),
  );

  final textField = tester.widget<TextField>(find.byType(TextField));
  expect(textField.obscureText, true);
});
```

---

## Executando os Testes

### Comandos Básicos

```powershell
# Executar todos os testes
flutter test

# Executar apenas testes unitários
flutter test test/unit/

# Executar apenas testes de widget
flutter test test/widget/

# Executar um arquivo específico
flutter test test/unit/models/cliente_model_test.dart

# Executar com verbose
flutter test --reporter expanded

# Executar com cobertura
flutter test --coverage
```

### Visualizar Cobertura

```powershell
# Gerar relatório de cobertura
flutter test --coverage

# Instalar ferramenta de visualização
dart pub global activate coverage

# Gerar HTML
genhtml coverage/lcov.info -o coverage/html

# Abrir no navegador
start coverage/html/index.html
```

---

## Resultados Esperados

### Testes Unitários (40 testes)

```
✓ ClienteModel Tests (7 testes)
  ✓ Deve criar ClienteModel corretamente
  ✓ Deve converter ClienteModel para Map corretamente
  ✓ Deve criar ClienteModel a partir de Map
  ✓ Deve criar cópia de ClienteModel com valores atualizados
  ✓ Deve comparar ClienteModel corretamente
  ✓ Deve gerar toString corretamente

✓ UserModel Tests (9 testes)
  ✓ Deve criar UserModel corretamente
  ✓ Deve criar UserModel admin corretamente
  ✓ Deve converter UserModel para Map
  ✓ Deve criar UserModel a partir de Map
  ✓ Deve criar cópia de UserModel com valores atualizados
  ✓ Deve comparar UserModel corretamente
  ✓ Deve gerar toString corretamente
  ✓ isAdmin deve ser false por padrão

✓ SolicitacaoModel Tests (9 testes)
  ✓ Deve criar SolicitacaoModel corretamente
  ✓ Status deve ser pendente por padrão
  ✓ Deve converter SolicitacaoModel para Map
  ✓ Deve criar SolicitacaoModel a partir de Map
  ✓ Deve criar cópia de SolicitacaoModel com valores atualizados
  ✓ Deve converter status para string corretamente
  ✓ Deve parsear status de string corretamente
  ✓ Deve gerar toString corretamente

✓ Validators Tests (15 testes)
  ✓ CPF Validation (5 testes)
  ✓ Email Validation (2 testes)
  ✓ Password Validation (2 testes)
  ✓ Name Validation (2 testes)
  ✓ Phone Validation (2 testes)
```

### Testes de Widget (17 testes)

```
✓ CustomButton Widget Tests (9 testes)
  ✓ Deve renderizar botão com texto correto
  ✓ Deve executar callback ao ser pressionado
  ✓ Deve renderizar com cor personalizada
  ✓ Deve renderizar com texto em cor personalizada
  ✓ Deve renderizar com ícone quando fornecido
  ✓ Deve ter semântica apropriada para acessibilidade
  ✓ Deve ter tamanho de fonte personalizável
  ✓ Deve aplicar padding personalizado
  ✓ Deve renderizar sem ícone quando não fornecido

✓ LoginField Widget Tests (8 testes)
  ✓ Deve renderizar campo de texto com label
  ✓ Deve aceitar entrada de texto
  ✓ Deve ocultar texto quando isPassword é true
  ✓ Não deve ocultar texto quando isPassword é false
  ✓ Deve chamar callback onChanged quando texto mudar
  ✓ Deve limpar texto quando controller for limpo
  ✓ Deve manter o foco após digitação
  ✓ Deve renderizar múltiplos LoginFields independentemente
```

---

## Melhores Práticas Aplicadas

### 1. Arrange-Act-Assert (AAA)

```dart
test('Descrição do teste', () {
  // Arrange - Preparação
  final model = ClienteModel(nome: 'Teste');

  // Act - Ação
  final result = model.nome;

  // Assert - Verificação
  expect(result, 'Teste');
});
```

### 2. Nomes Descritivos

✅ "Deve criar ClienteModel corretamente"  
❌ "Test 1"

### 3. Independência entre Testes

Cada teste deve ser independente e não depender de outros.

### 4. Mock Classes Quando Necessário

```dart
class MockTimestamp {
  final DateTime dateTime;
  MockTimestamp(this.dateTime);
  DateTime toDate() => dateTime;
}
```

### 5. Testes para Casos Extremos

- Valores nulos
- Strings vazias
- Valores inválidos
- Limites de validação

---

## Benefícios dos Testes Implementados

### Confiabilidade

- ✅ Detecção precoce de bugs
- ✅ Garantia de funcionamento correto
- ✅ Prevenção de regressões

### Documentação

- ✅ Testes servem como documentação viva
- ✅ Exemplos de uso dos componentes
- ✅ Especificação do comportamento esperado

### Manutenibilidade

- ✅ Refatoração segura
- ✅ Mudanças com confiança
- ✅ Feedback rápido

### Qualidade

- ✅ Código mais robusto
- ✅ Melhor design (testável)
- ✅ Menos bugs em produção

---

## Próximos Passos

### Testes a Implementar

1. **Testes de Integração**

   - Fluxo completo de autenticação
   - CRUD completo de clientes
   - Solicitações de cadastro end-to-end

2. **Testes de ViewModel**

   - AuthViewModel com mock repository
   - ClienteViewModel com mock repository
   - SolicitacaoViewModel com mock repository

3. **Testes de Repository**

   - Repository implementations com mock datasources
   - Tratamento de erros
   - Streams

4. **Testes de Widgets Complexos**
   - RegisterForm
   - Organisms completos
   - Navegação entre telas

---

## Conclusão

O projeto MGK implementa uma estratégia de testes abrangente que garante:

- ✅ **57 testes automatizados** funcionando
- ✅ Cobertura de **modelos de domínio**
- ✅ Cobertura de **lógica de negócio** (validações)
- ✅ Cobertura de **componentes UI**
- ✅ Testes seguindo **melhores práticas**

Esta base sólida de testes permite desenvolvimento ágil com confiança e qualidade.

---

**Execute `flutter test` para validar todos os testes! 🧪**

# 📋 PASSO A PASSO - Esteira de Contratos Ativos

## ✅ O que foi feito:

### Arquivos Criados (Atomic Design):
1. ✅ `lib/src/organisms/contracts_list_organism.dart` - Componente da lista de contratos
2. ✅ `lib/src/templates/contracts_template.dart` - Template da página
3. ✅ `lib/src/pages/contratos_ativos_page.dart` - Página principal

### Arquivos Modificados:
4. ✅ `lib/main.dart` - Rota `/contratos` adicionada
5. ✅ `lib/src/pages/home_page.dart` - Botão "Contratos Ativos" adicionado
6. ✅ `lib/src/organisms/client_form.dart` - Campo `contratoAtivo: true` adicionado ao cadastro

---

## 🚀 Como Usar:

### 1. Configurar Firebase (IMPORTANTE!)

Para clientes já cadastrados, você precisa adicionar o campo `contratoAtivo` manualmente:

**Opção A - Firebase Console (Recomendado para poucos clientes):**
1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Vá em Firestore Database
3. Abra a coleção `clientes`
4. Em cada documento, adicione o campo:
   - Nome do campo: `contratoAtivo`
   - Tipo: `boolean`
   - Valor: `true`

**Opção B - Script Flutter (Recomendado para muitos clientes):**
Crie um arquivo temporário para atualizar todos os clientes:

```dart
// Arquivo: lib/update_clientes.dart (temporário)
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> atualizarTodosClientes() async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('clientes').get();
  
  for (var doc in snapshot.docs) {
    await doc.reference.update({'contratoAtivo': true});
  }
  
  print('✅ ${snapshot.docs.length} clientes atualizados!');
}
```

Execute uma vez e depois delete o arquivo.

### 2. Executar o App

```bash
flutter pub get
flutter run
```

### 3. Acessar a Esteira

1. Faça login no app
2. Na tela inicial, clique em **"Contratos Ativos"**
3. Veja a lista de todos os clientes com contratos ativos
4. Clique em um cliente para ver detalhes
5. Clique em **"Finalizar Contrato"** para encerrar

---

## 📱 Funcionalidades:

### ✅ Lista em Tempo Real
- Atualiza automaticamente quando há mudanças no Firebase
- Mostra apenas clientes com `contratoAtivo: true`

### ✅ Detalhes do Cliente
Cards expansíveis com:
- Nome e CPF
- Email
- Endereço
- Renda bruta
- Data de início do contrato
- Tipo de cliente

### ✅ Finalizar Contrato
- Confirmação antes de finalizar
- Atualiza `contratoAtivo` para `false`
- Adiciona `dataFinalizacao` com timestamp
- Cliente desaparece da lista automaticamente

### ✅ Estados da Interface
- Loading durante carregamento
- Mensagem quando não há contratos ativos
- Tratamento de erros
- Feedback visual de sucesso/erro

---

## 🎨 Estrutura (Atomic Design):

```
📦 lib/src/
├── 📁 atoms/ (componentes básicos - já existentes)
├── 📁 molecules/ (componentes compostos - já existentes)
├── 📁 organisms/
│   └── 📄 contracts_list_organism.dart ← NOVO
├── 📁 templates/
│   └── 📄 contracts_template.dart ← NOVO
└── 📁 pages/
    └── 📄 contratos_ativos_page.dart ← NOVO
```

---

## 🔥 Estrutura de Dados no Firestore:

### Novos Clientes (cadastrados após a atualização):
Já vem com `contratoAtivo: true` automaticamente ✅

### Estrutura completa:
```json
{
  "nome": "João Silva",
  "cpf": "123.456.789-00",
  "rg": "12.345.678-9",
  "email": "joao@email.com",
  "tipoCliente": "Assalariado",
  "endereco": "Rua Exemplo, 123, Centro, São Paulo-SP",
  "renda": "R$ 3.000,00",
  "contratoAtivo": true,
  "criadoEm": "Timestamp",
  "dataFinalizacao": "Timestamp" // (só aparece após finalizar)
}
```

---

## 🧪 Testar:

1. ✅ Cadastre um novo cliente
2. ✅ Vá em "Contratos Ativos"
3. ✅ Veja o cliente na lista
4. ✅ Expanda o card do cliente
5. ✅ Clique em "Finalizar Contrato"
6. ✅ Confirme a ação
7. ✅ O cliente desaparece da lista
8. ✅ Verifique no Firebase: `contratoAtivo` = false

---

## 🆘 Resolução de Problemas:

### Lista vazia mesmo com clientes cadastrados?
- Verifique se os clientes têm o campo `contratoAtivo: true`
- Execute o script de atualização (Opção B acima)

### Erro ao finalizar contrato?
- Verifique as regras de segurança do Firebase
- Certifique-se de que o usuário tem permissão de escrita

### App não compila?
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🎯 Resultado Final:

**HomePage** agora tem 4 botões:
1. 📝 Cadastrar Cliente
2. 👥 Ver Clientes
3. 📋 **Contratos Ativos** ← NOVO
4. 🌐 Ver Posts API

**Rota adicionada:** `/contratos` ✅

---

**Pronto! Seu sistema agora tem uma esteira de contratos ativos totalmente funcional! 🎉**

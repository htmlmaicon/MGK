# 🎯 Esteira de Contratos Ativos - Sistema MGK

## 📋 Resumo

Foi adicionada uma nova funcionalidade ao sistema: **Esteira de Contratos Ativos**, que permite visualizar e gerenciar contratos de clientes seguindo o padrão Atomic Design.

---

## 📦 Arquivos Criados

### 1. **Organism** - Componente de Lista

**Arquivo:** `lib/src/organisms/contracts_list_organism.dart`

- Lista todos os clientes com contratos ativos
- Exibe informações detalhadas em cards expansíveis
- Botão para finalizar contratos
- Integração com Firebase Firestore em tempo real (StreamBuilder)

### 2. **Template** - Layout da Página

**Arquivo:** `lib/src/templates/contracts_template.dart`

- Template com AppBar personalizada
- Cabeçalho informativo
- Container para o organism da lista

### 3. **Page** - Página Principal

**Arquivo:** `lib/src/pages/contratos_ativos_page.dart`

- Página que utiliza o template
- Segue o padrão do projeto

---

## 🔧 Arquivos Modificados

### 1. **main.dart**

- ✅ Adicionado import: `import 'src/pages/contratos_ativos_page.dart';`
- ✅ Adicionado rota: `'/contratos': (context) => const ContratosAtivosPage()`

### 2. **home_page.dart**

- ✅ Adicionado botão "Contratos Ativos" na tela inicial
- ✅ Navegação para a rota `/contratos`

---

## 🔥 Configuração do Firebase

### ⚠️ IMPORTANTE: Campo Obrigatório

Para que a esteira funcione, é necessário adicionar o campo **`contratoAtivo`** aos clientes no Firestore.

### Opções de Configuração:

#### **Opção 1: Atualizar Clientes Existentes (Manualmente)**

Acesse o Firebase Console e adicione o campo `contratoAtivo: true` em cada documento de cliente na coleção `clientes`.

#### **Opção 2: Modificar o Formulário de Cadastro**

Adicione o campo automaticamente ao salvar novos clientes. Modifique o arquivo:

**`lib/src/organisms/client_form.dart`** - Linha ~80:

```dart
await _firestore.collection('clientes').add({
  'nome': nomeController.text.trim(),
  'rg': rgController.text.trim(),
  'cpf': cpfController.text.trim(),
  'nascimento': nascimentoController.text.trim(),
  'cep': cepController.text.trim(),
  'endereco': enderecoController.text.trim(),
  'pai': paiController.text.trim(),
  'mae': maeController.text.trim(),
  'expedicao': expedicaoController.text.trim(),
  'emissor': emissorController.text.trim(),
  'renda': rendaController.text.trim(),
  'email': emailController.text.trim(),
  'tipoCliente': widget.tipoCliente,
  'contratoAtivo': true,  // ← ADICIONAR ESTA LINHA
  'criadoEm': FieldValue.serverTimestamp(),
});
```

#### **Opção 3: Script de Atualização em Lote**

Crie um script para atualizar todos os clientes de uma vez:

```dart
// Função para atualizar clientes existentes
Future<void> atualizarClientesExistentes() async {
  final firestore = FirebaseFirestore.instance;
  final clientes = await firestore.collection('clientes').get();

  for (var doc in clientes.docs) {
    await doc.reference.update({'contratoAtivo': true});
  }

  print('${clientes.docs.length} clientes atualizados!');
}
```

---

## 🚀 Como Usar

### 1. **Acessar a Esteira**

- Abra o aplicativo
- Na tela inicial (HomePage), clique no botão **"Contratos Ativos"**

### 2. **Visualizar Contratos**

- A tela exibe todos os clientes com `contratoAtivo: true`
- Clique em um card para expandir e ver detalhes completos

### 3. **Finalizar Contrato**

- Clique no botão **"Finalizar Contrato"** no card expandido
- Confirme a ação no diálogo
- O contrato será atualizado no Firebase com:
  - `contratoAtivo: false`
  - `dataFinalizacao: timestamp atual`

---

## 🎨 Características da Implementação

### ✅ Padrão Atomic Design

- **Atoms**: Reutiliza componentes existentes
- **Molecules**: Usa componentes do projeto
- **Organism**: `contracts_list_organism.dart` - lógica da lista
- **Template**: `contracts_template.dart` - estrutura da página
- **Page**: `contratos_ativos_page.dart` - página final

### ✅ Firebase Realtime

- Usa `StreamBuilder` para atualizações em tempo real
- Quando um contrato é finalizado, desaparece automaticamente da lista

### ✅ UX/UI

- Cards expansíveis com informações organizadas
- Ícones representativos para cada informação
- Confirmação antes de finalizar contratos
- Mensagens de sucesso/erro
- Estados vazios tratados (sem contratos ativos)
- Loading states durante carregamento

### ✅ Filtros e Ordenação

- Filtra apenas clientes com `contratoAtivo: true`
- Ordena por data de criação (mais recentes primeiro)

---

## 📱 Estrutura de Dados Esperada

### Documento no Firestore (coleção `clientes`):

```json
{
  "nome": "João Silva",
  "cpf": "123.456.789-00",
  "email": "joao@email.com",
  "tipoCliente": "Assalariado",
  "endereco": "Rua Exemplo, 123",
  "renda": "R$ 3.000,00",
  "contratoAtivo": true,  // ← CAMPO OBRIGATÓRIO
  "criadoEm": Timestamp,
  "dataFinalizacao": Timestamp (opcional)
}
```

---

## 🔍 Testes Recomendados

1. ✅ Verificar se a rota `/contratos` está funcionando
2. ✅ Testar a listagem de clientes ativos
3. ✅ Testar a expansão dos cards
4. ✅ Testar o botão de finalizar contrato
5. ✅ Verificar atualizações em tempo real
6. ✅ Testar comportamento com lista vazia
7. ✅ Testar tratamento de erros

---

## 🛠️ Próximos Passos (Opcional)

### Melhorias Sugeridas:

1. **Filtros Avançados**: Filtrar por tipo de cliente, data, etc.
2. **Busca**: Campo de busca por nome ou CPF
3. **Estatísticas**: Dashboard com total de contratos ativos
4. **Histórico**: Tela para ver contratos finalizados
5. **Edição**: Permitir editar dados do contrato
6. **Relatórios**: Exportar lista em PDF/Excel

---

## ⚡ Execução Rápida

```bash
# 1. Certifique-se de que o Firebase está configurado
flutter pub get

# 2. Execute o aplicativo
flutter run

# 3. Acesse: Login > Home > Contratos Ativos
```

---

## 📞 Suporte

Se tiver dúvidas ou problemas:

1. Verifique se o campo `contratoAtivo` existe no Firestore
2. Confira as regras de segurança do Firebase
3. Verifique a conexão com o Firebase
4. Confira os logs no console do Flutter

---

**Sistema MGK - Gestão de Clientes**
_Desenvolvido com Flutter & Firebase_

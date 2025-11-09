# 🔐 Sistema de Permissões de Usuário

## 📋 Implementado com Sucesso!

O sistema agora possui controle de permissões baseado no usuário logado.

---

## 👤 Tipos de Usuário:

### 1. **ADMINISTRADOR** 👨‍💼

**Email:** `adimin@adimin`

**Permissões:**

- ✅ **Cadastrar** novos clientes
- ✅ **Editar** clientes existentes
- ✅ **Excluir** clientes
- ✅ **Ativar/Desativar** contratos
- ✅ **Consultar** todos os clientes
- ✅ **Finalizar** contratos na esteira

**Badge:** 🟡 Amarelo "ADMINISTRADOR"

---

### 2. **USUÁRIO COMUM** 👥

**Email:** Qualquer outro email cadastrado

**Permissões:**

- ✅ **Consultar** clientes (visualização)
- ✅ **Ativar/Desativar** contratos
- ✅ **Finalizar** contratos na esteira
- ❌ **NÃO PODE** cadastrar clientes
- ❌ **NÃO PODE** editar clientes
- ❌ **NÃO PODE** excluir clientes

**Badge:** 🔵 Azul "USUÁRIO"

---

## 🎨 Interface por Tipo de Usuário:

### **HomePage - ADMINISTRADOR:**

```
👤 ADMINISTRADOR
   adimin@adimin
   Você tem acesso total ao sistema

[📝 Cadastrar Cliente]
[👥 Ver Clientes]
[📋 Contratos Ativos]
```

### **HomePage - USUÁRIO COMUM:**

```
👤 USUÁRIO
   usuario@email.com
   Você pode consultar e ativar contratos

[👥 Ver Clientes]
[📋 Contratos Ativos]
```

_(Botão "Cadastrar Cliente" oculto)_

---

## 📱 Funcionalidades por Tela:

### **HomePage**

- **Admin:** Vê botão "Cadastrar Cliente"
- **Usuário:** Botão oculto
- **Ambos:** Badge visual mostrando tipo de usuário e email

### **Ver Clientes**

- **Admin:** Vê botões "Editar" e "Excluir" em cada cliente
- **Usuário:** Botões ocultos, vê apenas informações
- **Ambos:** Podem ativar/desativar contratos

### **Cadastro de Cliente**

- **Admin:** Acesso completo
- **Usuário:** Bloqueado - mensagem de erro e volta automaticamente

### **Editar Cliente**

- **Admin:** Acesso completo
- **Usuário:** Bloqueado - mensagem de erro

### **Contratos Ativos**

- **Admin:** Pode finalizar contratos
- **Usuário:** Pode finalizar contratos
- **Ambos:** Visualizam todas as informações

---

## 🔒 Níveis de Proteção:

### **Nível 1: Interface (UI)**

Botões são ocultados para usuários sem permissão

```dart
if (_authService.canCreateClient())
  ElevatedButton(...) // Só aparece para admin
```

### **Nível 2: Validação na Ação**

Verifica permissão ao clicar no botão

```dart
if (!_authService.canDeleteClient()) {
  ScaffoldMessenger.showSnackBar(
    SnackBar(content: Text('Permissão negada'))
  );
  return;
}
```

### **Nível 3: Validação na Página**

Bloqueia acesso à página inteira se não tiver permissão

```dart
if (!_authService.canCreateClient()) {
  Navigator.pop(context); // Volta automaticamente
}
```

---

## 🛠️ Estrutura Técnica:

### **AuthService** (`lib/src/utils/auth_service.dart`)

Serviço centralizado de autenticação e permissões:

```dart
class AuthService {
  static const String adminEmail = 'adimin@adimin';

  bool isAdmin() // Verifica se é admin
  bool canCreateClient() // Pode cadastrar
  bool canEditClient() // Pode editar
  bool canDeleteClient() // Pode excluir
  bool canManageContract() // Pode ativar/desativar
  bool canViewClients() // Pode visualizar
}
```

### **Métodos de Verificação:**

- `isAdmin()` - Retorna true se email = adimin@adimin
- `canCreateClient()` - Apenas admin
- `canEditClient()` - Apenas admin
- `canDeleteClient()` - Apenas admin
- `canManageContract()` - Todos os usuários logados
- `canViewClients()` - Todos os usuários logados

---

## 💬 Mensagens do Sistema:

### **Permissão Negada:**

```
"Apenas o administrador (adimin@adimin) pode realizar esta ação."
```

**Quando aparece:**

- Usuário comum tenta acessar cadastro
- Usuário comum tenta editar cliente
- Usuário comum tenta excluir cliente

---

## 🧪 Como Testar:

### **Teste 1: Login como ADMIN**

```
Email: adimin@adimin
Senha: [sua senha]

✅ Deve ver badge "ADMINISTRADOR" amarelo
✅ Deve ver botão "Cadastrar Cliente"
✅ Deve poder editar e excluir clientes
```

### **Teste 2: Login como USUÁRIO**

```
Email: outro@email.com
Senha: [sua senha]

✅ Deve ver badge "USUÁRIO" azul
✅ NÃO deve ver botão "Cadastrar Cliente"
✅ NÃO deve ver botões "Editar" e "Excluir"
✅ Pode ativar/desativar contratos
```

### **Teste 3: Tentativa de Acesso Negado**

```
1. Logue como usuário comum
2. Tente acessar /cadastro pela URL
   → Sistema bloqueia e volta para home
3. Veja Ver Clientes
   → Botões "Editar" e "Excluir" ocultos
```

---

## 🎯 Matriz de Permissões:

| Ação                 | Admin | Usuário |
| -------------------- | ----- | ------- |
| Ver Clientes         | ✅    | ✅      |
| Cadastrar Cliente    | ✅    | ❌      |
| Editar Cliente       | ✅    | ❌      |
| Excluir Cliente      | ✅    | ❌      |
| Ativar Contrato      | ✅    | ✅      |
| Desativar Contrato   | ✅    | ✅      |
| Finalizar Contrato   | ✅    | ✅      |
| Ver Contratos Ativos | ✅    | ✅      |

---

## 📝 Observações Importantes:

1. **Email do Admin:**

   - Deve ser exatamente: `adimin@adimin`
   - Não é case-sensitive (ADIMIN@ADIMIN funciona)

2. **Criação de Usuários:**

   - Crie usuários no Firebase Authentication
   - Qualquer email diferente de `adimin@adimin` = usuário comum

3. **Segurança:**

   - Sistema usa Firebase Authentication
   - Permissões verificadas no frontend
   - Para produção, adicione regras no Firestore Security Rules

4. **Badge Visual:**
   - Amarelo com ícone de escudo = Admin
   - Azul com ícone de pessoa = Usuário

---

## 🔐 Regras de Firestore (Recomendado):

Para adicionar segurança no backend, configure no Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /clientes/{document=**} {
      // Todos podem ler
      allow read: if request.auth != null;

      // Apenas admin pode criar
      allow create: if request.auth != null
                    && request.auth.token.email == 'adimin@adimin';

      // Apenas admin pode atualizar (exceto contratoAtivo)
      allow update: if request.auth != null
                    && (request.auth.token.email == 'adimin@adimin'
                    || request.resource.data.diff(resource.data).affectedKeys()
                       .hasOnly(['contratoAtivo', 'dataAtivacao', 'dataDesativacao', 'dataFinalizacao']));

      // Apenas admin pode deletar
      allow delete: if request.auth != null
                    && request.auth.token.email == 'adimin@adimin';
    }
  }
}
```

---

## ✅ Status: Implementado e Funcionando!

**Arquivos Modificados:**

- ✅ `lib/src/utils/auth_service.dart` (NOVO)
- ✅ `lib/src/pages/home_page.dart`
- ✅ `lib/src/pages/ver_clientes_page.dart`
- ✅ `lib/src/pages/cadastro_cliente_page.dart`

**Data:** 08/11/2025

---

**🎉 Sistema de Permissões Completo e Funcional!**

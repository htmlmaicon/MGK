# 🚀 GUIA RÁPIDO - Ver Clientes (Atualizado)

## ✨ Novas Funcionalidades:

### 1️⃣ **Ativar Contrato** 🟢

Faz o cliente aparecer na esteira de contratos ativos.

**Como usar:**

1. Abra "Ver Clientes"
2. Clique em um cliente para expandir
3. Clique em **"Ativar Contrato"**
4. Confirme
5. ✅ Cliente aparece com badge **[ATIVO]**
6. ✅ Cliente vai automaticamente para a **Esteira de Contratos Ativos**

---

### 2️⃣ **Desativar Contrato** 🟠

Remove o cliente da esteira de contratos ativos.

**Como usar:**

1. Expanda um cliente com contrato ativo
2. Clique em **"Desativar Contrato"**
3. Confirme
4. ✅ Badge **[ATIVO]** desaparece
5. ✅ Cliente sai da esteira de contratos

---

### 3️⃣ **Editar Cliente** 🔵

Altere qualquer informação do cliente.

**Como usar:**

1. Expanda o card do cliente
2. Clique em **"Editar"**
3. Modifique os campos desejados
4. Clique em **"Atualizar Cliente"**
5. ✅ Informações atualizadas!

**Campos editáveis:**

- Nome, RG, CPF, Data de Nascimento
- CEP e Endereço (com busca automática)
- Nome do Pai e da Mãe
- Data de expedição e Emissor
- Renda Bruta e Email

---

### 4️⃣ **Excluir Cliente** 🔴

Remove permanentemente um cliente do sistema.

**Como usar:**

1. Expanda o card do cliente
2. Clique em **"Excluir"**
3. Confirme a exclusão
4. ⚠️ **ATENÇÃO:** Esta ação não pode ser desfeita!
5. ✅ Cliente removido do sistema

---

## 🎯 Fluxo Completo: Do Cadastro à Esteira

### Cenário: Cadastrar e Ativar Cliente

```mermaid
1. Home → Cadastrar Cliente
   ↓
2. Preencher formulário → Enviar
   ↓
3. Home → Ver Clientes
   ↓
4. Expandir cliente → Ativar Contrato
   ↓
5. Home → Contratos Ativos
   ✅ Cliente aparece na esteira!
```

---

## 📊 Estados de um Cliente:

### **Cliente Novo** (Sem Contrato)

```
📋 Ver Clientes
└── João Silva
    └── [🔵 Editar] [🔴 Excluir]
        [🟢 Ativar Contrato]
```

### **Cliente Ativo** (Com Contrato)

```
📋 Ver Clientes
└── João Silva [ATIVO] ← Badge verde
    └── [🔵 Editar] [🔴 Excluir]
        [🟠 Desativar Contrato]
```

---

## 🎨 Interface Visual:

### **Lista por Categoria:**

```
📋 VER CLIENTES

AGRICULTOR
├── 👤 José da Silva [ATIVO]
│   └── jose@email.com
└── 👤 Maria Oliveira
    └── maria@email.com

ASSALARIADO
├── 👤 Carlos Santos [ATIVO]
│   └── carlos@email.com
└── 👤 Ana Paula
    └── ana@email.com
```

### **Card Expandido:**

```
👤 João Silva [ATIVO]
    joao@email.com

    ▼ EXPANDIDO:
    ┌─────────────────────────────────┐
    │ CPF:      123.456.789-00        │
    │ Endereço: Rua Exemplo, 123      │
    │ Renda:    R$ 3.000,00           │
    ├─────────────────────────────────┤
    │ [🔵 Editar]  [🔴 Excluir]      │
    │ [🟠 Desativar Contrato]         │
    └─────────────────────────────────┘
```

---

## 🔄 Integração: Ver Clientes ↔️ Esteira

### **Ativar Contrato:**

```
Ver Clientes               Esteira de Contratos
┌───────────┐              ┌───────────┐
│ João Silva│  [Ativar]   │ João Silva│
│ (inativo) │ ─────────→  │ [ATIVO]   │
└───────────┘              └───────────┘
```

### **Desativar Contrato:**

```
Ver Clientes               Esteira de Contratos
┌───────────┐              ┌───────────┐
│ João Silva│ [Desativar] │           │
│ [ATIVO]   │ ─────────→  │  (vazio)  │
└───────────┘              └───────────┘
```

---

## 🆘 Dúvidas Frequentes:

### ❓ Qual a diferença entre "Desativar Contrato" e "Excluir"?

- **Desativar:** Cliente continua cadastrado, mas sai da esteira
- **Excluir:** Cliente é removido permanentemente do sistema

### ❓ Posso reativar um contrato desativado?

- ✅ Sim! Basta clicar em "Ativar Contrato" novamente

### ❓ O que acontece se eu editar um cliente com contrato ativo?

- ✅ Ele continua ativo na esteira com os dados atualizados

### ❓ Posso excluir um cliente com contrato ativo?

- ✅ Sim, mas ele será removido da esteira também

### ❓ Como sei se um cliente tem contrato ativo?

- 📍 Badge verde **[ATIVO]** ao lado do nome
- 📍 Botão laranja "Desativar Contrato"

---

## ⚡ Atalhos e Dicas:

### 💡 **Dica 1:** Badge Visual

O badge **[ATIVO]** aparece automaticamente quando você ativa o contrato. Não precisa atualizar a página!

### 💡 **Dica 2:** Busca de CEP

Ao editar um cliente, você pode buscar o endereço pelo CEP automaticamente.

### 💡 **Dica 3:** Confirmação de Segurança

Todas as ações críticas (excluir, ativar, desativar) pedem confirmação. Leia com atenção!

### 💡 **Dica 4:** Ordem Alfabética

Os clientes são exibidos em ordem alfabética dentro de cada categoria.

### 💡 **Dica 5:** Feedback Visual

Após cada ação, uma mensagem aparece confirmando o sucesso ou erro.

---

## 🎯 Casos de Uso:

### **Caso 1: Cliente Assinou Contrato**

```
1. Ver Clientes
2. Localizar o cliente
3. Expandir → Ativar Contrato
4. Gerenciar na Esteira de Contratos Ativos
```

### **Caso 2: Contrato Foi Finalizado**

```
1. Ver Clientes (ou Esteira de Contratos)
2. Expandir cliente
3. Desativar Contrato
4. Cliente sai da esteira mas permanece cadastrado
```

### **Caso 3: Correção de Dados**

```
1. Ver Clientes
2. Expandir cliente
3. Editar
4. Corrigir informações
5. Atualizar Cliente
```

### **Caso 4: Cliente Cancelou Definitivamente**

```
1. Ver Clientes
2. Expandir cliente
3. Excluir
4. Confirmar exclusão
5. Cliente removido permanentemente
```

---

## 📱 Resumo das Ações:

| Ação                   | Botão | Cor      | O que faz                   |
| ---------------------- | ----- | -------- | --------------------------- |
| **Ativar Contrato**    | 🟢    | Verde    | Cliente vai para a esteira  |
| **Desativar Contrato** | 🟠    | Laranja  | Cliente sai da esteira      |
| **Editar**             | 🔵    | Azul     | Abre formulário de edição   |
| **Excluir**            | 🔴    | Vermelho | Remove cliente (permanente) |

---

## 🚀 Pronto para Usar!

Agora você tem **controle total** sobre seus clientes:

- ✅ Cadastrar
- ✅ Visualizar
- ✅ Editar
- ✅ Excluir
- ✅ Ativar/Desativar contratos
- ✅ Gerenciar esteira de ativos

**Bom trabalho! 🎉**

# 🔧 Correção: Erro ao Carregar Contratos Ativos

## ❌ Problema:
```
[cloud_firestore/failed-precondition] The query requires an index.
```

## 🔍 Causa:
A query estava usando `where()` + `orderBy()` em campos diferentes:
```dart
// ❌ ANTES (Requer índice composto no Firestore)
.where('contratoAtivo', isEqualTo: true)
.orderBy('criadoEm', descending: true)
```

Quando você usa filtro (`where`) em um campo e ordenação (`orderBy`) em outro campo diferente, o Firestore requer um índice composto, que precisa ser criado manualmente no Firebase Console.

## ✅ Solução Aplicada:
Removemos o `orderBy()` da query e fazemos a ordenação manualmente no código:

```dart
// ✅ DEPOIS (Não requer índice)
.where('contratoAtivo', isEqualTo: true)
.snapshots()

// Ordenar manualmente os resultados
contratos.sort((a, b) {
  final dadosA = a.data() as Map<String, dynamic>;
  final dadosB = b.data() as Map<String, dynamic>;
  
  final dataA = dadosA['criadoEm'] as Timestamp?;
  final dataB = dadosB['criadoEm'] as Timestamp?;
  
  if (dataA == null && dataB == null) return 0;
  if (dataA == null) return 1;
  if (dataB == null) return -1;
  
  return dataB.compareTo(dataA); // Mais recentes primeiro
});
```

## 🎯 Vantagens da Solução:
1. ✅ **Não requer índice** - Funciona imediatamente
2. ✅ **Mais flexível** - Ordenação personalizada
3. ✅ **Trata valores null** - Não quebra se faltar data
4. ✅ **Performance** - OK para listas pequenas/médias

## 📊 Performance:
- **Ótima** para até 100 clientes ativos
- **Boa** para até 500 clientes ativos
- **Adequada** para até 1000 clientes ativos

Se você tiver milhares de contratos ativos, pode considerar criar o índice composto no futuro.

## 🚀 Como Criar o Índice (Opcional):
Se no futuro você quiser usar ordenação no servidor:

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Vá em **Firestore Database**
3. Clique na aba **Indexes** (Índices)
4. Clique em **Create Index** (Criar Índice)
5. Configure:
   - Collection ID: `clientes`
   - Fields:
     - `contratoAtivo` → Ascending
     - `criadoEm` → Descending

Ou simplesmente clique no link que aparece no erro, que já vai configurado!

## ✅ Testado e Funcionando!
A tela de **Contratos Ativos** agora carrega normalmente, exibindo os clientes com contratos ativos ordenados do mais recente para o mais antigo.

---

**Data da Correção:** 07/11/2025  
**Arquivo Modificado:** `lib/src/organisms/contracts_list_organism.dart`  
**Status:** ✅ Resolvido

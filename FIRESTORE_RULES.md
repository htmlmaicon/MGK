# 🔥 Regras do Firestore

## ⚠️ IMPORTANTE: Configure as regras de segurança

Para que o sistema funcione corretamente, você precisa configurar as regras do Firestore no console do Firebase.

## 📝 Como Configurar

1. Acesse o [Console do Firebase](https://console.firebase.google.com/)
2. Selecione seu projeto
3. No menu lateral, clique em **Firestore Database**
4. Clique na aba **Regras** (Rules)
5. Substitua as regras atuais pelas regras abaixo
6. Clique em **Publicar** (Publish)

## 🔐 Regras Recomendadas

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Função auxiliar para verificar se é admin
    function isAdmin() {
      return request.auth != null && request.auth.token.email == 'admin@gmail.com';
    }

    // Função auxiliar para verificar se está autenticado
    function isAuthenticated() {
      return request.auth != null;
    }

    // Collection: clientes
    match /clientes/{clienteId} {
      // Leitura: qualquer usuário autenticado
      allow read: if isAuthenticated();

      // Criar: apenas admin
      allow create: if isAdmin();

      // Atualizar: admin pode tudo, usuários comuns podem apenas ativar/desativar contrato
      allow update: if isAdmin()
                    || (isAuthenticated() &&
                        request.resource.data.diff(resource.data).affectedKeys()
                        .hasOnly(['contratoAtivo']));

      // Excluir: apenas admin
      allow delete: if isAdmin();
    }

    // Collection: usuarios
    match /usuarios/{userId} {
      // Leitura: apenas o próprio usuário ou admin
      allow read: if isAuthenticated() && (request.auth.uid == userId || isAdmin());

      // Criar: apenas admin (após aprovação)
      allow create: if isAdmin();

      // Atualizar: apenas admin
      allow update: if isAdmin();

      // Excluir: apenas admin
      allow delete: if isAdmin();
    }

    // Collection: solicitacoes_cadastro
    match /solicitacoes_cadastro/{solicitacaoId} {
      // Leitura: apenas admin
      allow read: if isAdmin();

      // Criar: qualquer pessoa (antes de autenticar)
      allow create: if true;

      // Atualizar: apenas admin (para aprovar/rejeitar)
      allow update: if isAdmin();

      // Excluir: apenas admin
      allow delete: if isAdmin();
    }
  }
}
```

## 🚨 Regras para Desenvolvimento (MENOS SEGURO)

Se você está apenas testando e quer acesso total temporário:

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }

    // Permitir criar solicitações sem autenticação
    match /solicitacoes_cadastro/{solicitacaoId} {
      allow create: if true;
    }
  }
}
```

⚠️ **ATENÇÃO:** Não use as regras de desenvolvimento em produção!

## ✅ Após Configurar

1. **Publicar as regras** no console do Firebase
2. **Recarregar o app** (hot reload ou restart)
3. Testar o sistema de solicitações novamente

## 🔍 Verificar se as Regras Estão Ativas

No console do Firebase:

- Firestore Database → Regras
- Verifique a data/hora da última publicação
- Se tiver um alerta amarelo, clique em "Publicar"

---

**Dúvidas?** As regras estão configuradas para:

- ✅ Admin (`admin@gmail.com`) tem acesso total
- ✅ Usuários comuns podem ler e ativar contratos
- ✅ Qualquer pessoa pode criar solicitação de cadastro
- ✅ Apenas admin pode aprovar/rejeitar solicitações

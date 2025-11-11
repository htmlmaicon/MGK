# Sistema de Notificações Push - MGK

## Implementação Completa ✅

Este documento descreve o sistema de notificações push implementado no aplicativo MGK.

## 📋 O que foi implementado

### 1. **Formatadores e Validadores** (`lib/src/utils/formatters.dart`)

Foram criados formatadores e validadores para os seguintes campos:

#### CPF
- **Máscara**: `000.000.000-00`
- **Validação**: Verifica se o CPF é válido usando o algoritmo de dígitos verificadores
- **Uso**: Aplicado automaticamente no campo de CPF do formulário

#### Data (Nascimento e Expedição)
- **Máscara**: `DD/MM/AAAA`
- **Validação**: 
  - Verifica se a data é válida
  - Verifica se não é uma data futura (para datas de nascimento)
  - Valida dias, meses e anos corretos
- **Uso**: Aplicado nos campos de data de nascimento e data de expedição do RG

#### CEP
- **Máscara**: `00000-000`
- **Uso**: Aplicado no campo de CEP

#### Renda
- **Formatação**: Moeda brasileira (R$ 0.000,00)
- **Validação**: Verifica se o valor é maior que zero
- **Uso**: Aplicado no campo de renda bruta

### 2. **Serviço de Notificações** (`lib/src/core/services/notification_service.dart`)

Um serviço completo para gerenciar notificações push usando Firebase Cloud Messaging (FCM).

#### Funcionalidades:
- ✅ Solicita permissão para notificações ao usuário
- ✅ Gerencia tokens FCM dos dispositivos
- ✅ Recebe notificações em foreground e background
- ✅ Mostra notificações locais quando o app está aberto
- ✅ Monitora mudanças de status de clientes no Firestore
- ✅ Envia notificações automáticas quando um cliente é aprovado/rejeitado

#### Métodos principais:

```dart
// Inicializa o serviço
await NotificationService().initialize();

// Monitora status de um cliente específico
NotificationService().monitorarStatusCliente(cpf);

// Envia notificação de aprovação
await NotificationService().notificarAprovacao(
  nomeCliente: "João Silva",
  cpf: "123.456.789-00"
);

// Obtém o token FCM do dispositivo
String? token = await NotificationService().getToken();

// Salva o token no Firestore
await NotificationService().salvarTokenNoFirestore(cpf);
```

### 3. **Integração no Main** (`lib/main.dart`)

O serviço de notificações é inicializado automaticamente quando o app é aberto:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Configura handler de mensagens em background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  
  // Inicializa serviço de notificações
  await NotificationService().initialize();
  
  runApp(const MyApp());
}
```

### 4. **Formulário Atualizado** (`lib/formulario.dart`)

Todos os campos foram atualizados com:
- ✅ Máscaras de entrada automáticas
- ✅ Validações em tempo real
- ✅ Hints visuais para o usuário
- ✅ Validação de CPF com algoritmo correto
- ✅ Formatação de moeda para renda

## 🔧 Configurações Android

### AndroidManifest.xml
Já configurado com:
- Permissões para notificações (INTERNET, POST_NOTIFICATIONS, VIBRATE, WAKE_LOCK)
- Service do Firebase Messaging
- Intent filters para notificações

### Dependências (`pubspec.yaml`)
```yaml
dependencies:
  firebase_messaging: ^16.0.4
  flutter_local_notifications: ^18.0.1
  mask_text_input_formatter: ^2.9.0
  intl: ^0.19.0
```

## 📱 Como usar o sistema de notificações

### Para o usuário final:

1. **Ao preencher o formulário**:
   - Os campos CPF, data e renda são formatados automaticamente
   - O sistema valida os dados em tempo real
   - Mensagens de erro aparecem se algo estiver incorreto

2. **Após enviar o cadastro**:
   - O usuário receberá uma notificação push quando seu cadastro for aprovado ou rejeitado
   - A notificação aparece mesmo se o app estiver fechado
   - Ao tocar na notificação, o app abre automaticamente

### Para o administrador:

1. **Aprovar um cliente**:
   - No Firestore, atualize o campo `status` do cliente para `"aprovado"`
   - O sistema enviará automaticamente uma notificação para o dispositivo do cliente

2. **Rejeitar um cliente**:
   - Atualize o campo `status` para `"rejeitado"`
   - Uma notificação será enviada informando a rejeição

## 🔐 Estrutura no Firestore

Para o sistema funcionar corretamente, o documento do cliente deve ter:

```javascript
{
  "nome": "João Silva",
  "cpf": "12345678900", // Sem máscara
  "status": "pendente", // "aprovado" ou "rejeitado"
  "fcmToken": "token_do_dispositivo",
  "tokenAtualizadoEm": Timestamp
}
```

## 🧪 Testando as notificações

### Teste 1: Validação de campos
1. Abra o formulário de cadastro
2. Tente digitar um CPF inválido (ex: 111.111.111-11)
3. O sistema deve mostrar "CPF inválido"

### Teste 2: Formatação automática
1. Digite apenas números no campo CPF
2. A máscara será aplicada automaticamente (000.000.000-00)
3. Digite valores no campo de renda
4. O formato R$ será aplicado automaticamente

### Teste 3: Notificação de aprovação
1. Cadastre um cliente
2. No Firebase Console, vá para Firestore
3. Encontre o documento do cliente pelo CPF
4. Altere o campo `status` para `"aprovado"`
5. O usuário deve receber uma notificação: "🎉 Cadastro Aprovado!"

## 🚀 Próximos passos (opcional)

Para melhorar ainda mais o sistema:

1. **Adicionar tela de detalhes**: Ao tocar na notificação, abrir uma tela com detalhes do status
2. **Histórico de notificações**: Mostrar todas as notificações recebidas
3. **Notificações personalizadas**: Por tipo de cliente (Agricultor, Assalariado, etc)
4. **Push notifications remotas**: Enviar notificações do painel administrativo
5. **Analytics**: Rastrear quantos usuários recebem e abrem as notificações

## ⚠️ Observações importantes

- O sistema requer que o Firebase esteja configurado corretamente
- As notificações só funcionam em dispositivos físicos (não no emulador para Android)
- O usuário precisa conceder permissão para receber notificações
- Para iOS, configurações adicionais são necessárias no Xcode

## 📝 Resumo das alterações

| Arquivo | Status | Descrição |
|---------|--------|-----------|
| `pubspec.yaml` | ✅ Atualizado | Adicionadas dependências de notificações e formatadores |
| `lib/src/utils/formatters.dart` | ✅ Criado | Formatadores e validadores para CPF, data e renda |
| `lib/src/core/services/notification_service.dart` | ✅ Criado | Serviço completo de notificações FCM |
| `lib/formulario.dart` | ✅ Atualizado | Aplicadas máscaras e validações em todos os campos |
| `lib/main.dart` | ✅ Atualizado | Inicialização do serviço de notificações |
| `android/app/src/main/AndroidManifest.xml` | ✅ Configurado | Permissões e services do FCM |

---

**Status**: ✅ Implementação completa e funcional
**Data**: 11/11/2025

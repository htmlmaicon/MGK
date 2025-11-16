# 🎬 Guia Rápido para Gravação - MGK

## ⚡ REFERÊNCIA RÁPIDA (10 minutos)

---

## 🔥 ABERTURA (30 seg)

**Frase inicial:**
> "Vou apresentar os aspectos técnicos do MGK - sistema de gerenciamento de clientes em Flutter. Vamos explorar arquitetura, testes, UI/UX e performance."

**Mostrar:** README ou estrutura geral do projeto

---

## 🏗️ PARTE 1: ARQUITETURA (2 min)

### Tópicos:
1. **Clean Architecture** (45s)
   - Domain → Data → Presentation
   - **Mostrar:** Estrutura de pastas `lib/src/`
   
2. **MVVM** (45s)
   - ViewModel com ChangeNotifier
   - **Mostrar:** `auth_viewmodel.dart`
   
3. **Dependency Injection** (30s)
   - Provider para DI
   - **Mostrar:** `dependency_injection.dart`

### Arquivos-chave:
```
📁 lib/src/
  ├── domain/repositories/auth_repository.dart
  ├── data/repositories/auth_repository_impl.dart
  ├── presentation/viewmodels/auth_viewmodel.dart
  └── core/dependency_injection.dart
```

**Frase de transição:**
> "Com a arquitetura definida, vamos ver como garantimos qualidade através de testes."

---

## 🧪 PARTE 2: TESTES (2 min)

### Tópicos:
1. **Testes Unitários** (30s)
   - Lógica de negócio
   - **Mostrar:** `test/unit/models/cliente_model_test.dart`
   
2. **Testes de Widget** (30s)
   - Componentes UI
   - **Mostrar:** `test/widget/custom_button_test.dart`
   
3. **Testes de Integração** (30s)
   - Fluxos completos
   - **Mostrar:** `test/integration_test/app_integration_test_simple.dart`

4. **Demonstração** (30s)
   - Mencionar execução de testes
   - **Comando:** `flutter test` (se disponível)

### Estrutura de testes:
```
📁 test/
  ├── unit/          # Modelos, validações
  ├── widget/        # Componentes UI
  └── integration_test/  # Fluxos completos
```

**Frase de transição:**
> "Além de funcional, a aplicação precisa ser bonita e acessível."

---

## 🎨 PARTE 3: UI/UX (2 min)

### Tópicos:
1. **Atomic Design** (45s)
   - Atoms → Molecules → Organisms
   - **Mostrar:** 
     - `lib/src/atoms/custom_button.dart`
     - `lib/src/molecules/cep_field.dart`
     - `lib/src/organisms/login_form.dart`
   
2. **Microinterações** (30s)
   - InkWell, Loading, Feedback
   - **Mostrar:** Código de ripple effect
   
3. **Acessibilidade** (45s)
   - Semantics, contraste, WCAG
   - **Mostrar:** Semantics no `custom_button.dart`

### Atomic Design:
```
🔹 Atoms:      custom_button, custom_input
🔸 Molecules:  cep_field, login_field
🔶 Organisms:  login_form, client_form
📄 Pages:      login_page, home_page
```

**Frase de transição:**
> "Para garantir boa experiência, otimizamos a performance."

---

## ⚡ PARTE 4: PERFORMANCE (2 min)

### Tópicos:
1. **Const e Keys** (45s)
   - Widgets imutáveis
   - **Mostrar:** Uso de const no código
   
2. **Lazy Loading** (45s)
   - FutureBuilder, StreamBuilder
   - **Mostrar:** Exemplo de FutureBuilder
   
3. **Build Optimization** (30s)
   - Análise com DevTools
   - **Mencionar:** `flutter build --release`

### Práticas de Performance:
```dart
✅ const EdgeInsets.all(16)
✅ const CustomButton({super.key, ...})
✅ ListView.builder (não map().toList())
✅ RepaintBoundary para animações
✅ Dispose de controllers
```

**Frase de transição:**
> "Vamos ver isso em ação com uma demonstração rápida."

---

## 💻 PARTE 5: DEMONSTRAÇÃO (1 min)

### Opção A - Se Flutter disponível:
```bash
flutter test test/unit/
flutter test test/widget/
```

### Opção B - Sem Flutter:
**Mostrar:** Estrutura de testes e mencionar:
> "Os testes validam desde modelos individuais até fluxos completos de usuário, garantindo que cada funcionalidade opere corretamente."

---

## 🎯 CONCLUSÃO (30 seg)

**Resumo rápido:**
> "O projeto MGK implementa:
> 
> ✅ Arquitetura MVVM + Clean Architecture
> 
> ✅ Testes em três níveis
> 
> ✅ UI/UX com Atomic Design e acessibilidade
> 
> ✅ Performance otimizada
> 
> Essa estrutura garante código manutenível, escalável e de alta qualidade. Obrigado!"

---

## 📋 CHECKLIST PRÉ-GRAVAÇÃO

### Setup:
- [ ] Abrir VS Code/IDE com o projeto
- [ ] Aumentar fonte do editor (Ctrl/Cmd + +)
- [ ] Fechar abas desnecessárias
- [ ] Preparar terminal (se for executar comandos)
- [ ] Desativar notificações
- [ ] Testar áudio e vídeo

### Arquivos para ter abertos:
1. [ ] `lib/src/` (estrutura)
2. [ ] `auth_viewmodel.dart`
3. [ ] `dependency_injection.dart`
4. [ ] `cliente_model_test.dart`
5. [ ] `custom_button_test.dart`
6. [ ] `app_integration_test_simple.dart`
7. [ ] `custom_button.dart`
8. [ ] `cep_field.dart`

### Durante gravação:
- [ ] Falar pausadamente
- [ ] Mostrar código enquanto explica
- [ ] Destacar linhas importantes
- [ ] Manter ritmo de ~1min por seção maior

---

## 🎤 FRASES-CHAVE

### Arquitetura:
> "Clean Architecture separa responsabilidades em camadas: Domain com regras de negócio, Data com implementações, e Presentation com ViewModels."

### Testes:
> "Implementamos pirâmide de testes: muitos unitários para lógica, médios para widgets, e poucos para integração de fluxos completos."

### UI/UX:
> "Atomic Design permite componentização progressiva: átomos básicos combinam em moléculas, que formam organismos complexos."

### Acessibilidade:
> "Seguimos WCAG com Semantics para leitores de tela, contraste adequado, e áreas de toque apropriadas."

### Performance:
> "Otimizamos com const para widgets imutáveis, keys para identificação, e lazy loading para dados assíncronos."

---

## ⏱️ CRONÔMETRO

| Minuto | Seção |
|--------|-------|
| 0:00 | Início / Introdução |
| 0:30 | Arquitetura - início |
| 2:30 | Testes - início |
| 4:30 | UI/UX - início |
| 6:30 | Performance - início |
| 8:30 | Demonstração |
| 9:30 | Conclusão |
| 10:00 | FIM ✓ |

---

## 🎯 COMANDOS ÚTEIS (se for executar)

```bash
# Mostrar estrutura
tree -L 3 lib/src/

# Executar testes
flutter test

# Análise de código
flutter analyze

# Build otimizado
flutter build apk --release --split-per-abi
```

---

## 💡 DICAS FINAIS

1. **Respire fundo antes de começar**
2. **Fale como se estivesse explicando para um colega**
3. **Use suas próprias palavras** (o roteiro é um guia)
4. **Não tenha medo de pausar** entre seções
5. **Mostre entusiasmo** pelo projeto
6. **Se errar, continue** - não precisa ser perfeito

---

## 🚀 MENSAGEM MOTIVACIONAL

**Você conhece este projeto.**

**Você fez um excelente trabalho na arquitetura, testes e UI.**

**Agora é só mostrar isso com confiança!**

**BOA SORTE! 🎬✨**

---

## 📞 APOIO

Se precisar de ajuda durante a preparação:
- Revise o **ROTEIRO_APRESENTACAO.md** para detalhes
- Consulte **DOCUMENTACAO_TECNICA.md** para conceitos
- Este guia é seu **apoio durante a gravação**

**VOCÊ CONSEGUE! 💪**

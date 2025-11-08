# MGK - Sistema de Cadastro

Sistema de gerenciamento de clientes com funcionalidades de cadastro e consulta.

## Funcionalidades Implementadas

### UI/UX
- **Atomic Design**: Componentes organizados em átomos, moléculas e organismos
- **Microinterações**: Feedback visual em botões e campos de formulário
- **Acessibilidade**: Semantics para leitores de tela e contraste adequado

### Consumo de API
- **ViaCEP**: Integração para busca automática de endereços
- **JSONPlaceholder**: Consumo de API pública para exibição de posts
- **FutureBuilder**: Tratamento de estados assíncronos (carregando, erro, dados)

### Formulários e Validação
- Formulário completo com validação em todos os campos
- Validação customizada com mensagens de erro específicas
- Campos para diferentes tipos de clientes (Agricultor, Assalariado, Aposentado/Pensionista)

## Tecnologias Utilizadas
- Flutter SDK
- HTTP para consumo de APIs RESTful
- Material Design

## Como executar
1. Clone o repositório
2. Execute `flutter pub get`
3. Execute `flutter run`

## Estrutura do Projeto
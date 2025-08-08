# Pokedex - Rick and Morty App

Um aplicativo Flutter que consome a API do Rick and Morty para exibir personagens da série. O projeto foi desenvolvido seguindo boas práticas de arquitetura, com separação de responsabilidades, injeção de dependências e testes unitários.

##  Funcionalidades

- Lista de personagens com paginação infinita
- Detalhes completos de cada personagem
- Tratamento de erros de rede
- Modo offline com dados mock
- Interface responsiva e moderna (desktop e mobile)
- Layout adaptativo com preview de personagens
- Pull-to-refresh na lista
- Testes unitários abrangentes
- Sistema de logging configurado

## Arquitetura

O projeto segue a arquitetura **MVVM Architecture** com **BLoC Pattern** para gerenciamento de estado:

```
lib/
├── core/                    # Camada de infraestrutura
│   ├── constants/          # Constantes da aplicação
│   ├── dependency_injection.dart  # Injeção de dependências
│   ├── error/             # Tratamento de erros
│   ├── router.dart        # Configuração de rotas
│   ├── theme/             # Tema da aplicação
│   └── utils/             # Utilitários
├── models/                 # Modelos de dados
├── services/              # Serviços de API
├── view_models/           # BLoCs/Cubits
├── views/                 # Telas da aplicação
└── widgets/               # Widgets reutilizáveis
```

### Estrutura Detalhada

####  `lib/core/`
- **constants/**: Constantes da aplicação (URLs, timeouts, etc.)
- **dependency_injection.dart**: Configuração do GetIt para injeção de dependências
- **error/**: Classes de erro customizadas
- **router.dart**: Configuração de rotas com GoRouter
- **theme/**: Definição de cores, estilos e tema da aplicação
- **utils/**: Utilitários como logger

####  `lib/models/`
- **api_response.dart**: Modelo para resposta da API
- **character.dart**: Modelo do personagem

####  `lib/services/`
- **rick_and_morty_service.dart**: Serviço para consumir a API do Rick and Morty

####  `lib/view_models/`
- **characters_cubit.dart**: Gerenciamento de estado da lista de personagens
- **characters_state.dart**: Estados da lista de personagens
- **character_detail_cubit.dart**: Gerenciamento de estado dos detalhes
- **character_detail_state.dart**: Estados dos detalhes do personagem

####  `lib/views/`
- **characters_list_view.dart**: Tela da lista de personagens
- **character_detail_view.dart**: Tela de detalhes do personagem

####  `lib/widgets/`
- **app_header.dart**: Header da aplicação
- **character_card.dart**: Card de personagem para a lista
- **character_preview.dart**: Preview lateral do personagem selecionado
- **character_list.dart**: Lista de personagens com scroll
- **character_detail_header.dart**: Header da tela de detalhes
- **character_info_section.dart**: Seção de informações do personagem
- **error_widget.dart**: Widget de erro reutilizável

##  Como Executar

### Pré-requisitos

- Flutter SDK (versão 3.6.2 ou superior)
- Dart SDK
- Android Studio / VS Code
- Emulador Android ou dispositivo físico

### Instalação

1. **Clone o repositório**
```bash
git clone https://github.com/Vitu26/pokedex-rick-and-morty.git
cd pokedex
```

2. **Instale as dependências**
```bash
flutter pub get
```

3. **Execute o aplicativo**
```bash
flutter run
```

### Configurações de Rede

O projeto já está configurado para permitir conexões HTTP/HTTPS:

#### Android
- Permissões de internet adicionadas no `AndroidManifest.xml`
- Configuração de segurança de rede em `network_security_config.xml`

#### iOS
- Configurações de App Transport Security no `Info.plist`

##  Testes

### Estrutura de Testes
```
test/
├── all_tests.dart              # Execução de todos os testes
├── services/                   # Testes de serviços
│   ├── rick_and_morty_service_test.dart
│   └── rick_and_morty_service_test.mocks.dart
├── view_models/               # Testes de BLoCs/Cubits
│   ├── characters_cubit_test.dart
│   ├── characters_cubit_test.mocks.dart
│   ├── character_detail_cubit_test.dart
│   └── character_detail_cubit_test.mocks.dart
└── widgets/                   # Testes de widgets
    └── error_widget_test.dart
```

### Executar todos os testes
```bash
flutter test
```

### Executar testes específicos
```bash
flutter test test/services/rick_and_morty_service_test.dart
flutter test test/view_models/characters_cubit_test.dart
flutter test test/view_models/character_detail_cubit_test.dart
flutter test test/widgets/error_widget_test.dart
```

##  Dependências

### Principais
- **flutter_bloc**: Gerenciamento de estado (Cubit)
- **http**: Cliente HTTP para requisições
- **get_it**: Injeção de dependências
- **go_router**: Navegação declarativa
- **cached_network_image**: Cache de imagens
- **equatable**: Comparação de objetos

### Desenvolvimento
- **bloc_test**: Testes para BLoC
- **mockito**: Mocking para testes
- **build_runner**: Geração de código

##  Configurações

### API
- **Base URL**: `https://rickandmortyapi.com/api`
- **Timeout**: 30 segundos
- **Endpoint**: `/character`

### Tratamento de Erros
- **NetworkError**: Erro de conectividade
- **ServerError**: Erro do servidor (5xx)
- **NotFoundError**: Recurso não encontrado (404)
- **TimeoutError**: Timeout de requisição
- **UnknownError**: Erro desconhecido

### Modo Offline
O aplicativo possui um sistema de dados mock que é ativado automaticamente quando há problemas de conectividade.

##  Telas

### Lista de Personagens
- Exibe personagens em cards
- Paginação infinita
- Pull-to-refresh
- Layout responsivo (desktop/mobile)
- Preview lateral do personagem selecionado
- Tratamento de estados de loading e erro

### Detalhes do Personagem
- Informações completas do personagem
- Imagem em alta resolução
- Dados de origem e localização
- Lista de episódios
- Status visual (vivo/morto/desconhecido)
- Gênero com ícones específicos

##  Design

O aplicativo segue o Material Design 3 com:
- Cores personalizadas
- Tipografia consistente
- Animações suaves
- Interface responsiva

##  Debugging

### Logs
O projeto possui um sistema de logging configurado:
- Logs de requisições API
- Logs de erros
- Logs de performance


##  Checklist de Configuração

- [x] Permissões de internet (Android)
- [x] Configuração de segurança de rede (Android)
- [x] App Transport Security (iOS)
- [x] Injeção de dependências
- [x] Tratamento de erros
- [x] Testes unitários
- [x] Modo offline
- [x] Logging
- [x] Documentação
- [x] Layout responsivo
- [x] Sistema de rotas
- [x] Tema personalizado
- [x] Widgets reutilizáveis






# Gimie app

Um aplicativo Flutter para salvar e gerenciar links de produtos.

## 🆕 Atualizações Recentes (2026-01-01)

### Correções Implementadas
- ✅ **Deep Linking**: Implementado suporte completo para receber URLs via deep links
- ✅ **Share Intent**: Configurado Android e iOS para receber URLs compartilhadas
- ✅ **API**: Corrigido valor padrão inválido e adicionado suporte robusto
- ✅ **Share Extension iOS**: Corrigido App Group e redirecionamento

### 📚 Documentação
- [RELATORIO_EXECUTIVO.md](RELATORIO_EXECUTIVO.md) - Resumo executivo das correções
- [GUIA_DEPLOY.md](GUIA_DEPLOY.md) - Guia rápido de implementação
- [RESUMO_CORRECOES.md](RESUMO_CORRECOES.md) - Detalhamento técnico completo
- [API_DEEPLINK_TEST.md](API_DEEPLINK_TEST.md) - Testes e validação da API

## Getting Started

### Pré-requisitos
- Flutter SDK (stable release)
- Xcode (para iOS)
- Android Studio (para Android)

### Instalação

```bash
# 1. Instalar dependências
flutter pub get

# 2. iOS: Instalar pods
cd ios && pod install && cd ..

# 3. Rodar app
flutter run
```

### Testar Deep Links

**Android:**
```bash
adb shell am start -W -a android.intent.action.VIEW \
  -d "gimieapp://gimie.tech?url=https://www.amazon.com.br/produto"
```

**iOS:**
```bash
xcrun simctl openurl booted \
  "gimieapp://gimie.tech?url=https://www.amazon.com.br/produto"
```

## 🔧 Configuração iOS

### App Groups no Xcode
1. Abrir `ios/Runner.xcworkspace`
2. Selecionar target **Runner**
3. Aba **Signing & Capabilities** → Add **App Groups**
4. Marcar: `group.com.mycompany.gimieapp`
5. Repetir para target **Gimie ShareExtension**

## 🌐 API Backend

A API deve implementar o endpoint:

```
POST https://gimieapi.onrender.com/links
Content-Type: application/json

Body: {"url": "https://..."}
```

Ver exemplo completo em `api_server_example.js`

## 🧪 Scripts de Teste

```bash
# Testar API
./test_api.sh

# Build Android
flutter build apk --release

# Build iOS
flutter build ios --release
```

## 📱 Funcionalidades

- 🔗 Receber URLs via deep linking
- 📤 Receber URLs compartilhadas de outros apps
- 🛍️ Processar links de produtos
- 💾 Salvar produtos no Firestore
- 👤 Gerenciamento de perfil de usuário

## 🏗️ Estrutura do Projeto

```
lib/
  ├── main.dart              # Entry point + Deep link handler
  ├── app_state.dart         # Estado global da aplicação
  ├── backend/
  │   └── api_requests/      # Chamadas de API
  ├── components/            # Componentes reutilizáveis
  └── flutter_flow/          # Utilitários FlutterFlow

android/                     # Configuração Android
ios/                         # Configuração iOS + Share Extension
firebase/                    # Firebase Functions
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob licença privada.

---

Para mais detalhes sobre as correções recentes, consulte [RELATORIO_EXECUTIVO.md](RELATORIO_EXECUTIVO.md).

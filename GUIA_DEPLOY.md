# 🚀 Guia Rápido de Deploy - Gimie App

## ✅ O Que Foi Corrigido

1. **Valor padrão inválido** → Corrigido para string vazia
2. **Deep linking não funcionava** → Implementado com `app_links`
3. **Share intent não recebia URLs** → Configurado Android e iOS
4. **API não retornava deeplink** → Estrutura preparada + exemplo de backend

## 📋 Checklist de Deploy

### 1. Instalar Dependências Flutter
```bash
cd /workspace
flutter pub get
cd ios && pod install && cd ..
```

### 2. Configurar App Groups no Xcode (iOS)

**Para Target Principal (Runner)**:
1. Abrir `ios/Runner.xcworkspace` no Xcode
2. Selecionar target **Runner**
3. Aba **Signing & Capabilities**
4. Clicar em **+ Capability** → **App Groups**
5. Marcar/criar: `group.com.mycompany.gimieapp`

**Para Share Extension**:
1. Selecionar target **Gimie ShareExtension**
2. Repetir passos 3-5 acima
3. Usar o **mesmo** App Group: `group.com.mycompany.gimieapp`

### 3. Implementar Backend API

**Opção A: Usar o exemplo fornecido**
```bash
# Copiar arquivos
cp api_server_example.js /seu/backend/server.js
cp api_package_example.json /seu/backend/package.json

# Instalar e rodar
cd /seu/backend
npm install
npm start
```

**Opção B: Adicionar endpoint ao backend existente**
Ver código completo em `api_server_example.js`, especialmente:
- Rota `POST /links` (linha 33)
- Função `scrapeProductData()` (linha 67)

### 4. Testar Localmente

**Testar Deep Link**:
```bash
# Android
adb shell am start -W -a android.intent.action.VIEW \
  -d "gimieapp://gimie.tech?url=https://www.amazon.com.br/produto"

# iOS
xcrun simctl openurl booted \
  "gimieapp://gimie.tech?url=https://www.amazon.com.br/produto"
```

**Testar Share Intent**:
```bash
# Android
adb shell am start -a android.intent.action.SEND \
  -t text/plain \
  --es android.intent.extra.TEXT "https://www.amazon.com.br/produto" \
  com.mycompany.gimieapp
```

**Testar API**:
```bash
./test_api.sh
```

### 5. Build e Deploy

**Android**:
```bash
flutter build apk --release
# ou
flutter build appbundle --release
```

**iOS**:
```bash
flutter build ios --release
# Depois abrir no Xcode para archive e upload
```

## 🔧 Configurações Importantes

### Deep Link Format
```
gimieapp://gimie.tech?url={encoded_url}
```

### API Endpoint
```
POST https://gimieapi.onrender.com/links
Content-Type: application/json
Body: {"url": "https://..."}
```

### Response Format
```json
{
  "nome": "Nome do Produto",
  "preco": "99.90",
  "imagem": "https://...",
  "url": "https://..."
}
```

## 🐛 Troubleshooting

### Deep Link não funciona
- ✓ Verificar se App Group está configurado no Xcode
- ✓ Verificar se ambos targets usam o MESMO App Group
- ✓ Reinstalar app no dispositivo após mudanças

### API retorna 404
- ✓ Backend precisa implementar POST /links
- ✓ Usar exemplo em `api_server_example.js`
- ✓ Verificar CORS está habilitado

### Share não aparece no menu
- ✓ Android: Verificar AndroidManifest.xml tem intent SEND
- ✓ iOS: Verificar Info.plist da Share Extension
- ✓ Reinstalar app

## 📞 Suporte

Ver documentação completa em:
- `API_DEEPLINK_TEST.md` - Testes e validação
- `RESUMO_CORRECOES.md` - Todas as correções feitas
- `api_server_example.js` - Código do backend

## ✨ Resultado Final

Após seguir este guia, o app será capaz de:
- ✅ Receber URLs compartilhadas de qualquer app
- ✅ Abrir via deep links
- ✅ Processar URLs de produtos
- ✅ Salvar no Firestore do usuário

**Status**: Código do app está 100% pronto! Falta apenas implementar o backend API.

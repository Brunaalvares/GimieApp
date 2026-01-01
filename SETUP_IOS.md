# 🍎 Guia de Setup iOS - Gimie App

## ⚠️ Importante
Este ambiente remoto **não tem Flutter instalado**. Você precisa executar estes comandos na sua **máquina local** (Mac).

## 🚀 Opção 1: Script Automatizado (Recomendado)

Execute o script fornecido:

```bash
cd /caminho/para/workspace
./setup_ios.sh
```

O script executará automaticamente todos os passos necessários.

## 📝 Opção 2: Comandos Manuais

Execute cada comando na sua máquina local:

### 1. Limpar projeto
```bash
cd /caminho/para/workspace
flutter clean
```
**O que faz**: Remove arquivos de build antigos

### 2. Instalar dependências Flutter
```bash
flutter pub get
```
**O que faz**: Baixa as dependências do pubspec.yaml (incluindo app_links e receive_sharing_intent)

### 3. Build iOS sem assinatura
```bash
flutter build ios --no-codesign
```
**O que faz**: Gera os arquivos necessários para iOS sem exigir certificado de desenvolvedor

### 4. Entrar no diretório iOS
```bash
cd ios
```

### 5. Instalar CocoaPods
```bash
pod install
```
**O que faz**: Instala as dependências nativas iOS (incluindo Firebase, Google Sign-In, etc.)

**Nota**: Se não tiver CocoaPods instalado:
```bash
sudo gem install cocoapods
```

### 6. Voltar ao diretório raiz
```bash
cd ..
```

### 7. Abrir Xcode
```bash
open ios/Runner.xcworkspace
```
**Importante**: Sempre abra o `.xcworkspace`, NÃO o `.xcodeproj`

## ⚙️ Configuração no Xcode (OBRIGATÓRIO)

Após abrir o Xcode, você DEVE configurar os App Groups:

### Para o Target "Runner":
1. Selecione o projeto "Runner" na barra lateral
2. Selecione o target **"Runner"**
3. Vá para a aba **"Signing & Capabilities"**
4. Clique no botão **"+ Capability"**
5. Procure e adicione **"App Groups"**
6. Marque/crie o grupo: `group.com.mycompany.gimieapp`

### Para o Target "Gimie ShareExtension":
1. Selecione o target **"Gimie ShareExtension"**
2. Repita os passos 3-6 acima
3. **IMPORTANTE**: Use o MESMO App Group: `group.com.mycompany.gimieapp`

### Captura Visual do Processo:
```
Xcode → Project Navigator → Runner
   ↓
[Targets]
   ├── Runner ← Configure aqui primeiro
   └── Gimie ShareExtension ← Configure aqui também
   
Em cada target:
   Signing & Capabilities
   ↓
   + Capability
   ↓
   App Groups
   ↓
   ☑️ group.com.mycompany.gimieapp
```

## 🔍 Verificação

Após a configuração, verifique:

- [ ] Flutter clean executado sem erros
- [ ] Flutter pub get baixou todas as dependências
- [ ] Pod install completou sem erros
- [ ] Xcode abriu o workspace (não o project)
- [ ] Target "Runner" tem App Group configurado
- [ ] Target "Gimie ShareExtension" tem App Group configurado
- [ ] AMBOS targets usam o MESMO App Group

## ⚠️ Problemas Comuns

### "Pod install failed"
```bash
# Limpar cache do CocoaPods
cd ios
rm -rf Pods Podfile.lock
pod install --repo-update
cd ..
```

### "Flutter command not found"
Adicione Flutter ao PATH:
```bash
export PATH="$PATH:/caminho/para/flutter/bin"
```

### "Unable to open workspace"
Certifique-se de abrir o arquivo `.xcworkspace`:
```bash
# Correto ✅
open ios/Runner.xcworkspace

# Errado ❌
open ios/Runner.xcodeproj
```

### "App Group não aparece"
1. Certifique-se de ter uma conta de desenvolvedor Apple configurada
2. Em Signing, selecione seu Team
3. O App Group deve aparecer ou pode ser criado

## 🧪 Testando

Após a configuração, você pode testar deep links:

### No Simulador iOS:
```bash
xcrun simctl openurl booted "gimieapp://gimie.tech?url=https://www.amazon.com.br/produto"
```

### No Dispositivo Real:
Use o Safari para abrir: `gimieapp://gimie.tech?url=https://www.amazon.com.br/produto`

## 📚 Mais Informações

- [GUIA_DEPLOY.md](GUIA_DEPLOY.md) - Guia completo de deploy
- [RELATORIO_EXECUTIVO.md](RELATORIO_EXECUTIVO.md) - Resumo das correções
- [API_DEEPLINK_TEST.md](API_DEEPLINK_TEST.md) - Como testar a API

## ✅ Próximos Passos

Após completar este setup:

1. Configure seu certificado de desenvolvedor no Xcode
2. Conecte um dispositivo ou use o simulador
3. Clique em "Run" (⌘R) no Xcode
4. Teste a funcionalidade de deep linking
5. Teste compartilhar uma URL de outro app

---

**Precisa de ajuda?** Consulte a documentação completa nos arquivos MD do projeto.

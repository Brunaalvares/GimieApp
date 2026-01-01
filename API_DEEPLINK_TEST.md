# Teste de API e Deep Link - Gimie App

## Problemas Identificados e Corrigidos

### 1. Valor Padrão Incorreto
**Problema**: O valor padrão do link estava como `'urlaqui[link]'` em vez de uma string vazia.
**Arquivos corrigidos**:
- `lib/app_state.dart`: Alterado de `'urlaqui[link]'` para `''`
- `lib/backend/api_requests/api_calls.dart`: Alterado o parâmetro padrão de `'urlaqui[link]'` para `''`

### 2. Falta de Tratamento de Deep Links
**Problema**: O app não tinha código para receber URLs via deep linking ou share intent.
**Arquivos modificados**:
- `lib/main.dart`: Adicionado `app_links` e `receive_sharing_intent` para capturar URLs
- `pubspec.yaml`: Adicionadas dependências `app_links: ^6.3.2` e `receive_sharing_intent: ^1.8.0`
- `android/app/src/main/AndroidManifest.xml`: Adicionado intent filter para SEND action
- `ios/Gimie ShareExtension/ShareViewController.swift`: Corrigido App Group e adicionado deep link redirect

### 3. Share Extension iOS com App Group Incorreto
**Problema**: O ShareViewController usava `"group.com.suaempresa.seuprojeto"` em vez do correto.
**Correção**: Alterado para `"group.com.mycompany.gimieapp"` e adicionado código para abrir o app principal com deep link.

## Como a API Deve Funcionar

### Requisição
```bash
POST https://gimieapi.onrender.com/links
Content-Type: application/json

{
  "url": "https://www.amazon.com.br/produto-exemplo"
}
```

### Resposta Esperada
A API deve retornar um objeto JSON ou array com os seguintes campos:

```json
{
  "nome": "Nome do Produto",
  "preco": "99.90",
  "imagem": "https://url-da-imagem.com/imagem.jpg",
  "url": "https://www.amazon.com.br/produto-exemplo"
}
```

OU formato array:

```json
[{
  "nome": "Nome do Produto",
  "preco": "99.90",
  "imagem": "https://url-da-imagem.com/imagem.jpg",
  "url": "https://www.amazon.com.br/produto-exemplo"
}]
```

### Deep Link Format
Quando o app recebe uma URL via share ou deep link, ela deve ser no formato:

```
gimieapp://gimie.tech?url=https%3A%2F%2Fwww.amazon.com.br%2Fproduto
```

## Como Testar

### 1. Testar a API diretamente
```bash
curl -X POST https://gimieapi.onrender.com/links \
  -H "Content-Type: application/json" \
  -d '{"url":"https://www.amazon.com.br/produto-teste"}'
```

### 2. Testar Deep Link (Android)
```bash
adb shell am start -W -a android.intent.action.VIEW -d "gimieapp://gimie.tech?url=https://www.amazon.com.br/produto"
```

### 3. Testar Deep Link (iOS)
```bash
xcrun simctl openurl booted "gimieapp://gimie.tech?url=https://www.amazon.com.br/produto"
```

### 4. Testar Share Intent (Android)
```bash
adb shell am start -a android.intent.action.SEND \
  -t text/plain \
  --es android.intent.extra.TEXT "https://www.amazon.com.br/produto" \
  com.mycompany.gimieapp
```

## Fluxo Completo

1. **Usuário compartilha URL** → App recebe via `receive_sharing_intent` ou deep link
2. **URL salva em FFAppState** → `FFAppState().link` recebe a URL
3. **Usuário abre AddLinkWidget** → Campo de texto pré-preenchido com URL de `FFAppState().link`
4. **Usuário clica em Salvar** → App envia URL para API
5. **API processa e retorna dados** → App extrai nome, preço, imagem e URL
6. **App salva no Firestore** → Produto adicionado à lista do usuário

## Verificação dos Extractors

Os extractors em `api_calls.dart` suportam ambos formatos (objeto e array):

```dart
static String? nome(dynamic response) {
  final direct = getJsonField(response, r'''$.nome''');
  if (direct != null && direct.toString().isNotEmpty) {
    return castToType<String>(direct);
  }
  return castToType<String>(getJsonField(response, r'''$[0].nome'''));
}
```

## Status da API (Atualização)

⚠️ **IMPORTANTE**: Atualmente a API `https://gimieapi.onrender.com/links` **NÃO suporta POST**.

### Status Atual
- ✅ **GET** `/links` - Funcionando (retorna dados mockados)
- ❌ **POST** `/links` - Retorna 404 "Cannot POST /links"

### Teste Realizado
```bash
# GET funciona
$ curl -s https://gimieapi.onrender.com/links
[{"nome":"Tênis Nike","preco":"R$ 399,90","imagem":"https://exemplo.com/tenis.jpg","url":"https://nike.com/tenis"}]

# POST não funciona
$ curl -X POST https://gimieapi.onrender.com/links \
  -H "Content-Type: application/json" \
  -d '{"url":"https://www.amazon.com.br/produto"}'
<!DOCTYPE html>
...
<pre>Cannot POST /links</pre>
```

### Ação Necessária

A API backend precisa implementar o endpoint POST para processar URLs de produtos. O endpoint deve:

1. Receber uma requisição POST com body JSON:
```json
{
  "url": "https://www.amazon.com.br/produto-exemplo"
}
```

2. Fazer scraping da URL para extrair:
   - Nome do produto
   - Preço
   - URL da imagem
   - URL original

3. Retornar JSON com os dados:
```json
{
  "nome": "Nome do Produto",
  "preco": "99.90",
  "imagem": "https://url-da-imagem.com/imagem.jpg",
  "url": "https://www.amazon.com.br/produto-exemplo"
}
```

### Solução Temporária

Foi adicionado um método `callGet()` na classe `SalvarLinkCall` como fallback para testes quando o POST não estiver disponível.

## Status das Correções

✅ Valor padrão de link corrigido
✅ Handler de deep link implementado
✅ Share intent configurado (Android e iOS)
✅ App Group corrigido no ShareViewController
✅ Packages adicionados (app_links, receive_sharing_intent)
✅ AndroidManifest atualizado com intent filter SEND
✅ Extractors suportam ambos formatos de resposta
✅ Método GET alternativo adicionado (callGet) para fallback
⚠️ API backend precisa implementar POST /links (exemplo fornecido)

## Arquivos de Exemplo para Backend API

Foram criados arquivos de exemplo para implementar o backend da API:

- `api_server_example.js` - Servidor Express com scraping de produtos
- `api_package_example.json` - Dependências necessárias
- `test_api.sh` - Script de teste da API

### Para implementar o backend:

```bash
# 1. Instalar dependências
npm install --save express axios cheerio cors

# 2. Executar servidor
node api_server_example.js

# 3. Testar endpoint
curl -X POST http://localhost:3000/links \
  -H "Content-Type: application/json" \
  -d '{"url":"https://www.amazon.com.br/produto"}'
```

## Próximos Passos para Deploy

1. Execute `flutter pub get` para instalar as novas dependências
2. Para iOS, execute `pod install` no diretório `ios/`
3. Configure o App Group no Xcode:
   - Target principal: `group.com.mycompany.gimieapp`
   - Share Extension: `group.com.mycompany.gimieapp`
4. Teste a API para garantir que retorna os dados esperados
5. Teste deep links e share intents em dispositivos reais

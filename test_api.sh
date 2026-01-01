#!/bin/bash

# Script para testar a API do Gimie

echo "====================================="
echo "Teste da API Gimie - Deep Link"
echo "====================================="
echo ""

# URL da API
API_URL="https://gimieapi.onrender.com/links"

# URL de teste
TEST_URL="https://www.amazon.com.br/produto-teste"

echo "1. Testando POST para salvar link..."
echo "URL de teste: $TEST_URL"
echo ""

# Fazer requisição POST
RESPONSE=$(curl -s -w "\nHTTP_CODE:%{http_code}" -X POST "$API_URL" \
  -H "Content-Type: application/json" \
  -d "{\"url\":\"$TEST_URL\"}")

# Separar corpo e código HTTP
HTTP_BODY=$(echo "$RESPONSE" | sed -e 's/HTTP_CODE\:.*//g')
HTTP_CODE=$(echo "$RESPONSE" | tr -d '\n' | sed -e 's/.*HTTP_CODE://')

echo "Código HTTP: $HTTP_CODE"
echo ""
echo "Resposta da API:"
echo "$HTTP_BODY" | python3 -m json.tool 2>/dev/null || echo "$HTTP_BODY"
echo ""

# Verificar se a resposta contém os campos esperados
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
    echo "✅ Status Code: OK ($HTTP_CODE)"
    
    # Verificar campos na resposta
    if echo "$HTTP_BODY" | grep -q "nome"; then
        echo "✅ Campo 'nome' encontrado"
    else
        echo "❌ Campo 'nome' NÃO encontrado"
    fi
    
    if echo "$HTTP_BODY" | grep -q "preco"; then
        echo "✅ Campo 'preco' encontrado"
    else
        echo "❌ Campo 'preco' NÃO encontrado"
    fi
    
    if echo "$HTTP_BODY" | grep -q "imagem"; then
        echo "✅ Campo 'imagem' encontrado"
    else
        echo "❌ Campo 'imagem' NÃO encontrado"
    fi
    
    if echo "$HTTP_BODY" | grep -q "url"; then
        echo "✅ Campo 'url' encontrado"
    else
        echo "❌ Campo 'url' NÃO encontrado"
    fi
else
    echo "❌ Status Code: ERRO ($HTTP_CODE)"
    echo "A API não está retornando sucesso (200/201)"
fi

echo ""
echo "====================================="
echo "Teste Completo"
echo "====================================="
echo ""
echo "Para testar deep links no Android:"
echo "  adb shell am start -W -a android.intent.action.VIEW -d \"gimieapp://gimie.tech?url=$TEST_URL\""
echo ""
echo "Para testar deep links no iOS Simulator:"
echo "  xcrun simctl openurl booted \"gimieapp://gimie.tech?url=$TEST_URL\""
echo ""
echo "Para testar share intent no Android:"
echo "  adb shell am start -a android.intent.action.SEND -t text/plain --es android.intent.extra.TEXT \"$TEST_URL\" com.mycompany.gimieapp"
echo ""

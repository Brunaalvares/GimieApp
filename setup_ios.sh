#!/bin/bash

# Script para configurar o projeto iOS do Gimie App
# Execute este script na sua máquina local onde o Flutter está instalado

echo "================================================"
echo "  Setup iOS - Gimie App"
echo "================================================"
echo ""

# Verificar se Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ ERRO: Flutter não encontrado!"
    echo "Por favor, instale o Flutter primeiro:"
    echo "  https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter encontrado: $(flutter --version | head -1)"
echo ""

# Passo 1: Flutter Clean
echo "🧹 Passo 1/6: Limpando projeto Flutter..."
flutter clean
if [ $? -eq 0 ]; then
    echo "✅ Flutter clean concluído"
else
    echo "❌ Erro ao executar flutter clean"
    exit 1
fi
echo ""

# Passo 2: Flutter Pub Get
echo "📦 Passo 2/6: Baixando dependências Flutter..."
flutter pub get
if [ $? -eq 0 ]; then
    echo "✅ Dependências baixadas com sucesso"
else
    echo "❌ Erro ao baixar dependências"
    exit 1
fi
echo ""

# Passo 3: Flutter Build iOS (no codesign)
echo "🔨 Passo 3/6: Compilando projeto iOS (sem assinatura)..."
flutter build ios --no-codesign
if [ $? -eq 0 ]; then
    echo "✅ Build iOS concluído"
else
    echo "⚠️  Build iOS teve problemas, mas continuando..."
fi
echo ""

# Passo 4: Entrar no diretório iOS
echo "📁 Passo 4/6: Entrando no diretório ios..."
cd ios
if [ $? -eq 0 ]; then
    echo "✅ Diretório ios acessado"
else
    echo "❌ Erro ao acessar diretório ios"
    exit 1
fi
echo ""

# Passo 5: Pod Install
echo "🍎 Passo 5/6: Instalando pods iOS..."
if ! command -v pod &> /dev/null; then
    echo "❌ ERRO: CocoaPods não encontrado!"
    echo "Instale com: sudo gem install cocoapods"
    exit 1
fi

pod install
if [ $? -eq 0 ]; then
    echo "✅ Pods instalados com sucesso"
else
    echo "❌ Erro ao instalar pods"
    exit 1
fi
echo ""

# Passo 6: Voltar ao diretório raiz
cd ..
echo "✅ Voltando ao diretório raiz"
echo ""

# Passo 7: Abrir Xcode
echo "🚀 Passo 6/6: Abrindo Xcode..."
if [ "$(uname)" == "Darwin" ]; then
    open ios/Runner.xcworkspace
    if [ $? -eq 0 ]; then
        echo "✅ Xcode aberto com sucesso!"
    else
        echo "⚠️  Não foi possível abrir o Xcode automaticamente"
        echo "   Abra manualmente: ios/Runner.xcworkspace"
    fi
else
    echo "⚠️  Sistema operacional não é macOS"
    echo "   Abra manualmente o arquivo: ios/Runner.xcworkspace"
fi

echo ""
echo "================================================"
echo "  Setup Completo!"
echo "================================================"
echo ""
echo "⚠️  IMPORTANTE: Configure o App Group no Xcode"
echo ""
echo "1. No Xcode, selecione o target 'Runner'"
echo "2. Vá para 'Signing & Capabilities'"
echo "3. Adicione 'App Groups' se não existir"
echo "4. Marque/crie: group.com.mycompany.gimieapp"
echo ""
echo "5. Repita para o target 'Gimie ShareExtension'"
echo "6. Use o MESMO App Group: group.com.mycompany.gimieapp"
echo ""
echo "📚 Documentação completa em:"
echo "   - GUIA_DEPLOY.md"
echo "   - RELATORIO_EXECUTIVO.md"
echo ""

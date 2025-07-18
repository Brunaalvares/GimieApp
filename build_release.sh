#!/bin/bash

# 🚀 Script de Build para Google Play Store - Gimie App
# Este script automatiza o processo de build para produção

echo "🔧 Iniciando build do Gimie para Google Play Store..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para mostrar erro e sair
error_exit() {
    echo -e "${RED}❌ Erro: $1${NC}" >&2
    exit 1
}

# Função para mostrar sucesso
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Função para mostrar aviso
warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Função para mostrar info
info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Verificar se estamos na pasta correta
if [ ! -f "pubspec.yaml" ]; then
    error_exit "pubspec.yaml não encontrado. Execute este script na raiz do projeto Flutter."
fi

# Verificar se o arquivo key.properties existe
if [ ! -f "android/key.properties" ]; then
    error_exit "Arquivo android/key.properties não encontrado. Crie a keystore primeiro!"
fi

# Verificar se a keystore existe
if [ ! -f "android/upload-keystore.jks" ]; then
    error_exit "Keystore android/upload-keystore.jks não encontrada. Crie a keystore primeiro!"
fi

# Limpar projeto
info "Limpando projeto..."
flutter clean || error_exit "Falha ao limpar projeto"

# Obter dependências
info "Obtendo dependências..."
flutter pub get || error_exit "Falha ao obter dependências"

# Verificar se há problemas no código
info "Analisando código..."
flutter analyze --no-fatal-infos || warning "Há warnings no código, mas continuando..."

# Verificar testes (se existirem)
if [ -d "test" ] && [ "$(ls -A test)" ]; then
    info "Executando testes..."
    flutter test || warning "Alguns testes falharam, mas continuando..."
fi

# Remover arquivo de teste se existir
if [ -f "lib/test_sharing.dart" ]; then
    warning "Removendo arquivo de teste..."
    rm lib/test_sharing.dart
    success "Arquivo de teste removido"
fi

# Build APK de teste
info "Criando APK de teste..."
flutter build apk --release || error_exit "Falha ao criar APK"

# Testar instalação (se dispositivo conectado)
if adb devices | grep -q "device"; then
    info "Dispositivo Android detectado. Testando instalação..."
    flutter install --release || warning "Falha ao instalar no dispositivo"
else
    warning "Nenhum dispositivo Android conectado para teste"
fi

# Build App Bundle para Google Play
info "Criando App Bundle para Google Play..."
flutter build appbundle --release || error_exit "Falha ao criar App Bundle"

# Verificar se o arquivo foi gerado
BUNDLE_PATH="build/app/outputs/bundle/release/app-release.aab"
if [ ! -f "$BUNDLE_PATH" ]; then
    error_exit "App Bundle não foi gerado em $BUNDLE_PATH"
fi

# Mostrar informações do arquivo
FILE_SIZE=$(ls -lh "$BUNDLE_PATH" | awk '{print $5}')
success "App Bundle criado com sucesso!"
info "Arquivo: $BUNDLE_PATH"
info "Tamanho: $FILE_SIZE"

# Verificar assinatura
info "Verificando assinatura do App Bundle..."
if command -v jarsigner &> /dev/null; then
    jarsigner -verify "$BUNDLE_PATH" && success "App Bundle está assinado corretamente" || error_exit "App Bundle não está assinado"
else
    warning "jarsigner não encontrado. Não foi possível verificar assinatura."
fi

# Mostrar próximos passos
echo ""
echo -e "${GREEN}🎉 Build concluído com sucesso!${NC}"
echo ""
echo -e "${BLUE}📋 Próximos passos:${NC}"
echo "1. Acesse https://play.google.com/console/"
echo "2. Faça upload do arquivo: $BUNDLE_PATH"
echo "3. Preencha as informações da loja"
echo "4. Envie para revisão"
echo ""
echo -e "${YELLOW}📄 Arquivos importantes:${NC}"
echo "• App Bundle: $BUNDLE_PATH"
echo "• Keystore: android/upload-keystore.jks"
echo "• Key Properties: android/key.properties"
echo ""
echo -e "${RED}⚠️  Lembre-se:${NC}"
echo "• Faça backup da keystore e senhas"
echo "• Teste o app em dispositivos físicos"
echo "• Verifique se todas as funcionalidades estão funcionando"
echo ""

# Opcional: Abrir pasta do App Bundle
if command -v open &> /dev/null; then
    read -p "Abrir pasta do App Bundle? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        open "build/app/outputs/bundle/release/"
    fi
elif command -v xdg-open &> /dev/null; then
    read -p "Abrir pasta do App Bundle? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        xdg-open "build/app/outputs/bundle/release/"
    fi
fi

success "Script concluído!"
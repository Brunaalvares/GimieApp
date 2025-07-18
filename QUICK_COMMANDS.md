# ⚡ Comandos Rápidos - Google Play Store

## 🔐 1. Criar Keystore (Primeira vez apenas)

```bash
# Gerar keystore para assinatura
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Copiar template do key.properties
cp android/key.properties.template android/key.properties

# Editar key.properties com suas senhas
nano android/key.properties
```

## 🏗️ 2. Build Manual

```bash
# Limpar projeto
flutter clean
flutter pub get

# Build APK para teste
flutter build apk --release

# Build App Bundle para Google Play
flutter build appbundle --release
```

## 🚀 3. Build Automatizado

```bash
# Executar script completo (recomendado)
./build_release.sh
```

## 📱 4. Testar no Dispositivo

```bash
# Instalar APK no dispositivo conectado
flutter install --release

# Verificar dispositivos conectados
adb devices
```

## 📊 5. Verificar App Bundle

```bash
# Verificar se o arquivo foi gerado
ls -lh build/app/outputs/bundle/release/app-release.aab

# Verificar assinatura
jarsigner -verify build/app/outputs/bundle/release/app-release.aab
```

## 📋 6. Próximos Passos

1. **Acesse**: https://play.google.com/console/
2. **Upload**: `build/app/outputs/bundle/release/app-release.aab`
3. **Preencha**: Informações da loja (ver GOOGLE_PLAY_DEPLOYMENT.md)
4. **Envie**: Para revisão

## ⚠️ Arquivos Importantes

- **App Bundle**: `build/app/outputs/bundle/release/app-release.aab`
- **Keystore**: `android/upload-keystore.jks` (BACKUP!)
- **Config**: `android/key.properties` (PRIVADO!)

## 🆘 Troubleshooting Rápido

```bash
# Erro de keystore não encontrada
ls -la android/upload-keystore.jks
ls -la android/key.properties

# Limpar cache do Flutter
flutter clean
rm -rf .dart_tool/
flutter pub get

# Verificar configuração do Android
flutter doctor -v
```
# Usuários de Teste - Gimie App

Este documento descreve como usar os usuários de teste criados para facilitar o desenvolvimento e testes da aplicação Flutter.

## Arquivos Criados

1. **`test/test_user_helper.dart`** - Classe helper para criar diferentes tipos de usuários teste
2. **`test/user_test.dart`** - Testes unitários para validar a criação de usuários
3. **`test/auth_test.dart`** - Testes de autenticação e validação de dados

## Como Usar

### 1. Usuário Teste Básico

```dart
import 'test/test_user_helper.dart';

// Criar usuário básico com dados padrão
final userData = TestUserHelper.createBasicTestUser();
// Email: teste@exemplo.com
// Nome: Usuário Teste
// UID: test_uid_123

// Criar usuário básico personalizado
final customUser = TestUserHelper.createBasicTestUser(
  email: 'meu@teste.com',
  displayName: 'Meu Usuário',
  uid: 'custom_uid',
);
```

### 2. Usuário Teste Completo

```dart
// Usuário com todos os campos preenchidos
final completeUser = TestUserHelper.createCompleteTestUser();
// Inclui: email, nome, foto, telefone, UID, data de criação
```

### 3. Múltiplos Usuários

```dart
// Criar 10 usuários para testar listas
final users = TestUserHelper.createMultipleTestUsers(10);
// Gera: usuario1@teste.com, usuario2@teste.com, etc.
```

### 4. Credenciais para Autenticação

```dart
// Credenciais básicas
final creds = TestUserHelper.getTestUserCredentials();
final email = creds['email']; // teste@exemplo.com
final password = creds['password']; // senhaForte123!

// Múltiplas credenciais para diferentes cenários
final allCreds = TestUserHelper.getAllTestCredentials();
final adminCreds = allCreds['admin'];
final basicCreds = allCreds['basic'];
final weakPasswordCreds = allCreds['weak_password'];
```

## Tipos de Usuários Disponíveis

### Usuário Básico
- **Email:** teste@exemplo.com
- **Senha:** senhaForte123!
- **Nome:** Usuário Teste
- **Uso:** Testes gerais de funcionalidade

### Usuário Administrador
- **Email:** admin@teste.com
- **Senha:** adminSenha456!
- **Nome:** Administrador Teste
- **Uso:** Testes de permissões especiais

### Usuário Completo
- **Email:** usuario.completo@teste.com
- **Senha:** senhaCompleta789@
- **Nome:** Usuário Completo Teste
- **Telefone:** +5511999999999
- **Foto:** https://exemplo.com/foto-teste.jpg
- **Uso:** Testes com todos os campos preenchidos

### Usuário com Senha Fraca
- **Email:** senhafraca@teste.com
- **Senha:** 123
- **Nome:** Usuário Senha Fraca
- **Uso:** Testes de validação de senha

### Usuários Especiais

#### Casos Extremos
```dart
final edgeCase = TestUserHelper.createEdgeCaseTestUser();
// Email vazio, nome muito curto, telefone inválido
// Uso: Testar validações e tratamento de erros
```

#### Campos Longos
```dart
final longFields = TestUserHelper.createLongFieldsTestUser();
// Nome e email muito longos
// Uso: Testar limites de caracteres
```

#### Usuário Antigo
```dart
final oldUser = TestUserHelper.createOldTestUser();
// Criado há 1 ano
// Uso: Testar dados históricos
```

#### Caracteres Especiais
```dart
final specialChars = TestUserHelper.createSpecialCharsTestUser();
// Nome: José da Silva-Santos (Ção) & Irmão
// Uso: Testar caracteres especiais e acentos
```

## Exemplos de Uso em Testes

### Teste de Login

```dart
test('Deve fazer login com sucesso', () async {
  // Arrange
  final credentials = TestUserHelper.getTestUserCredentials();
  
  // Act
  final result = await authService.signIn(
    credentials['email']!,
    credentials['password']!,
  );
  
  // Assert
  expect(result.isSuccess, isTrue);
});
```

### Teste de Criação de Usuário

```dart
test('Deve criar usuário no Firestore', () async {
  // Arrange
  final userData = TestUserHelper.createCompleteTestUser();
  
  // Act
  final docRef = await UsersRecord.collection.add(userData);
  
  // Assert
  expect(docRef.id, isNotEmpty);
  
  // Cleanup
  await TestUserHelper.cleanupTestUser(userData['uid']);
});
```

### Teste de Validação

```dart
test('Deve validar dados do usuário', () {
  // Arrange
  final userData = TestUserHelper.createBasicTestUser();
  
  // Act
  final isValid = TestUserHelper.validateTestUserData(userData);
  
  // Assert
  expect(isValid, isTrue);
});
```

## Executando os Testes

```bash
# Executar todos os testes de usuário
flutter test test/user_test.dart

# Executar testes de autenticação
flutter test test/auth_test.dart

# Executar todos os testes
flutter test
```

## Limpeza de Dados

Para limpar dados de teste após os testes:

```dart
// Em tearDown ou ao final do teste
await TestUserHelper.cleanupTestUser(userUid);
```

## Integração com Firebase

Para usar em ambiente de desenvolvimento:

1. Configure um projeto Firebase de teste
2. Use as credenciais de teste fornecidas
3. Execute os testes em ambiente controlado
4. Limpe os dados após os testes

## Dicas de Uso

1. **Sempre use dados de teste** - Nunca use dados reais em testes
2. **Limpe após os testes** - Remova dados de teste para não poluir o banco
3. **Use diferentes tipos** - Teste com usuários básicos, completos e casos extremos
4. **Valide entradas** - Use os helpers de validação para verificar dados
5. **Performance** - O helper pode criar 1000+ usuários rapidamente para testes de carga

## Personalização

Para criar tipos específicos de usuário para seu projeto:

```dart
// Exemplo: Usuário premium
static Map<String, dynamic> createPremiumTestUser() {
  return createUsersRecordData(
    email: 'premium@teste.com',
    displayName: 'Usuário Premium',
    uid: 'premium_uid',
    createdTime: DateTime.now(),
    // Adicione campos específicos do seu app
  );
}
```

## Solução de Problemas

### Erro de Import
Se houver erro de import, verifique se o caminho está correto:
```dart
import 'package:gimie_app/backend/schema/users_record.dart';
```

### Firestore não inicializado
Para testes que não precisam do Firestore real, use mocks:
```dart
// Use dados simulados em vez de conectar ao Firestore
final mockData = TestUserHelper.createBasicTestUser();
```

### Dependências em falta
Adicione ao `pubspec.yaml` se necessário:
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.0
  fake_cloud_firestore: ^2.4.0
```

---

**Nota:** Estes usuários de teste foram criados especificamente para facilitar o desenvolvimento e teste da aplicação Gimie. Sempre use dados de teste em ambientes de desenvolvimento e nunca em produção.
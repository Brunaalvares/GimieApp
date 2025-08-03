import 'package:flutter_test/flutter_test.dart';
import 'package:gimie_app/backend/schema/users_record.dart';
import 'test_user_helper.dart';

void main() {
  group('Testes de Usuário', () {
    
    test('Deve criar um usuário teste básico', () {
      // Arrange & Act
      final userData = TestUserHelper.createBasicTestUser();
      
      // Assert
      expect(userData['email'], equals('teste@exemplo.com'));
      expect(userData['display_name'], equals('Usuário Teste'));
      expect(userData['uid'], equals('test_uid_123'));
      expect(userData['created_time'], isNotNull);
      expect(TestUserHelper.validateTestUserData(userData), isTrue);
    });

    test('Deve criar um usuário teste completo', () {
      // Arrange & Act
      final userData = TestUserHelper.createCompleteTestUser();
      
      // Assert
      expect(userData['email'], equals('usuario.completo@teste.com'));
      expect(userData['display_name'], equals('Usuário Completo Teste'));
      expect(userData['photo_url'], equals('https://exemplo.com/foto-teste.jpg'));
      expect(userData['phone_number'], equals('+5511999999999'));
      expect(userData['uid'], equals('complete_test_uid_456'));
      expect(TestUserHelper.validateTestUserData(userData), isTrue);
    });

    test('Deve criar múltiplos usuários teste', () {
      // Arrange
      const int numberOfUsers = 5;
      
      // Act
      final users = TestUserHelper.createMultipleTestUsers(numberOfUsers);
      
      // Assert
      expect(users.length, equals(numberOfUsers));
      
      for (int i = 0; i < numberOfUsers; i++) {
        final user = users[i];
        expect(user['email'], equals('usuario${i + 1}@teste.com'));
        expect(user['display_name'], equals('Usuário Teste ${i + 1}'));
        expect(user['uid'], equals('test_uid_${i + 1}'));
        expect(TestUserHelper.validateTestUserData(user), isTrue);
      }
    });

    test('Deve criar usuário teste personalizado', () {
      // Arrange
      const customEmail = 'personalizado@teste.com';
      const customName = 'Usuário Personalizado';
      const customUid = 'custom_uid_789';
      
      // Act
      final userData = TestUserHelper.createBasicTestUser(
        email: customEmail,
        displayName: customName,
        uid: customUid,
      );
      
      // Assert
      expect(userData['email'], equals(customEmail));
      expect(userData['display_name'], equals(customName));
      expect(userData['uid'], equals(customUid));
    });

    test('Deve criar usuário teste para casos extremos', () {
      // Arrange & Act
      final userData = TestUserHelper.createEdgeCaseTestUser();
      
      // Assert
      expect(userData['email'], equals(''));
      expect(userData['display_name'], equals('A'));
      expect(userData['phone_number'], equals('123'));
      // Note: Este teste verifica dados inválidos para testar validação
    });

    test('Deve criar usuário teste com campos longos', () {
      // Arrange & Act
      final userData = TestUserHelper.createLongFieldsTestUser();
      
      // Assert
      expect(userData['email'], isNotNull);
      expect(userData['display_name'], isNotNull);
      expect(userData['display_name'].length, greaterThan(100));
    });

    test('Deve criar usuário administrador teste', () {
      // Arrange & Act
      final userData = TestUserHelper.createAdminTestUser();
      
      // Assert
      expect(userData['email'], equals('admin@teste.com'));
      expect(userData['display_name'], equals('Administrador Teste'));
      expect(userData['uid'], equals('admin_test_uid_999'));
    });

    test('Deve criar usuário teste antigo', () {
      // Arrange & Act
      final userData = TestUserHelper.createOldTestUser();
      final createdTime = userData['created_time'] as DateTime;
      final oneYearAgo = DateTime.now().subtract(Duration(days: 365));
      
      // Assert
      expect(userData['email'], equals('usuario.antigo@teste.com'));
      expect(createdTime.isBefore(DateTime.now()), isTrue);
      expect(createdTime.difference(oneYearAgo).inDays.abs(), lessThan(2));
    });

    test('Deve criar usuário teste com caracteres especiais', () {
      // Arrange & Act
      final userData = TestUserHelper.createSpecialCharsTestUser();
      
      // Assert
      expect(userData['display_name'], equals('José da Silva-Santos (Ção) & Irmão'));
      expect(userData['email'], equals('especial@teste.com'));
    });

    test('Deve fornecer credenciais de teste básicas', () {
      // Arrange & Act
      final credentials = TestUserHelper.getTestUserCredentials();
      
      // Assert
      expect(credentials['email'], equals('teste@exemplo.com'));
      expect(credentials['password'], equals('senhaForte123!'));
      expect(credentials['displayName'], equals('Usuário Teste'));
    });

    test('Deve fornecer múltiplas credenciais de teste', () {
      // Arrange & Act
      final allCredentials = TestUserHelper.getAllTestCredentials();
      
      // Assert
      expect(allCredentials.keys.length, equals(4));
      expect(allCredentials.containsKey('basic'), isTrue);
      expect(allCredentials.containsKey('admin'), isTrue);
      expect(allCredentials.containsKey('complete'), isTrue);
      expect(allCredentials.containsKey('weak_password'), isTrue);
      
      // Verifica credenciais básicas
      final basicCreds = allCredentials['basic']!;
      expect(basicCreds['email'], equals('teste@exemplo.com'));
      expect(basicCreds['password'], isNotNull);
      expect(basicCreds['displayName'], isNotNull);
    });

    test('Deve validar dados de usuário teste', () {
      // Arrange
      final validData = TestUserHelper.createBasicTestUser();
      final invalidData = <String, dynamic>{
        'email': 'teste@exemplo.com',
        // Missing display_name and uid
      };
      
      // Act & Assert
      expect(TestUserHelper.validateTestUserData(validData), isTrue);
      expect(TestUserHelper.validateTestUserData(invalidData), isFalse);
    });

    test('Deve simular limpeza de usuário teste', () async {
      // Arrange
      const testUid = 'test_uid_for_cleanup';
      
      // Act & Assert - Não deve lançar exceção
      await expectLater(
        TestUserHelper.cleanupTestUser(testUid),
        completes,
      );
    });
  });

  group('Testes de Integração com UsersRecord', () {
    
    test('Deve criar UsersRecord a partir de dados de teste', () {
      // Arrange
      final testData = TestUserHelper.createCompleteTestUser();
      
      // Act
      final userRecord = TestUserExtensions.fromTestData(testData);
      
      // Assert
      expect(userRecord.email, equals(testData['email']));
      expect(userRecord.displayName, equals(testData['display_name']));
      expect(userRecord.uid, equals(testData['uid']));
      expect(userRecord.photoUrl, equals(testData['photo_url']));
      expect(userRecord.phoneNumber, equals(testData['phone_number']));
    });

    test('Deve verificar campos obrigatórios do UsersRecord', () {
      // Arrange
      final testData = TestUserHelper.createBasicTestUser();
      final userRecord = TestUserExtensions.fromTestData(testData);
      
      // Act & Assert
      expect(userRecord.hasEmail(), isTrue);
      expect(userRecord.hasDisplayName(), isTrue);
      expect(userRecord.hasUid(), isTrue);
      expect(userRecord.hasCreatedTime(), isTrue);
    });
  });

  group('Testes de Performance', () {
    
    test('Deve criar muitos usuários rapidamente', () {
      // Arrange
      const int largeNumber = 1000;
      
      // Act
      final stopwatch = Stopwatch()..start();
      final users = TestUserHelper.createMultipleTestUsers(largeNumber);
      stopwatch.stop();
      
      // Assert
      expect(users.length, equals(largeNumber));
      expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Menos de 5 segundos
      print('Criação de $largeNumber usuários levou ${stopwatch.elapsedMilliseconds}ms');
    });
  });
}
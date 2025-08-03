import 'package:flutter_test/flutter_test.dart';
import 'package:gimie_app/backend/schema/users_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper class for creating test users in different scenarios
class TestUserHelper {
  
  /// Creates a basic test user with minimal required fields
  static Map<String, dynamic> createBasicTestUser({
    String? email,
    String? displayName,
    String? uid,
  }) {
    return createUsersRecordData(
      email: email ?? 'teste@exemplo.com',
      displayName: displayName ?? 'Usuário Teste',
      uid: uid ?? 'test_uid_123',
      createdTime: DateTime.now(),
    );
  }

  /// Creates a complete test user with all fields populated
  static Map<String, dynamic> createCompleteTestUser({
    String? email,
    String? displayName,
    String? photoUrl,
    String? uid,
    String? phoneNumber,
    DateTime? createdTime,
  }) {
    return createUsersRecordData(
      email: email ?? 'usuario.completo@teste.com',
      displayName: displayName ?? 'Usuário Completo Teste',
      photoUrl: photoUrl ?? 'https://exemplo.com/foto-teste.jpg',
      uid: uid ?? 'complete_test_uid_456',
      createdTime: createdTime ?? DateTime.now(),
      phoneNumber: phoneNumber ?? '+5511999999999',
    );
  }

  /// Creates multiple test users for testing lists and pagination
  static List<Map<String, dynamic>> createMultipleTestUsers(int count) {
    List<Map<String, dynamic>> users = [];
    
    for (int i = 1; i <= count; i++) {
      users.add(createUsersRecordData(
        email: 'usuario$i@teste.com',
        displayName: 'Usuário Teste $i',
        uid: 'test_uid_$i',
        createdTime: DateTime.now().subtract(Duration(days: i)),
        phoneNumber: '+551199999${i.toString().padLeft(4, '0')}',
      ));
    }
    
    return users;
  }

  /// Creates a test user with invalid/edge case data for testing validation
  static Map<String, dynamic> createEdgeCaseTestUser() {
    return createUsersRecordData(
      email: '', // Empty email
      displayName: 'A', // Very short name
      uid: 'edge_case_uid',
      createdTime: DateTime.now(),
      phoneNumber: '123', // Invalid phone format
    );
  }

  /// Creates a test user with very long fields for testing limits
  static Map<String, dynamic> createLongFieldsTestUser() {
    String longName = 'Nome Muito Longo Para Testar Limites ' * 10;
    String longEmail = 'email.muito.longo.para.testar.limites@dominio.muito.longo.exemplo.com';
    
    return createUsersRecordData(
      email: longEmail,
      displayName: longName,
      uid: 'long_fields_test_uid',
      createdTime: DateTime.now(),
      phoneNumber: '+5511999999999',
    );
  }

  /// Creates a test user for admin/special permissions testing
  static Map<String, dynamic> createAdminTestUser() {
    return createUsersRecordData(
      email: 'admin@teste.com',
      displayName: 'Administrador Teste',
      uid: 'admin_test_uid_999',
      createdTime: DateTime.now(),
      phoneNumber: '+5511888888888',
    );
  }

  /// Creates a test user that was created in the past (for testing historical data)
  static Map<String, dynamic> createOldTestUser() {
    return createUsersRecordData(
      email: 'usuario.antigo@teste.com',
      displayName: 'Usuário Antigo',
      uid: 'old_test_uid_000',
      createdTime: DateTime.now().subtract(Duration(days: 365)), // 1 year ago
      phoneNumber: '+5511777777777',
    );
  }

  /// Creates a test user with special characters in name
  static Map<String, dynamic> createSpecialCharsTestUser() {
    return createUsersRecordData(
      email: 'especial@teste.com',
      displayName: 'José da Silva-Santos (Ção) & Irmão',
      uid: 'special_chars_uid',
      createdTime: DateTime.now(),
      phoneNumber: '+5511666666666',
    );
  }

  /// Gets commonly used test user credentials for authentication tests
  static Map<String, String> getTestUserCredentials() {
    return {
      'email': 'teste@exemplo.com',
      'password': 'senhaForte123!',
      'displayName': 'Usuário Teste',
    };
  }

  /// Gets credentials for multiple test scenarios
  static Map<String, Map<String, String>> getAllTestCredentials() {
    return {
      'basic': {
        'email': 'teste@exemplo.com',
        'password': 'senha123',
        'displayName': 'Usuário Básico',
      },
      'admin': {
        'email': 'admin@teste.com',
        'password': 'adminSenha456!',
        'displayName': 'Administrador',
      },
      'complete': {
        'email': 'usuario.completo@teste.com',
        'password': 'senhaCompleta789@',
        'displayName': 'Usuário Completo',
      },
      'weak_password': {
        'email': 'senhafraca@teste.com',
        'password': '123',
        'displayName': 'Usuário Senha Fraca',
      },
    };
  }

  /// Validates if test user data is properly formatted
  static bool validateTestUserData(Map<String, dynamic> userData) {
    return userData.containsKey('email') &&
           userData.containsKey('display_name') &&
           userData.containsKey('uid') &&
           userData['email'] != null &&
           userData['display_name'] != null &&
           userData['uid'] != null;
  }

  /// Cleans up test data (utility for tearDown in tests)
  static Future<void> cleanupTestUser(String uid) async {
    // Note: In real implementation, this would delete the user from Firebase
    // For now, it's just a placeholder for the cleanup logic
    print('Limpando dados do usuário teste: $uid');
  }
}

/// Extension methods for easier test user creation in tests
extension TestUserExtensions on UsersRecord {
  /// Creates a test UsersRecord from test data
  static UsersRecord fromTestData(Map<String, dynamic> testData) {
    // Create a mock DocumentReference for testing
    final mockRef = FirebaseFirestore.instance.collection('users').doc('test');
    return UsersRecord.getDocumentFromData(testData, mockRef);
  }
}
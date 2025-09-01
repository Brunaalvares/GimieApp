import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

// https://firebase.flutter.dev/docs/auth/social/#github
Future<UserCredential?> githubSignInFunc() async {
  if (kIsWeb) {
    final githubProvider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithPopup(githubProvider);
  }
  // Mobile/Desktop
  final provider = GithubAuthProvider();
  return await FirebaseAuth.instance.signInWithProvider(provider);
}

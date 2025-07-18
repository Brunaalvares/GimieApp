import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDyej6-gwO1fiVAgqJp_u4q4fGv_7LcZ_g",
            authDomain: "gimie-84a75.firebaseapp.com",
            projectId: "gimie-84a75",
            storageBucket: "gimie-84a75.firebasestorage.app",
            messagingSenderId: "153238418713",
            appId: "1:153238418713:web:d22d3e6a2e9ea9d9bdc188",
            measurementId: "G-YDQL2L8081"));
  } else {
    await Firebase.initializeApp();
  }
}

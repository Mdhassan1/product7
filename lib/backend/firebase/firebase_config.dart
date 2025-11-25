import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDHXw9Lui7UZuf6Z-Q_mQvGoLd3yQ3EnwI",
            authDomain: "product7-afc43.firebaseapp.com",
            projectId: "product7-afc43",
            storageBucket: "product7-afc43.firebasestorage.app",
            messagingSenderId: "910105893179",
            appId: "1:910105893179:android:490c6c0c7d926f5b96bf1e", // ✅ FIXED
            measurementId: "G-KQJK86VERG"));
  } else {
    await Firebase.initializeApp();
  }
}

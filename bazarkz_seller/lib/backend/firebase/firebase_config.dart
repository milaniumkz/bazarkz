import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDLyVokT3-mzTfpCUCJU8cz9kE8q0j8aJ8",
            authDomain: "ba-za-r-k-z-np0vyz.firebaseapp.com",
            projectId: "ba-za-r-k-z-np0vyz",
            storageBucket: "ba-za-r-k-z-np0vyz.firebasestorage.app",
            messagingSenderId: "541902317139",
            appId: "1:541902317139:web:703c69598c13ef9b2288a6"));
  } else {
    await Firebase.initializeApp();
  }
}

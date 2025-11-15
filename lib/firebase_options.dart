import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

/// Default Firebase configuration for the app
class DefaultFirebaseOptions {
  /// Returns the Firebase configuration for the current platform (Android)
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyCdpDlG--tNBfI6BcyU6u5ohhje8dV_3vg", // API key
      appId: "1:361187784178:android:e221698963402f6279e76b", // Application ID
      messagingSenderId: "361187784178", // Messaging sender ID
      projectId: "chatapp-6b57b", // Firebase project ID
      storageBucket: "chatapp-6b57b.firebasestorage.app", // Cloud storage bucket
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' 
show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: "AIzaSyCdpDlG--tNBfI6BcyU6u5ohhje8dV_3vg",
      appId: "1:361187784178:android:e221698963402f6279e76b",
      messagingSenderId: "361187784178",
      projectId: "chatapp-6b57b",
      storageBucket: "chatapp-6b57b.firebasestorage.app",
    );
  }
}

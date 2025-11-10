import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

/// Cấu hình Firebase mặc định cho app
class DefaultFirebaseOptions {
  /// Trả về cấu hình Firebase cho nền tảng hiện tại (Android)
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyCdpDlG--tNBfI6BcyU6u5ohhje8dV_3vg", // Khóa API
      appId: "1:361187784178:android:e221698963402f6279e76b", // ID ứng dụng
      messagingSenderId: "361187784178", // ID gửi thông báo
      projectId: "chatapp-6b57b", // Mã dự án
      storageBucket: "chatapp-6b57b.firebasestorage.app", // Kho lưu trữ
    );
  }
}

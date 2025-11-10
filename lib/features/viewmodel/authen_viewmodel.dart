import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthenViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false; // Trạng thái đang xử lý
  String? errorMessage;   // Lưu lỗi khi đăng ký

  /// Đăng ký tài khoản mới (Firebase Auth + Firestore)
  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // Tạo user trên Firebase Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Tạo model người dùng để lưu vào Firestore
      final user = UserModel(
        uid: cred.user!.uid,
        fullName: fullName,
        phone: phone,
        email: email,
        createdAt: DateTime.now(),
      );

      // Lưu thông tin người dùng vào Firestore
      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      isLoading = false;
      notifyListeners();
      return true; // Đăng ký thành công
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message; // Ghi lại lỗi từ Firebase
      isLoading = false;
      notifyListeners();
      return false; // Đăng ký thất bại
    }
  }
}

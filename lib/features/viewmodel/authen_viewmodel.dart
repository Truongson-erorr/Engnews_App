import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthenViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;       // Trạng thái đang xử lý
  String? errorMessage;         // Lưu lỗi khi đăng ký
  UserModel? currentUser;       // Lưu thông tin người dùng hiện tại

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
        image: '', 
        createdAt: DateTime.now(),
      );

      // Lưu thông tin người dùng vào Firestore
      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      // Cập nhật thông tin user hiện tại
      currentUser = user;

      isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Lấy thông tin người dùng hiện tại từ Firebase
  Future<void> fetchCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      isLoading = true;
      notifyListeners();

      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          currentUser = UserModel.fromMap(doc.data()!); // lấy cả image từ Firestore
        }
      } catch (e) {
        errorMessage = 'Không thể lấy thông tin người dùng: $e';
      }

      isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}

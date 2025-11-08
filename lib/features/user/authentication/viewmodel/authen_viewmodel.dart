import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class AuthenViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // Tạo user trên Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Tạo model user
      final user = UserModel(
        uid: cred.user!.uid,
        fullName: fullName,
        phone: phone,
        email: email,
        createdAt: DateTime.now(),
      );

      // Lưu Firestore
      await _firestore.collection('users').doc(user.uid).set(user.toMap());

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
}

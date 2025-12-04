import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;       // Loading state
  String? errorMessage;         // Store error message
  UserModel? currentUser;       // Current user info

  /// Register a new account (Firebase Auth + Firestore)
  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // Create user in Firebase Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create UserModel to store in Firestore
      final user = UserModel(
        uid: cred.user!.uid,
        fullName: fullName,
        phone: phone,
        email: email,
        image: '', 
        role: 'user',   
        createdAt: DateTime.now(),
      );

      // Save user info to Firestore
      await _firestore.collection('users').doc(user.uid).set(user.toMap());

      // Update current user
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

  /// Fetch current user info from Firebase
  Future<void> fetchCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      isLoading = true;
      notifyListeners();

      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        if (doc.exists) {
          currentUser = UserModel.fromMap(doc.data()!); 
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

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // Firebase Auth login
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Fetch user info from Firestore
      await fetchCurrentUser();

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

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();

      final googleSignIn = GoogleSignIn();

      // Force sign out to always select a new account
      await googleSignIn.signOut();

      // Start sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return false; 
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Check Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        final newUser = UserModel(
          uid: user.uid,
          fullName: user.displayName ?? 'Người dùng Google',
          phone: user.phoneNumber ?? '',
          email: user.email ?? '',
          image: user.photoURL ?? '',
          role: 'user',   
          createdAt: DateTime.now(),
        );
        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
        currentUser = newUser;
      } else {
        currentUser = UserModel.fromMap(doc.data()!);
      }

      isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      print('🔥 Lỗi đăng nhập Google: $e'); 
      errorMessage = 'Đăng nhập Google thất bại: $e'; 
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update user profile info
  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      // Update Firestore
      await _firestore.collection('users').doc(uid).update({
        'fullName': fullName,
        'phone': phone,
      });

      // Update local copy
      if (currentUser != null) {
        currentUser = UserModel(
          uid: currentUser!.uid,
          fullName: fullName,
          phone: phone,
          role: 'user',   
          email: currentUser!.email,
          image: currentUser!.image,
          createdAt: currentUser!.createdAt,
        );
      }

      notifyListeners();
    } catch (e) {
      errorMessage = 'Lỗi khi cập nhật thông tin: $e'; 
      notifyListeners();
    }
  }
}

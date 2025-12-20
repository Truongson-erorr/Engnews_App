import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;
  String? errorMessage;
  UserModel? currentUser;

  /// Register a new user with email and password
  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        uid: cred.user!.uid,
        fullName: fullName,
        phone: phone,
        email: email,
        image: '',
        role: 'user',
        isActive: true,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      currentUser = user;

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login using email and password, and check if the account is blocked
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        await _auth.signOut();
        errorMessage = "Tài khoản không tồn tại";
        isLoading = false;
        notifyListeners();
        return false;
      }

      final user = UserModel.fromMap(doc.data()!);

      if (!user.isActive) {
        await _auth.signOut();
        errorMessage = "Tài khoản của bạn đã bị chặn bởi quản trị viên";
        isLoading = false;
        notifyListeners();
        return false;
      }

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

  /// Login with Google account and verify user status
  Future<bool> signInWithGoogle() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;

      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (!doc.exists) {
        final newUser = UserModel(
          uid: firebaseUser.uid,
          fullName: firebaseUser.displayName ?? 'Người dùng Google',
          phone: firebaseUser.phoneNumber ?? '',
          email: firebaseUser.email ?? '',
          image: firebaseUser.photoURL ?? '',
          role: 'user',
          isActive: true,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());

        currentUser = newUser;
      } else {
        final user = UserModel.fromMap(doc.data()!);

        if (!user.isActive) {
          await _auth.signOut();
          errorMessage = "Tài khoản của bạn đã bị chặn bởi quản trị viên";
          isLoading = false;
          notifyListeners();
          return false;
        }

        currentUser = user;
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = "Đăng nhập Google thất bại";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Fetch current logged-in user from Firestore
  Future<void> fetchCurrentUser() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      currentUser = UserModel.fromMap(doc.data()!);
      notifyListeners();
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }

  /// Update profile information of the current user
  Future<void> updateUserProfile({
    required String fullName,
    required String phone,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _firestore.collection('users').doc(uid).update({
      'fullName': fullName,
      'phone': phone,
    });

    if (currentUser != null) {
      currentUser = UserModel(
        uid: currentUser!.uid,
        fullName: fullName,
        phone: phone,
        email: currentUser!.email,
        image: currentUser!.image,
        role: currentUser!.role,
        isActive: currentUser!.isActive,
        createdAt: currentUser!.createdAt,
      );
    }

    notifyListeners();
  }

  /// Update user information by admin
  Future<void> updateUserByAdmin({
    required String uid,
    required String fullName,
    required String email,
    required String role,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'fullName': fullName,
      'email': email,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

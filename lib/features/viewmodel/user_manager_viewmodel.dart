import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserManagerViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all users from Firestore
  Future<List<UserModel>> fetchAllUsers() async {
    final snapshot = await _firestore.collection("users").get();

    return snapshot.docs
        .map((d) => UserModel.fromMap(d.data()))
        .toList();
  }

  // Delete user by UID
  Future<void> deleteUser(String uid) async {
    await _firestore.collection("users").doc(uid).delete();
  }
}

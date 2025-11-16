import 'package:cloud_firestore/cloud_firestore.dart';

/// Model represents the user (User)
class UserModel {
  final String uid;
  final String fullName;
  final String phone;
  final String email;
  final String image;
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.image,
    this.createdAt,
  });

  /// Switch UserModel → Map to save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  /// Create UserModel from Map (returned by Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      image: map['image'] ?? '',
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}

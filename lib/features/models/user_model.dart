import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String phone;
  final String email;
  final String image;
  final String role;     
  final DateTime? createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.image,
    required this.role,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'image': image,
      'role': role,                                  
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : null,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      image: map['image'] ?? '',
      role: map['role'] ?? 'user',                   
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}

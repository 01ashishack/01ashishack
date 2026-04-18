import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({required this.uid, required this.email, required this.role, required this.name, required this.mobile, required this.photoUrl, required this.createdAt});

  final String uid;
  final String email;
  final String role;
  final String name;
  final String mobile;
  final String photoUrl;
  final Timestamp? createdAt;

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      uid: data['uid'] ?? doc.id,
      email: data['email'] ?? '',
      role: data['role'] ?? 'host',
      name: data['name'] ?? '',
      mobile: data['mobile'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {'uid': uid, 'email': email, 'role': role, 'name': name, 'mobile': mobile, 'photoUrl': photoUrl, 'createdAt': createdAt};
}

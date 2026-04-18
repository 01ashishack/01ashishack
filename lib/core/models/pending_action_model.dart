import 'package:cloud_firestore/cloud_firestore.dart';

class PendingActionModel {
  PendingActionModel({required this.actionId, required this.libraryId, required this.type, required this.memberId, required this.memberName, required this.detail, required this.status, required this.createdAt});
  final String actionId, libraryId, type, memberId, memberName, detail, status;
  final Timestamp? createdAt;

  factory PendingActionModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return PendingActionModel(actionId: doc.id, libraryId: d['libraryId'] ?? '', type: d['type'] ?? '', memberId: d['memberId'] ?? '', memberName: d['memberName'] ?? '', detail: d['detail'] ?? '', status: d['status'] ?? 'pending', createdAt: d['createdAt'] as Timestamp?);
  }

  Map<String, dynamic> toMap() => {'libraryId': libraryId, 'type': type, 'memberId': memberId, 'memberName': memberName, 'detail': detail, 'status': status, 'createdAt': createdAt};
}

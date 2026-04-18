import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  AttendanceModel({required this.libraryId, required this.memberId, required this.date, required this.status, required this.markedAt, required this.markedBy});
  final String libraryId, memberId, date, status, markedBy;
  final Timestamp? markedAt;
  factory AttendanceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return AttendanceModel(libraryId: d['libraryId'] ?? '', memberId: d['memberId'] ?? '', date: d['date'] ?? '', status: d['status'] ?? 'absent', markedAt: d['markedAt'] as Timestamp?, markedBy: d['markedBy'] ?? 'host');
  }
  Map<String, dynamic> toMap() => {'libraryId': libraryId, 'memberId': memberId, 'date': date, 'status': status, 'markedAt': markedAt, 'markedBy': markedBy};
}

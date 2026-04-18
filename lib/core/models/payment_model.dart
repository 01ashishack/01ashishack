import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  PaymentModel({required this.paymentId, required this.libraryId, required this.memberId, required this.memberName, required this.amount, required this.method, required this.status, required this.month, required this.confirmedAt, required this.createdAt});
  final String paymentId, libraryId, memberId, memberName, method, status, month;
  final num amount;
  final Timestamp? confirmedAt, createdAt;
  factory PaymentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return PaymentModel(paymentId: doc.id, libraryId: d['libraryId'] ?? '', memberId: d['memberId'] ?? '', memberName: d['memberName'] ?? '', amount: d['amount'] ?? 0, method: d['method'] ?? 'cash', status: d['status'] ?? 'pending', month: d['month'] ?? '', confirmedAt: d['confirmedAt'] as Timestamp?, createdAt: d['createdAt'] as Timestamp?);
  }
  Map<String, dynamic> toMap() => {'libraryId': libraryId, 'memberId': memberId, 'memberName': memberName, 'amount': amount, 'method': method, 'status': status, 'month': month, 'confirmedAt': confirmedAt, 'createdAt': createdAt};
}

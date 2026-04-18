import 'package:cloud_firestore/cloud_firestore.dart';

class MemberModel {
  MemberModel({required this.memberId, required this.libraryId, required this.hostUid, required this.name, required this.mobile, required this.email, required this.dob, required this.gender, required this.address, required this.preparingFor, required this.photoUrl, required this.seatId, required this.floorId, required this.sectionId, required this.seatNumber, required this.shift, required this.planDuration, required this.planAmount, required this.startDate, required this.endDate, required this.status, required this.paymentStatus, required this.addedBy, required this.createdAt});
  final String memberId, libraryId, hostUid, name, mobile, email, gender, address, preparingFor, photoUrl, seatId, floorId, sectionId, seatNumber, shift, status, paymentStatus, addedBy;
  final Timestamp? dob, startDate, endDate, createdAt;
  final int planDuration;
  final num planAmount;
  int get daysRemaining => (endDate?.toDate() ?? DateTime.now()).difference(DateTime.now()).inDays;

  factory MemberModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return MemberModel(
      memberId: d['memberId'] ?? doc.id,
      libraryId: d['libraryId'] ?? '',
      hostUid: d['hostUid'] ?? '',
      name: d['name'] ?? '',
      mobile: d['mobile'] ?? '',
      email: d['email'] ?? '',
      dob: d['dob'] as Timestamp?,
      gender: d['gender'] ?? '',
      address: d['address'] ?? '',
      preparingFor: d['preparingFor'] ?? '',
      photoUrl: d['photoUrl'] ?? '',
      seatId: d['seatId'] ?? '',
      floorId: d['floorId'] ?? '',
      sectionId: d['sectionId'] ?? '',
      seatNumber: d['seatNumber'] ?? '',
      shift: d['shift'] ?? 'morning',
      planDuration: d['planDuration'] ?? 1,
      planAmount: d['planAmount'] ?? 0,
      startDate: d['startDate'] as Timestamp?,
      endDate: d['endDate'] as Timestamp?,
      status: d['status'] ?? 'active',
      paymentStatus: d['paymentStatus'] ?? 'pending',
      addedBy: d['addedBy'] ?? 'host',
      createdAt: d['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {'memberId': memberId, 'libraryId': libraryId, 'hostUid': hostUid, 'name': name, 'mobile': mobile, 'email': email, 'dob': dob, 'gender': gender, 'address': address, 'preparingFor': preparingFor, 'photoUrl': photoUrl, 'seatId': seatId, 'floorId': floorId, 'sectionId': sectionId, 'seatNumber': seatNumber, 'shift': shift, 'planDuration': planDuration, 'planAmount': planAmount, 'startDate': startDate, 'endDate': endDate, 'status': status, 'paymentStatus': paymentStatus, 'addedBy': addedBy, 'createdAt': createdAt};
}

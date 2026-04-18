import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryModel {
  LibraryModel({required this.libraryId, required this.hostUid, required this.name, required this.city, required this.address, required this.pincode, required this.photos, required this.amenities, required this.shifts, required this.upiId, required this.upiName, required this.isLive, required this.createdAt});

  final String libraryId;
  final String hostUid;
  final String name;
  final String city;
  final String address;
  final String pincode;
  final List<String> photos;
  final List<String> amenities;
  final List<String> shifts;
  final String upiId;
  final String upiName;
  final bool isLive;
  final Timestamp? createdAt;

  factory LibraryModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return LibraryModel(
      libraryId: doc.id,
      hostUid: d['hostUid'] ?? '',
      name: d['name'] ?? '',
      city: d['city'] ?? '',
      address: d['address'] ?? '',
      pincode: d['pincode'] ?? '',
      photos: List<String>.from(d['photos'] ?? []),
      amenities: List<String>.from(d['amenities'] ?? []),
      shifts: List<String>.from(d['shifts'] ?? []),
      upiId: d['upiId'] ?? '',
      upiName: d['upiName'] ?? '',
      isLive: d['isLive'] ?? false,
      createdAt: d['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() => {'hostUid': hostUid, 'name': name, 'city': city, 'address': address, 'pincode': pincode, 'photos': photos, 'amenities': amenities, 'shifts': shifts, 'upiId': upiId, 'upiName': upiName, 'isLive': isLive, 'createdAt': createdAt};
}

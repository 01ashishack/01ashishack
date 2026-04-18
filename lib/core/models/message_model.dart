import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  MessageModel({required this.conversationId, required this.libraryId, required this.hostUid, required this.memberId, required this.memberName, required this.memberPhotoUrl, required this.lastMessage, required this.lastMessageAt, required this.unreadByHost});
  final String conversationId, libraryId, hostUid, memberId, memberName, memberPhotoUrl, lastMessage;
  final int unreadByHost;
  final Timestamp? lastMessageAt;

  factory MessageModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return MessageModel(
      conversationId: doc.id,
      libraryId: d['libraryId'] ?? '',
      hostUid: d['hostUid'] ?? '',
      memberId: d['memberId'] ?? '',
      memberName: d['memberName'] ?? '',
      memberPhotoUrl: d['memberPhotoUrl'] ?? '',
      lastMessage: d['lastMessage'] ?? '',
      lastMessageAt: d['lastMessageAt'] as Timestamp?,
      unreadByHost: d['unreadByHost'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {'libraryId': libraryId, 'hostUid': hostUid, 'memberId': memberId, 'memberName': memberName, 'memberPhotoUrl': memberPhotoUrl, 'lastMessage': lastMessage, 'lastMessageAt': lastMessageAt, 'unreadByHost': unreadByHost};
}

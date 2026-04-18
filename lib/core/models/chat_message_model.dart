import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  ChatMessageModel({required this.chatId, required this.senderId, required this.senderRole, required this.text, required this.sentAt, required this.isRead});
  final String chatId, senderId, senderRole, text;
  final bool isRead;
  final Timestamp? sentAt;

  factory ChatMessageModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return ChatMessageModel(chatId: doc.id, senderId: d['senderId'] ?? '', senderRole: d['senderRole'] ?? 'member', text: d['text'] ?? '', sentAt: d['sentAt'] as Timestamp?, isRead: d['isRead'] ?? false);
  }

  Map<String, dynamic> toMap() => {'senderId': senderId, 'senderRole': senderRole, 'text': text, 'sentAt': sentAt, 'isRead': isRead};
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.conversationId});
  final String conversationId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = TextEditingController();
  final scroll = ScrollController();

  Future<void> _send() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final chatRef = FirebaseFirestore.instance.collection('messages').doc(widget.conversationId).collection('chats').doc();
    final convo = FirebaseFirestore.instance.collection('messages').doc(widget.conversationId);
    await chatRef.set({'senderId': uid, 'senderRole': 'host', 'text': text, 'sentAt': FieldValue.serverTimestamp(), 'isRead': false});
    await convo.update({'lastMessage': text, 'lastMessageAt': FieldValue.serverTimestamp()});
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat'), flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFF7931E)])))),
      body: Column(children: [Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('messages').doc(widget.conversationId).collection('chats').orderBy('sentAt').snapshots(), builder: (_, s) { final docs = s.data?.docs ?? []; WidgetsBinding.instance.addPostFrameCallback((_) { if (scroll.hasClients) scroll.jumpTo(scroll.position.maxScrollExtent); }); return ListView.builder(controller: scroll, itemCount: docs.length, itemBuilder: (_, i) { final d = docs[i].data(); final mine = d['senderRole'] == 'host'; return Align(alignment: mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.all(8), padding: const EdgeInsets.all(10), decoration: BoxDecoration(gradient: mine ? const LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFF7931E)]) : null, color: mine ? null : Colors.white, borderRadius: BorderRadius.circular(14)), child: Text(d['text'] ?? '', style: TextStyle(color: mine ? Colors.white : Colors.black)))); }); })), Padding(padding: const EdgeInsets.all(8), child: Row(children: [Expanded(child: TextField(controller: controller)), IconButton(onPressed: _send, icon: const Icon(Icons.send, color: Color(0xFFFF6B35))) ]))]),
    );
  }
}

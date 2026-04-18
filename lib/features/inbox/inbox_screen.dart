import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_header.dart';

class InboxScreen extends ConsumerStatefulWidget { const InboxScreen({super.key}); @override ConsumerState<InboxScreen> createState() => _InboxScreenState(); }
class _InboxScreenState extends ConsumerState<InboxScreen> {
  int mode = 0;
  @override
  Widget build(BuildContext context) {
    final inbox = ref.watch(inboxProvider).value ?? [];
    final pending = ref.watch(pendingActionsProvider).value ?? [];
    return Scaffold(appBar: GradientHeader(title: 'Inbox', right: TextButton(onPressed: () async { for (final c in inbox) { await FirebaseFirestore.instance.collection('messages').doc(c.conversationId).update({'unreadByHost': 0}); } }, child: const Text('Mark all read', style: TextStyle(color: Colors.white)))), body: Column(children: [Row(children: [Expanded(child: ChoiceChip(label: const Text('Messages'), selected: mode==0, onSelected: (_)=>setState(()=>mode=0))), Expanded(child: ChoiceChip(label: const Text('Notifications'), selected: mode==1, onSelected: (_)=>setState(()=>mode=1)))]), Expanded(child: IndexedStack(index: mode, children: [ListView(children: inbox.map((m)=>Card(color: m.unreadByHost>0?const Color(0xFFFFF8F5):Colors.white, child: ListTile(title: Text(m.memberName), subtitle: Text(m.lastMessage), trailing: m.unreadByHost>0?CircleAvatar(radius: 9, child: Text('${m.unreadByHost}', style: const TextStyle(fontSize: 10))):null, onTap: () async { await FirebaseFirestore.instance.collection('messages').doc(m.conversationId).update({'unreadByHost':0}); if (context.mounted) context.go('/inbox/${m.conversationId}'); }))).toList()), ListView(children: pending.map((p)=>Card(child: ListTile(title: Text(p.type), subtitle: Text('${p.memberName} · ${p.detail}'), trailing: TextButton(onPressed: ()=>FirebaseFirestore.instance.collection('pendingActions').doc(p.actionId).update({'status':'confirmed'}), child: const Text('Confirm'))))).toList())]))]));
  }
}

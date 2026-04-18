import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_header.dart';

class SendNoticeScreen extends ConsumerStatefulWidget { const SendNoticeScreen({super.key}); @override ConsumerState<SendNoticeScreen> createState() => _SendNoticeScreenState(); }
class _SendNoticeScreenState extends ConsumerState<SendNoticeScreen> {
  String target = 'all';
  final msg = TextEditingController();
  bool loading = false;
  Future<void> _send() async {
    final libraryId = ref.read(currentLibraryIdProvider);
    if (libraryId == null) return;
    setState(() => loading = true);
    await FirebaseFirestore.instance.collection('notifications_queue').add({'libraryId': libraryId, 'target': target, 'message': msg.text.trim(), 'createdAt': FieldValue.serverTimestamp()});
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notice queued'), backgroundColor: Colors.green));
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider).value ?? [];
    return Scaffold(appBar: const GradientHeader(title: 'Send Notice'), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [Wrap(spacing: 8, children: ['all','morning','evening','night','specific'].map((t)=>ChoiceChip(label: Text(t), selected: target==t, onSelected: (_)=>setState(()=>target=t))).toList()), Text('${members.length} members will receive this'), TextField(controller: msg, maxLength: 300, maxLines: 5), GradientButton(label: 'Send to ${members.length} members', onTap: _send, isLoading: loading), TextButton(onPressed: (){}, child: const Text('Save as Draft'))])));
  }
}

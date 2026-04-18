import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_header.dart';

class UpiSetupScreen extends ConsumerStatefulWidget { const UpiSetupScreen({super.key}); @override ConsumerState<UpiSetupScreen> createState() => _UpiSetupScreenState(); }
class _UpiSetupScreenState extends ConsumerState<UpiSetupScreen> {
  final upiId = TextEditingController(), upiName = TextEditingController();
  bool loading = false;
  Future<void> _save() async {
    final id = ref.read(currentLibraryIdProvider);
    if (id == null) return;
    setState(() => loading = true);
    await FirebaseFirestore.instance.collection('libraries').doc(id).update({'upiId': upiId.text.trim(), 'upiName': upiName.text.trim(), 'isLive': true});
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const GradientHeader(title: 'Payment Setup'), body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [const Text('Step 3 of 3'), const Card(color: Color(0xFFFFF3EE), child: Padding(padding: EdgeInsets.all(12), child: Text('Member pays via UPI → You confirm → Membership activates'))), TextField(controller: upiId, decoration: const InputDecoration(labelText: 'UPI ID')), TextField(controller: upiName, decoration: const InputDecoration(labelText: 'UPI Display Name')), const SizedBox(height: 12), GradientButton(label: 'Go Live 🎉', onTap: _save, isLoading: loading)])));
  }
}

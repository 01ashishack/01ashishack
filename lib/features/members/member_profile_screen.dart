import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/status_pill.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key, required this.memberId});
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(stream: FirebaseFirestore.instance.collection('members').doc(memberId).snapshots(), builder: (_, s) {
      if (!s.hasData) return const Center(child: CircularProgressIndicator());
      final d = s.data!.data() ?? {};
      return ListView(children: [Container(height: 140, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFF7931E)])), child: SafeArea(child: Column(children: [Text(d['name'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 22)), Text('Seat ${d['seatNumber'] ?? '-'} · ${d['shift'] ?? ''}', style: const TextStyle(color: Colors.white70))]))), Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [StatusPill(status: d['status'] ?? 'active'), const SizedBox(height: 12), Card(child: ListTile(title: const Text('Mobile'), subtitle: Text(d['mobile'] ?? ''))), Card(child: ListTile(title: const Text('Email'), subtitle: Text(d['email'] ?? ''))), Row(children: [Expanded(child: FilledButton(onPressed: ()=>context.go('/inbox'), child: const Text('Send Message'))), const SizedBox(width: 8), Expanded(child: OutlinedButton(onPressed: () async { await FirebaseFirestore.instance.collection('members').doc(memberId).delete(); if (context.mounted) context.pop(); }, child: const Text('Remove Member')))])]))]);
    }));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_header.dart';
import '../../core/widgets/status_pill.dart';

class MembersScreen extends ConsumerStatefulWidget { const MembersScreen({super.key}); @override ConsumerState<MembersScreen> createState() => _MembersScreenState(); }
class _MembersScreenState extends ConsumerState<MembersScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider);
    return Scaffold(
      appBar: GradientHeader(title: 'Members', right: TextButton(onPressed: ()=>context.go('/members/seat-manager'), child: const Text('Manage Seats', style: TextStyle(color: Colors.white)))),
      body: members.when(data: (list) {
        final filtered = list.where((m)=>m.name.toLowerCase().contains(query.toLowerCase()) || m.seatNumber.toLowerCase().contains(query.toLowerCase())).toList();
        return Column(children: [Padding(padding: const EdgeInsets.all(12), child: TextField(onChanged: (v)=>setState(()=>query=v), decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by name or seat number...'))), Expanded(child: ListView.builder(itemCount: filtered.length, itemBuilder: (_, i) { final m = filtered[i]; return Dismissible(key: ValueKey(m.memberId), background: Container(color: Colors.orange), secondaryBackground: Container(color: Colors.red), confirmDismiss: (_)=>showDialog<bool>(context: context, builder: (_)=>AlertDialog(title: const Text('Remove member?'), actions: [TextButton(onPressed: ()=>Navigator.pop(context,false), child: const Text('No')), FilledButton(onPressed: ()=>Navigator.pop(context,true), child: const Text('Yes'))])), onDismissed: (_)=>FirebaseFirestore.instance.collection('members').doc(m.memberId).delete(), child: Card(child: ListTile(onTap: ()=>context.push('/members/${m.memberId}'), title: Text(m.name), subtitle: Text('Seat ${m.seatNumber} · ${m.shift}'), trailing: StatusPill(status: m.status)))); }))]);
      }, loading: ()=>const Center(child: CircularProgressIndicator()), error: (_, __)=>const Center(child: Text('Error'))),
      floatingActionButton: FloatingActionButton(onPressed: ()=>context.go('/members/add'), child: const Icon(Icons.add)),
    );
  }
}

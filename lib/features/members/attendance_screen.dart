import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_header.dart';

class AttendanceScreen extends ConsumerStatefulWidget { const AttendanceScreen({super.key}); @override ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState(); }
class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  DateTime selected = DateTime.now();
  final map = <String, String>{};
  bool loading = false;

  Future<void> _save() async {
    final libraryId = ref.read(currentLibraryIdProvider);
    if (libraryId == null) return;
    setState(() => loading = true);
    final dateString = DateFormat('yyyy-MM-dd').format(selected);
    final batch = FirebaseFirestore.instance.batch();
    for (final entry in map.entries) {
      final doc = FirebaseFirestore.instance.collection('attendance').doc('${libraryId}_${entry.key}_$dateString');
      batch.set(doc, {'libraryId': libraryId, 'memberId': entry.key, 'date': dateString, 'status': entry.value, 'markedAt': FieldValue.serverTimestamp(), 'markedBy': 'host'}, SetOptions(merge: true));
    }
    await batch.commit();
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance saved'), backgroundColor: Colors.green));
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final members = ref.watch(membersProvider).value ?? [];
    return Scaffold(appBar: GradientHeader(title: 'Attendance', right: Text(DateFormat('dd MMM yyyy').format(selected), style: const TextStyle(color: Colors.white))), body: Column(children: [Row(mainAxisAlignment: MainAxisAlignment.center, children: [IconButton(onPressed: ()=>setState(()=>selected=selected.subtract(const Duration(days:1))), icon: const Icon(Icons.chevron_left)), Text(DateFormat('EEEE, d MMMM y').format(selected)), IconButton(onPressed: selected.isBefore(DateTime.now()) ? ()=>setState(()=>selected=selected.add(const Duration(days:1))) : null, icon: const Icon(Icons.chevron_right))]), Expanded(child: ListView.builder(itemCount: members.length, itemBuilder: (_, i) { final m = members[i]; return Card(child: ListTile(title: Text(m.name), subtitle: Text('Seat ${m.seatNumber} · ${m.shift}'), trailing: Row(mainAxisSize: MainAxisSize.min, children: [ChoiceChip(label: const Text('Present'), selected: map[m.memberId]=='present', onSelected: (_)=>setState(()=>map[m.memberId]='present')), const SizedBox(width: 8), ChoiceChip(label: const Text('Absent'), selected: map[m.memberId]=='absent', onSelected: (_)=>setState(()=>map[m.memberId]='absent'))]))); })), Padding(padding: const EdgeInsets.all(12), child: Column(children: [Text('${map.length} of ${members.length} marked'), GradientButton(label: 'Save Attendance', onTap: _save, isLoading: loading)]))]));
  }
}

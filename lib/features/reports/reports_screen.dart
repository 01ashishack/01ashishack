import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_header.dart';

class ReportsScreen extends ConsumerStatefulWidget { const ReportsScreen({super.key}); @override ConsumerState<ReportsScreen> createState() => _ReportsScreenState(); }
class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    final lib = ref.watch(currentLibraryIdProvider);
    return Scaffold(appBar: const GradientHeader(title: 'Reports'), body: Padding(padding: const EdgeInsets.all(12), child: Column(children: [SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: ['Overview','Members','Finance','Attendance','Seats'].asMap().entries.map((e)=>Padding(padding: const EdgeInsets.only(right: 8), child: ChoiceChip(label: Text(e.value), selected: tab==e.key, onSelected: (_)=>setState(()=>tab=e.key))).toList())), Expanded(child: IndexedStack(index: tab, children: [_overview(lib), _placeholder('Members analytics'), _finance(lib), _placeholder('Attendance analytics'), _placeholder('Seat analytics')]))])));
  }

  Widget _overview(String? lib) => ListView(children: [const Text('Overview'), SizedBox(height: 200, child: BarChart(BarChartData(barGroups: [for (var i = 0; i < 7; i++) BarChartGroupData(x: i, barRods: [BarChartRodData(toY: (i + 1) * 10.0, color: Colors.orange)])]))), SizedBox(height: 200, child: PieChart(PieChartData(sections: [PieChartSectionData(value: 70, color: Colors.orange), PieChartSectionData(value: 30, color: Colors.grey.shade300)])))]);

  Widget _finance(String? lib) {
    if (lib == null) return const Center(child: Text('No library'));
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('payments').where('libraryId', isEqualTo: lib).snapshots(),
      builder: (_, s) {
        final docs = s.data?.docs ?? [];
        final pending = docs.where((d)=>(d['status'] ?? '') != 'confirmed').toList();
        return ListView(children: [Card(child: ListTile(title: const Text('Pending payments'), subtitle: Text('${pending.length} dues'))), ...pending.map((d)=>Card(child: ListTile(title: Text(d['memberName'] ?? ''), subtitle: Text('₹${d['amount'] ?? 0}'), trailing: TextButton(onPressed: () async { await FirebaseFirestore.instance.collection('payments').doc(d.id).update({'status':'confirmed','confirmedAt':FieldValue.serverTimestamp()}); }, child: const Text('Mark Paid'))))) ]);
      },
    );
  }

  Widget _placeholder(String t) => Center(child: Text(t));
}

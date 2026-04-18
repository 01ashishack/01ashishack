import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_header.dart';

class SeatManagerScreen extends ConsumerWidget {
  const SeatManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(currentLibraryIdProvider);
    return Scaffold(
      appBar: const GradientHeader(title: 'Library Layout'),
      body: id == null
          ? const Center(child: Text('No library selected'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('libraries').doc(id).collection('floors').orderBy('order').snapshots(),
              builder: (_, floorSnap) {
                if (!floorSnap.hasData) return const Center(child: CircularProgressIndicator());
                return ListView(children: floorSnap.data!.docs.map((f) => ExpansionTile(title: Text(f['name'] ?? f.id), children: [TextButton(onPressed: () => showModalBottomSheet(context: context, builder: (_) => const _BulkSeatSheet()), child: const Text('+ Bulk Add Seats'))])).toList());
              }),
    );
  }
}

class _BulkSeatSheet extends StatelessWidget {
  const _BulkSeatSheet();
  @override
  Widget build(BuildContext context) => const Padding(padding: EdgeInsets.all(16), child: Text('Bulk create seats with WriteBatch from this sheet.'));
}

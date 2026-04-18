import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final lib = ref.watch(currentLibraryProvider).value;
    final pending = ref.watch(pendingActionsProvider).value ?? [];
    final libraryId = ref.watch(currentLibraryIdProvider);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final firstName = ((user?.name ?? '').trim().split(' ').where((e) => e.isNotEmpty).isEmpty)
        ? 'Host'
        : (user?.name ?? '').trim().split(' ').where((e) => e.isNotEmpty).first;

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.apartment, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(child: Text(lib?.name ?? 'Library', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    Stack(
                      children: [
                        const Icon(Icons.notifications_rounded, color: Colors.white),
                        if (pending.isNotEmpty) const Positioned(right: 0, child: CircleAvatar(radius: 4, backgroundColor: Colors.red)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Good day, $firstName 👋', style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppCard(
                accentColor: Colors.red,
                child: pending.isEmpty
                    ? const ListTile(leading: Icon(Icons.check_circle, color: Colors.green), title: Text('All caught up!'))
                    : Column(
                        children: [
                          for (final p in pending.take(3))
                            ListTile(
                              title: Text(p.memberName),
                              subtitle: Text(p.type),
                              trailing: TextButton(
                                onPressed: () => FirebaseFirestore.instance.collection('pendingActions').doc(p.actionId).update({'status': 'confirmed'}),
                                child: const Text('Confirm'),
                              ),
                            ),
                          Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => context.go('/inbox'), child: const Text('View All'))),
                        ],
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _stat('Active Members', ref.watch(membersProvider).value?.where((m) => m.status == 'active').length ?? 0),
                _stat('Total Members', ref.watch(membersProvider).value?.length ?? 0),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: libraryId == null
                      ? const Stream.empty()
                      : FirebaseFirestore.instance.collection('attendance').where('libraryId', isEqualTo: libraryId).where('date', isEqualTo: today).where('status', isEqualTo: 'absent').snapshots(),
                  builder: (_, s) => _stat('Absent Today', s.data?.size ?? 0),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => context.go('/members/add'), child: const Icon(Icons.add)),
    );
  }

  Widget _stat(String title, Object value) {
    return SizedBox(
      width: 170,
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title), Text('$value', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))]),
      ),
    );
  }
}

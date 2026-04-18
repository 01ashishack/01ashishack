import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = GoRouterState.of(context).uri.toString();
    final idx = loc.startsWith('/members') ? 1 : loc.startsWith('/reports') ? 2 : loc.startsWith('/inbox') ? 3 : 0;
    final pending = ref.watch(pendingActionsProvider).value?.length ?? 0;
    final unread = ref.watch(inboxProvider).value?.fold<int>(0, (a, b) => a + b.unreadByHost) ?? 0;
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        height: 72,
        decoration: BoxDecoration(color: Colors.white, border: const Border(top: BorderSide(color: AppColors.borderLight)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 16, offset: const Offset(0, -4))]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _tab(context, idx, 0, Icons.home_rounded, 'Home', '/home', badge: pending),
          _tab(context, idx, 1, Icons.people_rounded, 'Members', '/members'),
          _tab(context, idx, 2, Icons.bar_chart_rounded, 'Reports', '/reports'),
          _tab(context, idx, 3, Icons.chat_bubble_rounded, 'Inbox', '/inbox', badge: unread),
        ]),
      ),
    );
  }

  Widget _tab(BuildContext context, int idx, int i, IconData icon, String label, String route, {int badge = 0}) {
    final active = idx == i;
    final inner = Column(mainAxisSize: MainAxisSize.min, children: [Stack(children: [Icon(icon, color: active ? AppColors.primary : AppColors.textMuted, size: active ? 24 : 22), if (badge > 0) Positioned(right: -8, top: -8, child: CircleAvatar(radius: 9, backgroundColor: Colors.red, child: Text('$badge', style: const TextStyle(fontSize: 10, color: Colors.white))))]), Text(label, style: TextStyle(fontSize: 11, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: active ? AppColors.primary : AppColors.textMuted))]);
    return InkWell(onTap: ()=>context.go(route), child: active ? Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), decoration: BoxDecoration(color: AppColors.lightOrange, borderRadius: BorderRadius.circular(20)), child: inner) : inner);
  }
}

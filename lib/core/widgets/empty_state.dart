import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle, this.action});
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 44, color: Colors.grey), const SizedBox(height: 8), Text(title, style: Theme.of(context).textTheme.titleMedium), Text(subtitle), if (action != null) const SizedBox(height: 12), if (action != null) action!],));
  }
}

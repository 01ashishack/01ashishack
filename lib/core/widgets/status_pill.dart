import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final map = {
      'active': [const Color(0xFFF0FDF4), AppColors.success, const Color(0xFFBBF7D0)],
      'expiring': [const Color(0xFFFFFBEB), AppColors.warning, const Color(0xFFFDE68A)],
      'overdue': [const Color(0xFFFEF2F2), AppColors.error, const Color(0xFFFECACA)],
      'expired': [const Color(0xFFF9FAFB), AppColors.textGray, const Color(0xFFE5E7EB)],
    };
    final c = map[status] ?? map['expired']!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: c[0], border: Border.all(color: c[2]), borderRadius: BorderRadius.circular(999)),
      child: Text(status.toUpperCase(), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: c[1], fontWeight: FontWeight.w700)),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(20), this.accentColor, this.onTap});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 2))],
      ),
      child: child,
    );
    return Stack(children: [if (accentColor != null) Positioned.fill(left: 0, right: null, child: Container(width: 4, decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(16)))), if (onTap != null) InkWell(onTap: onTap, child: content) else content]);
  }
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({super.key, required this.label, required this.onTap, this.isLoading = false, this.isDisabled = false});
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final disabled = isDisabled || isLoading;
    return InkWell(
      onTap: disabled ? null : onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: disabled ? null : AppColors.primaryGradient,
          color: disabled ? Colors.grey.shade400 : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: disabled ? null : [BoxShadow(color: const Color(0xFFFF6B35).withOpacity(.35), blurRadius: 20, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}

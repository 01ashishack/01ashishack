import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class GradientHeader extends StatelessWidget implements PreferredSizeWidget {
  const GradientHeader({super.key, required this.title, this.showBackButton = true, this.right});
  final String title;
  final bool showBackButton;
  final Widget? right;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            if (showBackButton)
              Positioned(left: 20, top: 16, child: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white))),
            Center(child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white))),
            if (right != null) Positioned(right: 20, top: 20, child: right!),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(112);
}

import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.error_outline, color: Colors.red), const SizedBox(height: 8), Text(message, textAlign: TextAlign.center), if (onRetry != null) TextButton(onPressed: onRetry, child: const Text('Retry'))]));
  }
}

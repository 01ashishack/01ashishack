import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_header.dart';

class ForgotPasswordScreen extends StatefulWidget { const ForgotPasswordScreen({super.key}); @override State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState(); }
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final email = TextEditingController();
  bool sent = false, loading = false;

  Future<void> _send() async {
    setState(() => loading = true);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
    if (mounted) setState(() { sent = true; loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const GradientHeader(title: 'Forgot Password'), body: Padding(padding: const EdgeInsets.all(16), child: sent ? Column(children: [const Icon(Icons.check_circle, color: Colors.green, size: 80), const Text('Reset link sent! Check your email.'), GradientButton(label: 'Back to Login', onTap: ()=>Navigator.of(context).pop())]) : Column(children: [TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')), const SizedBox(height: 12), GradientButton(label: 'Send Reset Link', onTap: _send, isLoading: loading)])));
  }
}

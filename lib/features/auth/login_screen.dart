import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/gradient_button.dart';

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState() => _LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  bool signup = false, host = false, loading = false, hide = true;
  String? error;
  final name = TextEditingController(), email = TextEditingController(), pass = TextEditingController(), confirm = TextEditingController();

  Future<void> _submit() async {
    setState(() { loading = true; error = null; });
    try {
      if (signup) {
        if (!host) throw FirebaseAuthException(code: 'host_only', message: 'Please confirm host registration.');
        if (pass.text != confirm.text) throw FirebaseAuthException(code: 'pass', message: 'Passwords do not match');
        final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim());
        await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({'uid': cred.user!.uid, 'email': email.text.trim(), 'role': 'host', 'name': name.text.trim(), 'mobile': '', 'photoUrl': '', 'createdAt': FieldValue.serverTimestamp()});
        if (mounted) context.go('/onboarding/profile');
      } else {
        final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.trim(), password: pass.text.trim());
        final u = await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).get();
        if ((u.data() ?? {})['role'] != 'host') throw FirebaseAuthException(code: 'role', message: 'Only hosts are allowed');
        final libs = await FirebaseFirestore.instance.collection('libraries').where('hostUid', isEqualTo: cred.user!.uid).limit(1).get();
        if (libs.docs.isEmpty) { if (mounted) context.go('/onboarding/profile'); return; }
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('libraryId', libs.docs.first.id);
        if (mounted) context.go('/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [Container(height: 112, decoration: const BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28))), alignment: Alignment.center, child: Text('LibraryOS', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white))), const SizedBox(height: 16), Row(children:[Expanded(child: ChoiceChip(label: const Text('Login'), selected: !signup, onSelected: (_) => setState(() => signup=false))), const SizedBox(width: 8), Expanded(child: ChoiceChip(label: const Text('Sign Up'), selected: signup, onSelected: (_) => setState(() => signup=true)))]), const SizedBox(height: 12), if (signup) TextField(controller: name, decoration: const InputDecoration(labelText: 'Full Name')), TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')), TextField(controller: pass, obscureText: hide, decoration: InputDecoration(labelText: 'Password', suffixIcon: IconButton(onPressed: ()=>setState(()=>hide=!hide), icon: Icon(hide?Icons.visibility:Icons.visibility_off)))), if (signup) TextField(controller: confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password')), if (!signup) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: ()=>context.push('/auth/forgot-password'), child: const Text('Forgot Password?'))), if (signup) CheckboxListTile(value: host, onChanged: (v)=>setState(()=>host=v??false), title: const Text('I am registering as a Library Host')), const SizedBox(height: 12), GradientButton(label: signup ? 'Create Account' : 'Login', onTap: _submit, isLoading: loading), if (error != null) Container(margin: const EdgeInsets.only(top: 12), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12)), child: Text(error!, style: const TextStyle(color: Colors.red)))])));
  }
}

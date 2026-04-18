import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_go());
  }

  Future<void> _go() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;
    if (user == null) return context.go('/auth/login');
    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if ((doc.data() ?? {})['role'] != 'host') {
      await FirebaseAuth.instance.signOut();
      if (mounted) context.go('/auth/login');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final libs = await FirebaseFirestore.instance.collection('libraries').where('hostUid', isEqualTo: user.uid).limit(1).get();
    if (libs.docs.isEmpty) return context.go('/onboarding/profile');
    final id = libs.docs.first.id;
    prefs.setString('libraryId', id);
    ref.read(currentLibraryIdProvider.notifier).state = id;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text('Library', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white, fontSize: 40)), Text('OS', style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white70, fontSize: 40)), const SizedBox(height: 8), const Text('Run your library smarter', style: TextStyle(color: Colors.white))])),
      ),
    );
  }
}

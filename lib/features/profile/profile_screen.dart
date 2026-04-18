import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _uploadPhoto(BuildContext context) async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (x == null) return;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref('profile_photos/$uid.jpg');
    await ref.putFile(File(x.path));
    final url = await ref.getDownloadURL();
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(url);
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile photo updated'), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final lib = ref.watch(currentLibraryProvider).value;
    return Scaffold(appBar: GradientHeader(title: 'Profile', right: IconButton(onPressed: (){}, icon: const Icon(Icons.settings, color: Colors.white))), body: ListView(padding: const EdgeInsets.all(16), children: [Card(child: ListTile(leading: CircleAvatar(child: Text((user?.name ?? 'H').substring(0,1))), title: Text(user?.name ?? ''), subtitle: Text(user?.email ?? ''), trailing: IconButton(onPressed: ()=>_uploadPhoto(context), icon: const Icon(Icons.camera_alt)))), Card(child: SwitchListTile(value: lib?.isLive ?? false, onChanged: (_){}, title: const Text('Live Status'))), Card(child: ListTile(title: const Text('Log Out'), onTap: () async { await FirebaseAuth.instance.signOut(); if (context.mounted) context.go('/auth/login'); })), Card(child: const ListTile(title: Text('Delete Account'), subtitle: Text('Contact support')))]));
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_header.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final name = TextEditingController();
  final mobile = TextEditingController();
  final city = TextEditingController();
  DateTime? dob;
  XFile? photo;
  bool loading = false;

  Future<String> _upload() async {
    if (photo == null) return '';
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref('profile_photos/$uid.jpg');
    await ref.putFile(File(photo!.path));
    return ref.getDownloadURL();
  }

  Future<void> _save() async {
    setState(() => loading = true);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final photoUrl = await _upload();
    await FirebaseFirestore.instance.collection('users').doc(uid).set({'name': name.text, 'mobile': mobile.text, 'city': city.text, 'dob': dob == null ? null : Timestamp.fromDate(dob!), 'photoUrl': photoUrl}, SetOptions(merge: true));
    if (mounted) context.go('/onboarding/library');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientHeader(title: 'Complete Your Profile'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Step 1 of 3 — Personal Details'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final picked = await ImagePicker().pickImage(source: ImageSource.camera);
              if (picked != null) setState(() => photo = picked);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
          ),
          TextField(controller: name, decoration: const InputDecoration(labelText: 'Full Name*')),
          TextField(controller: mobile, decoration: const InputDecoration(labelText: 'Mobile +91*')),
          TextField(controller: city, decoration: const InputDecoration(labelText: 'City*')),
          ListTile(
            title: Text(dob == null ? 'Date of Birth' : dob.toString().split(' ').first),
            onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1960), lastDate: DateTime.now());
              if (picked != null) setState(() => dob = picked);
            },
          ),
          GradientButton(label: 'Next →', onTap: _save, isLoading: loading),
        ],
      ),
    );
  }
}

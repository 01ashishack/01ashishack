import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_header.dart';

class LibrarySetupScreen extends ConsumerStatefulWidget { const LibrarySetupScreen({super.key}); @override ConsumerState<LibrarySetupScreen> createState() => _LibrarySetupScreenState(); }
class _LibrarySetupScreenState extends ConsumerState<LibrarySetupScreen> {
  final name = TextEditingController(), address = TextEditingController(), city = TextEditingController(), pincode = TextEditingController();
  final amenityOptions = const ['AC','WiFi','Locker','CCTV','Drinking Water','Power Backup','Washroom','Parking'];
  final shiftMap = const {'morning':'Morning','evening':'Evening','night':'Night','fullday':'Full Day'};
  final selected = <String>{};
  final shifts = <String>{};
  final photos = <XFile>[];
  bool loading = false;

  Future<List<String>> _uploadPhotos() async {
    final out = <String>[];
    for (final x in photos) {
      final ref = FirebaseStorage.instance.ref('library_photos/${DateTime.now().millisecondsSinceEpoch}_${x.name}');
      await ref.putFile(File(x.path));
      out.add(await ref.getDownloadURL());
    }
    return out;
  }

  Future<void> _save() async {
    setState(() => loading = true);
    final photoUrls = await _uploadPhotos();
    final refDoc = await FirebaseFirestore.instance.collection('libraries').add({'hostUid': FirebaseAuth.instance.currentUser!.uid, 'name': name.text, 'city': city.text, 'address': address.text, 'pincode': pincode.text, 'photos': photoUrls, 'amenities': selected.toList(), 'shifts': shifts.toList(), 'upiId': '', 'upiName': '', 'isLive': false, 'createdAt': FieldValue.serverTimestamp()});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('libraryId', refDoc.id);
    ref.read(currentLibraryIdProvider.notifier).state = refDoc.id;
    if (mounted) context.go('/onboarding/upi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const GradientHeader(title: 'Setup Your Library'), body: ListView(padding: const EdgeInsets.all(16), children: [const Text('Step 2 of 3'), TextField(controller: name, decoration: const InputDecoration(labelText: 'Library Name*')), TextField(controller: address, decoration: const InputDecoration(labelText: 'Full Address*')), TextField(controller: city, decoration: const InputDecoration(labelText: 'City*')), Wrap(spacing: 8, children: amenityOptions.map((a)=>FilterChip(label: Text(a), selected: selected.contains(a), onSelected: (v)=>setState(() => v ? selected.add(a) : selected.remove(a)))).toList()), const SizedBox(height: 8), ...shiftMap.entries.map((e)=>SwitchListTile(value: shifts.contains(e.key), onChanged: (v)=>setState(()=>v?shifts.add(e.key):shifts.remove(e.key)), title: Text(e.value))), OutlinedButton(onPressed: () async { final x = await ImagePicker().pickImage(source: ImageSource.gallery); if (x != null && photos.length < 5) setState(()=>photos.add(x)); }, child: Text('Add Photos (${photos.length}/5)')), GradientButton(label: 'Next →', onTap: _save, isLoading: loading)]));
  }
}

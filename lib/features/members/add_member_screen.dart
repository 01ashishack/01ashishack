import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/widgets/gradient_button.dart';
import '../../core/widgets/gradient_header.dart';

class AddMemberScreen extends ConsumerStatefulWidget { const AddMemberScreen({super.key}); @override ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState(); }
class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  int step = 0; bool loading = false; XFile? photo;
  final name = TextEditingController(), mobile = TextEditingController(), email = TextEditingController();
  String shift = 'morning', paymentMethod = 'upi', seatId = '', seatNumber = '', floorId = '', sectionId = '', plan = '1';
  bool paymentReceived = false;

  Future<String> _uploadPhoto(String memberId) async {
    if (photo == null) return '';
    final ref = FirebaseStorage.instance.ref('member_photos/$memberId.jpg');
    await ref.putFile(File(photo!.path));
    return ref.getDownloadURL();
  }

  Future<void> _create() async {
    final libraryId = ref.read(currentLibraryIdProvider);
    final lib = ref.read(currentLibraryProvider).value;
    if (libraryId == null || seatId.isEmpty) return;
    setState(() => loading = true);
    final memberId = const Uuid().v4();
    final photoUrl = await _uploadPhoto(memberId);
    final start = DateTime.now();
    final end = DateTime(start.year, start.month + int.parse(plan), start.day);
    final seatDoc = FirebaseFirestore.instance.collection('libraries').doc(libraryId).collection('floors').doc(floorId).collection('sections').doc(sectionId).collection('seats').doc(seatId);
    final memberDoc = FirebaseFirestore.instance.collection('members').doc(memberId);
    final batch = FirebaseFirestore.instance.batch();
    batch.set(memberDoc, {'memberId': memberId, 'libraryId': libraryId, 'hostUid': FirebaseAuth.instance.currentUser!.uid, 'name': name.text.trim(), 'mobile': mobile.text.trim(), 'email': email.text.trim(), 'dob': null, 'gender': '', 'address': '', 'preparingFor': '', 'photoUrl': photoUrl, 'seatId': seatId, 'floorId': floorId, 'sectionId': sectionId, 'seatNumber': seatNumber, 'shift': shift, 'planDuration': int.parse(plan), 'planAmount': plan == '1' ? 800 : plan == '3' ? 2200 : 4000, 'startDate': Timestamp.fromDate(start), 'endDate': Timestamp.fromDate(end), 'status': 'active', 'paymentStatus': paymentReceived ? 'paid' : 'pending', 'addedBy': 'host', 'createdAt': FieldValue.serverTimestamp()});
    batch.update(seatDoc, {'status': 'occupied', 'assignedMemberId': memberId});
    await batch.commit();
    if (paymentReceived) {
      await FirebaseFirestore.instance.collection('payments').add({'libraryId': libraryId, 'memberId': memberId, 'memberName': name.text.trim(), 'amount': plan == '1' ? 800 : plan == '3' ? 2200 : 4000, 'method': paymentMethod, 'status': 'confirmed', 'month': DateFormat('MMMM yyyy').format(DateTime.now()), 'confirmedAt': FieldValue.serverTimestamp(), 'createdAt': FieldValue.serverTimestamp()});
    }
    if (mounted) { setState(() { loading = false; step = 3; }); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Member Added Successfully!'), backgroundColor: Colors.green)); }
  }

  @override
  Widget build(BuildContext context) {
    final libraryId = ref.watch(currentLibraryIdProvider);
    final lib = ref.watch(currentLibraryProvider).value;
    return Scaffold(appBar: const GradientHeader(title: 'Add Member'), body: Padding(padding: const EdgeInsets.all(16), child: step == 3 ? Column(children: [const Icon(Icons.check_circle, color: Colors.green, size: 80), const Text('Member Added Successfully!'), GradientButton(label: 'View Profile', onTap: ()=>context.go('/members')), TextButton(onPressed: ()=>setState(()=>step=0), child: const Text('Add Another'))]) : Column(children: [Text('Step ${step + 1} of 3'), if (step == 0) ...[OutlinedButton(onPressed: () async => photo = await ImagePicker().pickImage(source: ImageSource.camera), child: const Text('Take Photo')), TextField(controller: name, decoration: const InputDecoration(labelText: 'Full Name*')), TextField(controller: mobile, decoration: const InputDecoration(labelText: 'Mobile*')), TextField(controller: email, decoration: const InputDecoration(labelText: 'Email'))], if (step == 1) ...[DropdownButtonFormField(value: shift, items: const [DropdownMenuItem(value:'morning',child:Text('Morning')),DropdownMenuItem(value:'evening',child:Text('Evening')),DropdownMenuItem(value:'night',child:Text('Night')),DropdownMenuItem(value:'fullday',child:Text('Full Day'))], onChanged:(v)=>setState(()=>shift=v!)), DropdownButtonFormField(value: plan, items: const [DropdownMenuItem(value:'1',child:Text('1 Month ₹800')),DropdownMenuItem(value:'3',child:Text('3 Months ₹2200')),DropdownMenuItem(value:'6',child:Text('6 Months ₹4000'))], onChanged:(v)=>setState(()=>plan=v!)), TextField(decoration: const InputDecoration(labelText: 'Seat ID'), onChanged: (v)=>seatId=v), TextField(decoration: const InputDecoration(labelText: 'Seat Number'), onChanged: (v)=>seatNumber=v), TextField(decoration: const InputDecoration(labelText: 'Floor ID'), onChanged: (v)=>floorId=v), TextField(decoration: const InputDecoration(labelText: 'Section ID'), onChanged: (v)=>sectionId=v)], if (step == 2) ...[Wrap(spacing: 8, children: ['upi','cash','bank'].map((m)=>ChoiceChip(label: Text(m.toUpperCase()), selected: paymentMethod==m, onSelected: (_)=>setState(()=>paymentMethod=m))).toList()), if (paymentMethod == 'upi') ...[GradientButton(label: 'Share via WhatsApp', onTap: () => launchUrl(Uri.parse('https://api.whatsapp.com/send?text=Pay%20₹${plan == '1' ? 800 : plan == '3' ? 2200 : 4000}%0AUPI:%20${lib?.upiId ?? ''}'))), SwitchListTile(value: paymentReceived, onChanged: (v)=>setState(()=>paymentReceived=v), title: const Text('Payment Received ✓'))]], const Spacer(), GradientButton(label: step == 2 ? 'Add Member' : 'Next →', isLoading: loading, onTap: () { if (step < 2) setState(()=>step++); else _create(); })])));
  }
}

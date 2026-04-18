import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/library_model.dart';
import '../models/member_model.dart';
import '../models/message_model.dart';
import '../models/pending_action_model.dart';
import '../models/user_model.dart';

final authStateProvider = StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  return doc.exists ? UserModel.fromFirestore(doc) : null;
});

final currentLibraryIdProvider = StateProvider<String?>((ref) => null);

final currentLibraryProvider = StreamProvider<LibraryModel?>((ref) {
  final id = ref.watch(currentLibraryIdProvider);
  if (id == null) return Stream.value(null);
  return FirebaseFirestore.instance.collection('libraries').doc(id).snapshots().map((d) => d.exists ? LibraryModel.fromFirestore(d) : null);
});

final pendingActionsProvider = StreamProvider<List<PendingActionModel>>((ref) {
  final libraryId = ref.watch(currentLibraryIdProvider);
  if (libraryId == null) return Stream.value([]);
  return FirebaseFirestore.instance.collection('pendingActions').where('libraryId', isEqualTo: libraryId).where('status', isEqualTo: 'pending').orderBy('createdAt', descending: true).snapshots().map((s) => s.docs.map(PendingActionModel.fromFirestore).toList());
});

final membersProvider = StreamProvider<List<MemberModel>>((ref) {
  final libraryId = ref.watch(currentLibraryIdProvider);
  if (libraryId == null) return Stream.value([]);
  return FirebaseFirestore.instance.collection('members').where('libraryId', isEqualTo: libraryId).orderBy('name').snapshots().map((s) => s.docs.map(MemberModel.fromFirestore).toList());
});

final inboxProvider = StreamProvider<List<MessageModel>>((ref) {
  final libraryId = ref.watch(currentLibraryIdProvider);
  if (libraryId == null) return Stream.value([]);
  return FirebaseFirestore.instance.collection('messages').where('libraryId', isEqualTo: libraryId).orderBy('lastMessageAt', descending: true).snapshots().map((s) => s.docs.map(MessageModel.fromFirestore).toList());
});

import 'package:clone/model/userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nameControllerProvider = Provider.autoDispose<TextEditingController>(
    (ref) => TextEditingController());
final usernameControllerProvider = Provider.autoDispose<TextEditingController>(
    (ref) => TextEditingController());
final bioControllerProvider = Provider.autoDispose<TextEditingController>(
    (ref) => TextEditingController());
final searchControllerProvider = Provider.autoDispose<TextEditingController>(
    (ref) => TextEditingController());
final streamProvider =
    StreamProvider.autoDispose<DocumentSnapshot<Map<String, dynamic>>>(
  ((ref) => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()),
);
// for home page
final streamProvider2 =
    StreamProvider.autoDispose<DocumentSnapshot<Map<String, dynamic>>>(
  ((ref) => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .snapshots()),
);
final userProvider = Provider((ref) => FirebaseAuth.instance.currentUser);

final searchAsyncProvider =
    FutureProvider.autoDispose.family<DocumentSnapshot, String>(
  ((ref, docid) =>
      FirebaseFirestore.instance.collection('users').doc(docid).get()),
);

Future profileDataSubmit(ref) async {
  final namecontroller = ref.read(nameControllerProvider);
  final usernamecontroller = ref.read(usernameControllerProvider);
  final biocontroller = ref.read(bioControllerProvider);

  if (namecontroller.text.isNotEmpty) {
    await setProfileName(namecontroller.text).then((value) {
      namecontroller.clear();
    });
  }
  if (usernamecontroller.text.isNotEmpty) {
    await setUserName(usernamecontroller.text).then((value) {
      usernamecontroller.clear();
    });
  }
  if (biocontroller.text.isNotEmpty) {
    await setbio(biocontroller.text).then((value) {
      biocontroller.clear();
    });
  }
}

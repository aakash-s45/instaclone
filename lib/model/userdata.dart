import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var dbRef = FirebaseFirestore.instance.collection('users');

var userid = FirebaseAuth.instance.currentUser!.uid;

Future<void> setProfileName(String name) async {
  await dbRef.doc(userid).update({'name': name});
}

Future<void> setUserName(String username) async {
  await dbRef.doc(userid).update({'uname': username});
}

Future<void> setbio(String bio) async {
  await dbRef.doc(userid).update({'bio': bio});
}

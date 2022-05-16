// ignore_for_file: avoid_print
import 'dart:ffi';

import 'package:clone/fire/provider.dart';
import 'package:clone/model/database.dart';
import 'package:clone/model/user.dart';
import 'package:clone/model/userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'error.dart';

Future<String?> signIn(String email, String pass) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserData().setuser = user;
      return user.uid;
    } else {
      print('Uid not found');
      return null;
    }
  } catch (e) {
    if (e.hashCode == 185768934) {
      AuthError.logoutErrorMessage =
          "Invalid Password or User does not have a Password";
    }
    if (e.hashCode == 505284406) {
      AuthError.logoutErrorMessage = "User not found! Try creating new account";
    }
    if (e.hashCode == 140382746) {
      AuthError.logoutErrorMessage =
          "Account temporarily blocked due to too many bad requests";
    }
    print(e.hashCode);
    print(e);
    return null;
  }
}

Future<String?> register(String email, String pass, String userName) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pass);
    User? user = FirebaseAuth.instance.currentUser;
    // create the template in database
    await addUser();
    if (user != null) {
      UserData().setuser = user;
      return user.uid;
    } else {
      print('Uid not found');
      return null;
    }
  } catch (e) {
    // 34618382
    if (e.hashCode == 34618382) {
      AuthError.registerErrorMessage =
          "The email address is already in use by another account.";
    }
    print(e);
    print(e.hashCode);
    return null;
  }
}

Future signOut() async {
  try {
    return await FirebaseAuth.instance.signOut();
  } catch (e) {
    print(e.toString());
    return null;
  }
}

Future<bool> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  // return await FirebaseAuth.instance.signInWithCredential(credential);
  UserCredential result =
      await FirebaseAuth.instance.signInWithCredential(credential);

  User? user = result.user;

  if (result != null) {
    print("userid in login page: ${user!.uid}");
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
      } else {
        // print("new doc created");
        addUser();
      }
      UserData().setuser = user;
      return true;
    });
  } else {
    return false;
  }
  return false;
}

Future<bool?> doesUserExist(username) async {
  try {
// if the size of value is greater then 0 then that doc exist.
    await FirebaseFirestore.instance
        .collection('users')
        .where('uname', isEqualTo: username)
        .get()
        .then((value) {
      print("value");
      return (value.size > 0) ? true : false;
    });
  } catch (e) {
    print(e.toString());
  }
}

Future addUser() async {
  try {
    User user = FirebaseAuth.instance.currentUser!;
    // if (FirebaseFirestore.instance.collection('users').doc(userid) == null) {
    //   print("new doc creaetd ");
    // }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set(
          DBContent.initialData,
        )
        .then((value) async {
      String _username = (user.email)!.split("@")[0];
      if (_username != null) {
        await setUserName(_username);
      }
    });
  } catch (e) {
    print(e.toString());
    // return null;
  }
}

Future addPost(String url, String uploadType) async {
  try {
    var userid = FirebaseAuth.instance.currentUser!.uid;
    var docRef = FirebaseFirestore.instance.collection('users').doc(userid);
    Timestamp currentTime = Timestamp.now();
    if (uploadType == "post") {
      docRef.update({
        'post': FieldValue.arrayUnion([
          {"posturl": url, "posttime": currentTime}
        ])
      });
      // docRef.update({
      //   'post': FieldValue.arrayUnion([url])
      // });
    } else if (uploadType == "reels") {
      docRef.update({
        'reels': FieldValue.arrayUnion([url])
      });
    } else if (uploadType == "profile") {
      docRef.update({'profile': url});
    } else {
      docRef.update({
        'story': FieldValue.arrayUnion([url])
      });
    }
  } catch (e) {
    print(e.toString());
    // return null;
  }
}

Future<void> followUser(String userid, ref) async {
  var myuserid = ref.read(userProvider).uid;
  var mydocRef = FirebaseFirestore.instance.collection('users').doc(myuserid);
  var userdocref = FirebaseFirestore.instance.collection('users').doc(userid);
  try {
    mydocRef.update({
      'followings': FieldValue.arrayUnion([userid])
    });
    userdocref.update({
      'followers': FieldValue.arrayUnion([myuserid])
    });
  } catch (e) {
    print(e.toString());
  }
  // add this userid to my following
  // add my userid to this user's followers
}

Future<void> unfollowUser(String userid, ref) async {
  var myuserid = ref.read(userProvider).uid;
  var mydocRef = FirebaseFirestore.instance.collection('users').doc(myuserid);
  var userdocref = FirebaseFirestore.instance.collection('users').doc(userid);
  try {
    mydocRef.update({
      'followings': FieldValue.arrayRemove([userid])
    });
    userdocref.update({
      'followers': FieldValue.arrayRemove([myuserid])
    });
  } catch (e) {
    print(e.toString());
  }
  // remove this userid from my following
  // remove my userid from this user's followers
}

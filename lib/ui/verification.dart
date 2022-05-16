import 'dart:async';
import 'package:clone/ui/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool isverified = false;
  Timer? timer;
// send email verification mail
  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something Get Wrong')));
      e.toString();
    }
  }

// check for verification
  Future checkEmailVerifeid() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isverified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isverified) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Email verified 🔥')));
      timer?.cancel();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();

    isverified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!(FirebaseAuth.instance.currentUser!.emailVerified)) {
      sendVerificationEmail();
      print("email verification sent");
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerifeid());
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(
        child: Text("Waiting for verifiaction"),
      ),
    );
  }
}

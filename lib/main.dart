import 'package:clone/ui/home.dart';
import 'package:clone/ui/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: await getLandingPage(),
    ),
  ));
}

Future<Widget> getLandingPage() async {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData && (!snapshot.data!.isAnonymous)) {
        print("Logged in:- main");
        return Homepage();
      }
      print("Logged out:- main");
      return Authentication();
    },
  );
}

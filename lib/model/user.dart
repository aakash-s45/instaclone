import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static late User user;
  set setuser(User usr) {
    user = usr;
  }
}

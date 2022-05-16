import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final storageRef = FirebaseStorage.instance.ref(destination);
      return storageRef.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
      return null;
    }
  }
}

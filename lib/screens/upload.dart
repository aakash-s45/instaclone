import 'dart:io';

import 'package:clone/fire/fire.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:clone/model/firebaseapi.dart';
import 'package:path/path.dart';

class UploadPage extends StatefulWidget {
  final String uploadType;
  UploadPage({Key? key, required this.uploadType}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? file;
  UploadTask? task;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      return;
    }
    final path = result.files.single.path!;
    setState(() {
      file = File(path);
    });
  }

  Future uploadFile() async {
    if (file == null) return;
    final fileName = basename(file!.path);
    final destination = 'photos/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    await snapshot.ref.getDownloadURL().then(
      (downlaodUrl) async {
        await addPost(downlaodUrl, widget.uploadType);
        // ?save this to firestore
      },
    );

    // print('Download-Link: $urlDownload');
  }

  Widget uploadStatus(UploadTask task) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData && !(snapshot.hasError)) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);
          return Text(
            '$percentage %',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // (file != null)
          // ?
          Text(widget.uploadType.toUpperCase()),
          const SizedBox(height: 20),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: (file != null)
                      ? InteractiveViewer(child: Image.file(file!))
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Select Image"),
                        ),
                ),
              ),
            ),
          ),
          // : Container(),
          // const SizedBox(height: 20),
          Container(
            // flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: selectFile,
                      child: const Text("Select"),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: uploadFile,
                      child: const Text("Uplaod"),
                    ),
                  ],
                ),
                (task != null) ? uploadStatus(task!) : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

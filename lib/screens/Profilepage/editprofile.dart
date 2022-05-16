// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print
import 'package:clone/fire/fire.dart';
import 'package:clone/fire/provider.dart';
import 'package:clone/screens/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    TextEditingController _namecontroller = ref.watch(nameControllerProvider);
    TextEditingController _usernamecontroller =
        ref.watch(usernameControllerProvider);
    TextEditingController _biocontroller = ref.watch(bioControllerProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await profileDataSubmit(ref).then((value) {
                Navigator.pop(context);
              });
              print("done");
            },
            icon: const Icon(Icons.done),
          )
        ],
        title: const Text("Edit profile"),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 5,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      body: UploadPage(
                        uploadType: "profile",
                      ),
                    ),
                  ));
              print("Edit profile picture");
            },
            child: const Text(
              "Change profile photo",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
          ),
          TextInputField(
            passfeild: _namecontroller,
            labelText: "Name",
            hintText: "Enter your name",
          ),
          TextInputField(
            passfeild: _usernamecontroller,
            labelText: "Username",
            hintText: "Enter your username",
          ),
          TextInputField(
            passfeild: _biocontroller,
            labelText: "Bio",
            hintText: "Write about yourself",
          ),
        ],
      ),
    );
  }
}

class TextInputField extends StatelessWidget {
  const TextInputField(
      {Key? key, required this.passfeild, this.labelText, this.hintText})
      : super(key: key);

  final TextEditingController passfeild;
  final String? labelText;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enableSuggestions: false,
        controller: passfeild,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
            hintText: hintText),
      ),
    );
  }
}

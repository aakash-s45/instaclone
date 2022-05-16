import 'package:clone/ui/verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../fire/error.dart';
import '../model/mytheme.dart';
import '../../fire/fire.dart';
import '../model/userdata.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String userID;
  final TextEditingController _usernamefeild = TextEditingController();
  final TextEditingController _emailfeild = TextEditingController();
  final TextEditingController _passfeild = TextEditingController();
  final TextEditingController _confpassfeild = TextEditingController();
  var _validate = 0;

  @override
  void dispose() {
    super.dispose();
    _usernamefeild.dispose();
    _emailfeild.dispose();
    _passfeild.dispose();
    _confpassfeild.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? passErrortext;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
          backgroundColor: MyTheme.primaryColor,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   width: MediaQuery.of(context).size.width / 1.4,
              //   child: TextFormField(
              //     onChanged: (text) async {
              //       // use the text

              //       await FirebaseFirestore.instance
              //           .collection('users')
              //           .where('uname', isEqualTo: text)
              //           .get()
              //           .then((value) {
              //         setState(() {
              //           _validate = value.size;
              //         });
              //         print(value.size);
              //       });
              //     },
              //     controller: _usernamefeild,
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: 'UserName',
              //       hintText: 'Jhon The Don',
              //       errorText:
              //           (_validate != 0) ? 'Username already exist' : null,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.4,
                child: TextFormField(
                  controller: _emailfeild,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'jhon@gmail.com',
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: TextFormField(
                  obscureText: true,
                  controller: _passfeild,
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Password',
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width / 1.4,
                child: TextFormField(
                  obscureText: true,
                  controller: _confpassfeild,
                  onChanged: (text) {
                    print(text);
                    if (text != _passfeild.text) {
                      setState(() {
                        passErrortext = "Password not equal";
                      });
                    } else if (text.length < 6 || _passfeild.text.length < 6) {
                      setState(() {
                        passErrortext = "try bigger password";
                      });
                    } else {
                      setState(() {
                        passErrortext = null;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm password',
                    hintText: 'Confirm Password',
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: MyTheme.primaryColor,
                  ),
                  child: MaterialButton(
                    onPressed: (_emailfeild.text.isNotEmpty)
                        ? () async {
                            String? navi;
                            if (_passfeild.text != _confpassfeild.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Password not matching")));
                            } else if (_passfeild.text.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Password should be at least 6 characters")));
                            } else {
                              await register(_emailfeild.text, _passfeild.text,
                                      _usernamefeild.text)
                                  .then((value) {
                                navi = value;
                              });
                              String _username = _emailfeild.text.split("@")[0];
                              _emailfeild.clear();
                              _passfeild.clear();
                              _confpassfeild.clear();
                              if (navi != null) {
                                // now the user is registered and now here we can set the username
                                await setUserName(_username);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Verify(),
                                    ));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AuthError.registerErrorMessage)));
                              }
                            }
                          }
                        : null,
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}

import 'package:clone/screens/HomePage/posttile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../fire/fire.dart';

class Button extends StatefulWidget {
  String uid;
  bool follow;
  Button({required this.uid, required this.follow, Key? key}) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  String myuid = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    isFollowed(myuid, widget.uid).then((value) {
      print(value);
      // widget.follow = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () async {
                    if (widget.follow) {
                      print("follow done");
                      await followUser(widget.uid, ref);
                      setState(() {
                        widget.follow = false;
                      });
                    } else {
                      print("unfollow done");
                      await unfollowUser(widget.uid, ref);
                      setState(() {
                        widget.follow = true;
                      });
                    }
                  },
                  child: widget.follow ? Text("Follow") : Text("Unfollow"),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black)),
                  onPressed: () {
                    print("message done");
                    // followUser(widget.uid, ref);
                    // setState(() {
                    //   widget.follow = true;
                    // });
                  },
                  child: Text("Message"),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> isFollowed(String myuid, String userid) async {
  try {
    var doc =
        await FirebaseFirestore.instance.collection('users').doc(myuid).get();
    await (doc as dynamic)['followings'].forEach((uid) {
      print(uid);
      print(userid);
      return (uid == userid);
    });
  } catch (e) {
    print(e.toString());
    return false;
  }
  return false;
}

// return a user's all the posts
class PostTile extends StatelessWidget {
  var docref;
  var postObj;
  PostTile({Key? key, required this.docref, required this.postObj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Timestamp.now().toDate()
    final store = postObj['posttime'].toDate();
    final date2 = DateTime.now();
    final difference = date2.difference(store).inHours;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(7),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 30,
            child: Row(children: [
              CircleAvatar(
                backgroundImage: NetworkImage((docref as dynamic)['profile']),
              ),
              const SizedBox(width: 5.0),
              Text(
                (docref as dynamic)['uname'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ]),
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: FittedBox(
              child:
                  InteractiveViewer(child: Image.network(postObj['posturl'])),
              fit: BoxFit.fill,
            )),
        Row(
          children: [
            IconButton(
              icon: const Icon(CupertinoIcons.heart),
              color: Colors.black,
              onPressed: () {},
            ),
            const SizedBox(width: 10.0),
            IconButton(
              icon: const Icon(CupertinoIcons.bubble_left_fill),
              color: Colors.black,
              onPressed: () {},
            ),
            const SizedBox(width: 10.0),
            IconButton(
              icon: const Icon(CupertinoIcons.share_solid),
              color: Colors.black,
              onPressed: () {},
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Text((docref as dynamic)['uname'],
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
          child: difference < 24
              ? Text("${difference.toString()} hours ago")
              : Text("${(difference / 24).toInt().toString()}d ago"),
        ),
      ],
    );
  }
}

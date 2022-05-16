// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_new

import 'package:clone/fire/fire.dart';
import 'package:clone/fire/provider.dart';
import 'package:clone/screens/Profilepage/editprofile.dart';
import 'package:clone/screens/Profilepage/postgrid.dart';
import 'package:clone/screens/Profilepage/profilestorytab.dart';
import 'package:clone/screens/upload.dart';
import 'package:clone/ui/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileStream extends ConsumerWidget {
  const ProfileStream({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) =>
      Container(child: buildStreamBuilder(ref));

  Widget buildStreamBuilder(ref) {
    final stream = ref.watch(streamProvider.stream);
    final currentuser = ref.read(userProvider);
    return StreamBuilder(
        stream: stream,
        builder: ((context, snapshot) {
          // print(snapshot);
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && !(snapshot.hasError)) {
              return Profile(
                data: snapshot.data as dynamic,
                userid: currentuser.uid,
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        }));
  }
}

showUploadpage(BuildContext context, String uploadType) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
            appBar: AppBar(), body: UploadPage(uploadType: uploadType)),
      ));
}

class Profile extends ConsumerWidget {
  var data;
  String userid;
  bool follow = false;

  Profile({required this.data, required this.userid, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final currentuser = ref.read(userProvider);
    // print(userid);
    return Column(
      children: [
        // top header
        Flexible(
          flex: 1,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data['uname'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            (userid == currentuser!.uid)
                ? Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          showModalBottomSheet(
                              useRootNavigator: true,
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: new Icon(Icons.photo),
                                      title: new Text('Post'),
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              body: UploadPage(
                                                  uploadType: 'post'),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.movie_filter),
                                      title: new Text('Reels'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.add_alert_outlined),
                                      title: Text('Story'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.add),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        onPressed: () async {
                          showModalBottomSheet(
                              useRootNavigator: true,
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: new Icon(Icons.settings),
                                      title: new Text('Settings'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(
                                          CupertinoIcons.heart_circle_fill),
                                      title: new Text('Close Friends'),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.logout),
                                      title: new Text('SignOut'),
                                      onTap: () async {
                                        await signOut();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.menu),
                      ),
                    ],
                  )
                : Container(),
          ]),
        ),
        Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // profile picture
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: CircleAvatar(
                    backgroundImage: ((data as dynamic)['profile'] != null &&
                            ((data as dynamic)['profile']).isNotEmpty)
                        ? NetworkImage(((data as dynamic)['profile']))
                        : null,
                    radius: 40,
                  ),
                ),
              ),
              // counts of following and followers
              Flexible(
                flex: 2,
                child: Container(
                  constraints: BoxConstraints(maxHeight: 100),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Counts(
                            title:
                                ((data as dynamic)['post']).length.toString(),
                            content: "Posts"),
                        Counts(
                            title: ((data as dynamic)['followers'])
                                .length
                                .toString(),
                            content: "Followers"),
                        Counts(
                            title: ((data as dynamic)['followings'])
                                .length
                                .toString(),
                            content: "Following"),
                      ]),
                ),
              ),
            ],
          ),
        ),
        // name and bio and buttons
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (data as dynamic)['name'] ?? "name",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    (data as dynamic)['bio'] ?? "bio",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // edit profile button
        (userid == currentuser.uid)
            ? Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ));
                    },
                    child: Text("Edit Profile"),
                  ),
                ),
              )
            : Button(
                uid: userid,
                follow: true,
              ),
        // profile story tabs
        Flexible(
          child: ProfileStoryTab(),
        ),
        // posts
        SizedBox(height: 20),
        Flexible(
          fit: FlexFit.tight,
          flex: 7,
          child: PostGrid(data: data),
        ),
      ],
    );
  }
}

class Counts extends StatelessWidget {
  String title;
  String content;
  Counts({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              content,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

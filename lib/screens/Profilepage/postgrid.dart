import 'package:clone/screens/Profilepage/zoomed.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class PostGrid extends StatelessWidget {
  var data;
  PostGrid({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List posts = (data as dynamic)['post'];
    return GridView.builder(
        itemCount: posts.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return PostGridTile(url: posts[index]['posturl']);
        });
  }
}

class PostGridTile extends StatelessWidget {
  String url;
  PostGridTile({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.width / 3,
        child: GestureDetector(
          // onLongPressDown: (details) {
          //   pushNewScreen(context, screen: Zoomed());
          //   print("zoomed down");
          // },
          // onLongPressCancel: () {
          //   print("hello");
          // },
          // onLongPressUp: () {
          //   Navigator.pop(context);
          //   print("zoomed up");
          // },
          child: FittedBox(
            child: Image.network(url),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}


/*
bio
closef
followers
followings
name
post
reels
tagged
uname
*/ 
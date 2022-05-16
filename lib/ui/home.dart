import 'package:clone/screens/HomePage/homefeeds.dart';
import 'package:clone/screens/SearchPage/search.dart';
import 'package:clone/screens/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:clone/screens/Profilepage/profile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late PersistentTabController _controller;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    super.initState();
  }

  final List<Widget> _screens = [
    HomeFeed(),
    // Text("hi"),
    SearchPage(),
    // Center(child: Text("reels")),
    UploadPage(
      uploadType: "post",
    ),
    const Center(child: Text("notification")),
    const SafeArea(child: ProfileStream()),
  ];

  final List<PersistentBottomNavBarItem> _navBarItems = [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: "Home",
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: "Search",
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.movie_filter),
      title: "Reels",
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.heart_fill),
      title: "Activity",
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.grey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.account_circle),
      title: "Profile",
      activeColorPrimary: Colors.black,
      inactiveColorPrimary: Colors.grey,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    print("this is homepage giys");
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _screens,
      items: _navBarItems,
    );
  }
}

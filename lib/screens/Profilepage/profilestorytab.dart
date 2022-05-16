import 'package:flutter/material.dart';

class ProfileStoryTab extends StatelessWidget {
  const ProfileStoryTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 30,
              child: Icon(Icons.wallet_travel),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30,
              child: Icon(Icons.headphones),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 30,
              child: Icon(Icons.airplanemode_active_rounded),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.yellow,
              radius: 30,
              child: Icon(Icons.wallet_travel),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 30,
              child: Icon(Icons.wallet_travel),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 30,
              // child: Icon(Icons.wallet_travel),
            ),
          ),
        ],
      ),
    );
  }
}

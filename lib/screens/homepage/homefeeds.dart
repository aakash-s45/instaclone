import 'package:clone/screens/upload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clone/screens/homepage/posttile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clone/fire/provider.dart';

class HomeFeed extends ConsumerWidget {
  HomeFeed({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final mystream = ref.watch(streamProvider2.stream);
    return SafeArea(
      child: StreamBuilder(
        stream: mystream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && !(snapshot.hasError)) {
              List followings = (snapshot.data as dynamic)['followings'];
              return Column(
                children: [
                  // Image.asset('assets/images/instagram.png'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 5),
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Image.asset('assets/images/insta2.png')),
                        ),
                      ),
                      Flexible(
                        child: IconButton(
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
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Scaffold(
                                                body: UploadPage(
                                                    uploadType: 'reels'),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.add_alert_outlined),
                                        title: Text('Story'),
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Scaffold(
                                                body: UploadPage(
                                                    uploadType: 'story'),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            child: Row(children: [
                              Flexible(
                                  child: CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                    (snapshot.data as dynamic)['profile']),
                              )),
                              const Flexible(
                                child: CircleAvatar(
                                  backgroundColor: Colors.yellow,
                                  radius: 70,
                                  child: Icon(
                                    Icons.travel_explore_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              const Flexible(
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 70,
                                  child: Icon(Icons.place),
                                ),
                              ),
                              const Flexible(
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.cake),
                                  radius: 70,
                                ),
                              ),
                              const Flexible(
                                child: CircleAvatar(
                                  radius: 70,
                                  child: Icon(Icons.media_bluetooth_off),
                                ),
                              ),
                            ]),
                          ),
                          Divider(color: Colors.black.withOpacity(.3)),
                          Column(
                            children: followings.map((docid) {
                              final doc = ref.watch(searchAsyncProvider(docid));
                              return Container(
                                child: doc.when(
                                    data: (data) => Column(
                                          children: (data)['post']
                                              .map<Widget>((postObj) {
                                            return PostTile(
                                                docref: data, postObj: postObj);
                                          }).toList(),
                                        ),
                                    error: (e, stk) => const Center(
                                        child: CircularProgressIndicator()),
                                    loading: () => const Center(
                                        child: CircularProgressIndicator())),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

import 'package:clone/fire/provider.dart';
import 'package:clone/screens/Profilepage/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List docids = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (context, ref, child) {
          TextEditingController searchController =
              ref.watch(searchControllerProvider);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: "Search by username",
                    hintText: "Enter the username",
                    suffixIcon: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        String text = ref.read(searchControllerProvider).text;
                        await FirebaseFirestore.instance
                            .collection('users')
                            .where('uname', isEqualTo: text)
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          querySnapshot.docs.forEach((doc) {
                            docids.add(doc.id);
                            setState(() {});
                          });
                        });
                        print("Search user");
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: docids.length,
                  itemBuilder: (context, index) {
                    return SearchTile(docid: docids[index]);
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class SearchTile extends ConsumerWidget {
  String docid;
  SearchTile({required this.docid, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final userdoc = ref.watch(searchAsyncProvider(docid));

    return userdoc.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, stk) => Text("$e.toString"),
      data: (data) => ListTile(
        leading: ((data as dynamic)['profile'].isNotEmpty)
            ? Image.network((data as dynamic)['profile'])
            : const Icon(Icons.query_builder),
        title: Text((data as dynamic)['uname']),
        onTap: () {
          pushNewScreen(context,
              screen: Material(
                  child: SafeArea(
                      child: Profile(
                data: data,
                userid: docid,
              ))));
        },
      ),
    );
  }
}

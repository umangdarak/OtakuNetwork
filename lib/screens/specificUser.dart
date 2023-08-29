import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:otaku_connect/resources/firestore_methods.dart';
import 'package:otaku_connect/utils/getpoststring.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key, required this.snap});
  final snap;
  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  late DocumentSnapshot<Map<String, dynamic>> l;
  List<String> l1 = [];
  int nakama = 0;
  int nakamanetwork = 0;
  bool c = false;
  bool load = true;
  getListofStrings() async {
    l = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['uid'])
        .get();
    List<String> l2 = [];
    for (int i = 0; i < l['postids'].length; i++) {
      l2.add(l['postids'][i]);
      l2.toSet();
    }
    l1 = l2.toList();
    print(l1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListofStrings();
    setState(() {
      load = false;
    });
    if (widget.snap['nakama']
        .contains(FirebaseAuth.instance.currentUser!.uid)) {
      setState(() {
        c = true;
      });
    } else {
      setState(() {
        c = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getListofStrings();
    nakama = widget.snap['nakama'].length;
    nakamanetwork = widget.snap['nakama-network'].length;
    return load
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.snap['username']),
              centerTitle: true,
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.snap['photourl']),
                      radius: 50,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                Text('Posts:', style: TextStyle(fontSize: 22)),
                                Text('${widget.snap['postids'].length}',
                                    style: TextStyle(fontSize: 18))
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Text('Nakama:', style: TextStyle(fontSize: 22)),
                                Text('${nakama}',
                                    style: TextStyle(fontSize: 18))
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Text('Network:',
                                    style: TextStyle(fontSize: 22)),
                                Text('${nakamanetwork}',
                                    style: TextStyle(fontSize: 18))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!widget.snap['nakama'].contains(
                                    FirebaseAuth.instance.currentUser!.uid)) {
                                  nakama++;
                                  c = true;
                                } else {
                                  nakama--;
                                  c = false;
                                }
                                ;
                              });
                              FirestoreMethods().followUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  widget.snap['uid']);
                            },
                            child: Container(
                              width: 150,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                  child: c
                                      ? Text('Become my Nakama!!')
                                      : Text('Nakama!!')),
                            ))
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
              ),
              Expanded(
                child: MasonryGridView.count(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  crossAxisCount: 3,
                  itemCount: l1.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(l1[index])
                          .get(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                            height: 150,
                            width: 150,
                            child: Image.network(snapshot.data!['posturl']));
                      },
                    );
                  },
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
              )
            ]),
          );
  }
}

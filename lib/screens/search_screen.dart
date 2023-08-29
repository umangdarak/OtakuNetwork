import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otaku_connect/screens/specificUser.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool users = false;
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
          bottomOpacity: 0,
          title: TextField(
            controller: _textController,
            decoration: InputDecoration(
                hintText: "Search a user", border: InputBorder.none),
            onChanged: (String _) {
              setState(() {
                users = true;
              });
            },
          ),
        ),
        body: users
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: _textController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: (snapshot.data as dynamic).docs.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SearchUser(
                                        snap: (snapshot.data! as dynamic)
                                            .docs[index])));
                          },
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['photourl']),
                              ),
                              title: Text((snapshot.data! as dynamic)
                                  .docs[index]['username'])),
                        );
                      });
                },
              )
            : Container());
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otaku_connect/models/user.dart';
import 'package:otaku_connect/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'commentscard.dart';

class CommentsScreen extends StatefulWidget {
  final postid;
  const CommentsScreen({super.key, required this.postid});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _textFieldController = TextEditingController();

  void uploadComment(String uid, String username, String profilepic) async {
    try {
      String res = await FirestoreMethods().addComment(
          uid, widget.postid, _textFieldController.text, username, profilepic);
      if (res != 'Success') {
        if (context.mounted) {
          setState(() {
            _textFieldController.text = '';
          });
        }
      }
    } catch (ress) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    User user;
    try {
      final UserProvider userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
    } catch (err) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postid)
              .collection('comments')
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return CommentCard(
                      snap: snapshot.data!.docs[index], id: widget.postid);
                });
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.only(left: 12, right: 8),
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photourl),
              radius: 20,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8),
                child: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Comment as ${user.username}'),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                uploadComment(user.uid, user.username, user.photourl);
              },
              child: Text(
                'Post',
                style: TextStyle(color: Colors.blue),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

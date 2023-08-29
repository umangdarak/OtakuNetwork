import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otaku_connect/screens/postfeed.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'animation.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool c = false;
  @override
  Widget build(BuildContext context) {
    User user;
    try {
      final UserProvider userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
    } catch (err) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.photourl),
                  maxRadius: 20,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'OtakuConnect',
                    style: TextStyle(
                      fontFamily: 'caveat',
                      fontSize: 30,
                    ),
                  ),
                  Container(
                      width: 50,
                      height: 50,
                      child: Image.asset('assets/images/crewlogo.png'))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          c = !c;
                        });
                      },
                      child: AnimationFeed(
                        smallLike: true,
                        isAnimating: c,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                            width: 35,
                            height: 40,
                            child: Image.asset(
                                'assets/images/dragonballfilled.png')),
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                      child: Image.asset(
                    'assets/images/konoha.png',
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  )),
                  const SizedBox(
                    width: 2,
                  )
                ],
              )
            ],
          ),
          const Divider(
            thickness: 1,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: ((context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) =>
                        PostFeed(snap: snapshot.data!.docs[index])),
              );
            }),
          )
        ]),
      ),
    );
  }
}

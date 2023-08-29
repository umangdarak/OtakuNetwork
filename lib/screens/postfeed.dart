import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:otaku_connect/resources/firestore_methods.dart';
import 'package:otaku_connect/screens/comments.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import 'animation.dart';

class PostFeed extends StatefulWidget {
  final snap;
  const PostFeed({super.key, required this.snap});

  @override
  State<PostFeed> createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  bool isAnimation = false;
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
    return Container(
        color: ThemeData.dark().scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12).copyWith(right: 1),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.snap['profimage']),
                    // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTsCTUpRqVFXIMyMSyH_fBdYOnKqjXHsJOY5g&usqp=CAU'),
                    radius: 20,
                  ),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.snap['username'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ))),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    content: TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    FirestoreMethods().DeletePost(
                                        widget.snap['postid'],
                                        widget.snap['uid']);
                                    Navigator.pop(context);
                                  },
                                ))); // ListView
                      },
                      icon: Icon(Icons.more_vert)),
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().updateLikes(widget.snap['uid'],
                    widget.snap['postid'], widget.snap['likes']);
                setState(() {
                  isAnimation = true;
                });
              },
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      child: Image.network(
                        widget.snap['posturl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: isAnimation ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: AnimationFeed(
                        onEnd: () {
                          setState(() {
                            isAnimation = false;
                          });
                        },
                        isAnimating: isAnimation,
                        duration: Duration(milliseconds: 400),
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.4), BlendMode.dstIn),
                            child: Image.asset(
                              'assets/images/dragonballfilled.png',
                              width: 120,
                              height: 120,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimationFeed(
                    isAnimating: widget.snap['likes'].contains(user.uid),
                    smallLike: true,
                    child: GestureDetector(
                        onTap: () async {
                          await FirestoreMethods().updateLikes(
                              widget.snap['uid'],
                              widget.snap['postid'],
                              widget.snap['likes']);
                        },
                        child: Container(
                            width: 35,
                            height: 40,
                            child: Image.asset(
                                'assets/images/dragonballfilled.png'))),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CommentsScreen(
                                    postid: widget.snap['postid'])));
                      },
                      icon: Icon(FontAwesomeIcons.comment)),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.share))
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w800),
                          child: Text(
                            '${widget.snap['likes'].length} likes',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text: widget.snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '  ${widget.snap['description']}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              'View all  comments',
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                          onTap: () {}),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text('abc'))
                    ])),
          ],
        ));
  }
}

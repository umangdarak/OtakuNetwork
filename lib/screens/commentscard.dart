import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:otaku_connect/resources/firestore_methods.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final id;
  const CommentCard({super.key, required this.snap, required this.id});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool c = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap.data()['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        '${widget.snap.data()['name']}:  ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.snap.data()['comment'])
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap.data()['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FirestoreMethods()
                  .deletecomment(widget.snap.data()['commentId'], widget.id);
            },
            child: Icon(Icons.delete),
          ),
          GestureDetector(
            onTap: () {
              c = !c;
            },
            child: Container(
                padding: const EdgeInsets.all(8),
                child: c
                    ? Icon(
                        FontAwesomeIcons.heart,
                        size: 16,
                      )
                    : Icon(
                        FontAwesomeIcons.solidHeart,
                        size: 16,
                        color: Colors.red,
                      )),
          )
        ],
      ),
    );
  }
}

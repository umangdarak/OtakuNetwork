import 'package:cloud_firestore/cloud_firestore.dart';

class Posts {
  final String description;
  final String uid;
  final String postid;
  final String username;
  final datepublished;
  final String posturl;
  final String profimage;
  final sparkle;
  Posts(
      {required this.description,
      required this.uid,
      required this.postid,
      required this.username,
      required this.datepublished,
      required this.posturl,
      required this.profimage,
      required this.sparkle});
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "postid": postid,
        "posturl": posturl,
        "datepublished": datepublished,
        "profimage": profimage,
        "description": description,
        "likes": sparkle
      };

  static Posts fromSnap(DocumentSnapshot snap) {
    var snapshot =
        snap.data() as Map<String, dynamic>?; // Note the ? for null safety
    if (snapshot == null) {
      // Handle null snapshot
      return Posts.empty(); // Replace with appropriate default or empty user
    }

    return Posts(
        description: snapshot['description'] ?? '',
        uid: snapshot['uid'] ?? '',
        postid: snapshot['postid'] ?? '',
        username: snapshot['username'] ?? '',
        posturl: snapshot['posturl'] ?? '',
        profimage: snapshot['profimage'] ?? '',
        sparkle: snapshot['sparkle'] ?? [],
        datepublished: snapshot['datepublished'] ?? '');
  }

  static Posts empty() {
    return Posts(
        description: '',
        uid: '',
        postid: '',
        username: '',
        posturl: '',
        profimage: '',
        sparkle: [],
        datepublished: '');
  }
}

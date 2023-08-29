import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photourl;
  final String username;
  final String bio;
  final List nakama;
  final List nakama_network;
  final List postids;
  User(
      {required this.email,
      required this.uid,
      required this.photourl,
      required this.username,
      required this.bio,
      required this.nakama,
      required this.nakama_network,
      required this.postids});
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photourl": photourl,
        "bio": bio,
        "nakama": nakama,
        "nakama-network": nakama_network,
        "postids": postids,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot =
        snap.data() as Map<String, dynamic>?; // Note the ? for null safety
    if (snapshot == null) {
      // Handle null snapshot
      return User.empty(); // Replace with appropriate default or empty user
    }

    return User(
        email: snapshot['email'] ?? '',
        uid: snapshot['uid'] ?? '',
        photourl: snapshot['photourl'] ?? '',
        username: snapshot['username'] ?? '',
        bio: snapshot['bio'] ?? '',
        nakama: snapshot['nakama'] ?? [],
        nakama_network: snapshot['nakama_network'] ?? [],
        postids: snapshot['postids'] ?? []);
  }

  static User empty() {
    return User(
        email: '',
        uid: '',
        photourl: '',
        username: '',
        bio: '',
        nakama: [],
        nakama_network: [],
        postids: []);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class getString1 {
  Future<String> get(String index) async {
    var postid =
        await FirebaseFirestore.instance.collection('posts').doc(index).get();
    String s = postid.data()!['posturl'];
    return s;
  }
}

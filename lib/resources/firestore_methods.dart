import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:otaku_connect/models/posts.dart';
import 'package:otaku_connect/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadImage(String username, String description,
      Uint8List file, String uid, String profimage) async {
    String res = 'error';
    try {
      String photourl =
          await StorageMeth().uploadToStorage('posts', file, true);
      String postid = Uuid().v1();
      Posts post = Posts(
          description: description,
          uid: uid,
          postid: postid,
          username: username,
          datepublished: DateTime.now(),
          posturl: photourl,
          profimage: profimage,
          sparkle: []);
      _firestore.collection('posts').doc(postid).set(post.toJson());
      res = 'Success';
      _firestore.collection('users').doc(uid).update({
        'postids': FieldValue.arrayUnion([postid])
      });
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addComment(String uid, String postId, String comment,
      String username, String profilepic) async {
    String res = 'error';
    try {
      if (comment.isNotEmpty) {
        String commentid = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentid)
            .set({
          'profilePic': profilepic,
          'name': username,
          'uid': uid,
          'comment': comment,
          'commentId': commentid,
          'datePublished': DateTime.now(),
        });
        res = 'Success';
      }
    } catch (ress) {
      res = ress.toString();
    }
    return res;
  }

  Future<String> deletecomment(String commentid, String postid) async {
    String res = 'error';
    try {
      await _firestore
          .collection('posts')
          .doc(postid)
          .collection('comments')
          .doc(commentid)
          .delete();
      res = 'Success';
    } catch (err) {
      res = 'Error';
    }
    return res;
  }

  Future<String> DeletePost(String postid, String uid) async {
    String res = 'error';
    try {
      await _firestore.collection('posts').doc(postid).delete();
      await _firestore.collection('posts').doc(uid).update({
        'likes': FieldValue.arrayRemove([postid])
      });
    } catch (err) {
      res = 'Error';
    }
    return res;
  }

  Future<void> updateLikes(String uid, String postId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {}
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['nakama-network'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'nakama': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'nakama-network': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'nakama': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'nakama-network': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

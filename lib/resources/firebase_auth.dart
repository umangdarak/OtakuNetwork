// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:otaku_connect/models/user.dart' as model;
import 'package:otaku_connect/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> UserDetails() async {
    DocumentSnapshot? s;
    try {
      User? currentUser = await _firebaseAuth.currentUser;
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(currentUser!.uid).get();
      s = snap;
      return model.User.fromSnap(snap);
    } catch (err) {}
    return model.User.fromSnap(s!);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'error';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential uc = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String profilepic =
            await StorageMeth().uploadToStorage('ProfilePics', file, false);

        model.User user = model.User(
            email: email,
            username: username,
            uid: uc.user!.uid,
            bio: bio,
            nakama: [],
            nakama_network: [],
            photourl: profilepic,
            postids: []);
        _firestore.collection('users').doc(uc.user!.uid).set(user.toJson());
        res = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      res = err.code.toString();
    } catch (err) {
      res = err.toString();
      //  print(res);
    }
    return res;
  }

  Future<String> loginuser(
      {required String email, required String password}) async {
    String res = 'Error';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      res = err.code.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

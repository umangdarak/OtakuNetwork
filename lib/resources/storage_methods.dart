import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
//import 'package:flutter/material.dart';

class StorageMeth {
  final FirebaseStorage fire = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> uploadToStorage(
      String childname, Uint8List file, bool ispost) async {
    final downloadurl;
    Reference ref;
    if (ispost) {
      String id = Uuid().v1();
      ref = fire
          .ref()
          .child(childname)
          .child(auth.currentUser!.uid)
          .child('${id}.jpg');
    } else {
      //uploading reference to the storage file name childname subfile name is the uid
      ref = fire.ref().child(childname).child(auth.currentUser!.uid);
    }
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');

    // Upload the image with the specified metadata
    UploadTask uploadTask = ref.putData(file, metadata);
    //Task snapshot of current user
    TaskSnapshot snap = await uploadTask;
    downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }
}

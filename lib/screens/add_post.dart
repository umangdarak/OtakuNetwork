import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otaku_connect/models/user.dart';
import 'package:otaku_connect/resources/firestore_methods.dart';
import 'package:otaku_connect/utils/imageselection.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  _UploadImage(String uid, String username, String profimage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadImage(
          username, _descriptionController.text, file!, uid, profimage);
      if (res == 'Success') {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text(res)),
            backgroundColor: ThemeData.dark().scaffoldBackgroundColor));
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text(res)),
            backgroundColor: ThemeData.dark().scaffoldBackgroundColor));
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text(err.toString())),
          backgroundColor: ThemeData.dark().scaffoldBackgroundColor));
    }
    file = null;
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Create a Post!'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file1 = await pickImage(ImageSource.camera);
                  setState(() {
                    file = file1;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Select From Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file1 = await pickImage(ImageSource.gallery);
                  setState(() {
                    file = file1;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      file = null;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    User user = userProvider.user;
    return file == null
        ? Center(
            child: IconButton(
              icon: Icon(FontAwesomeIcons.upload),
              onPressed: () {
                _selectImage(context);
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back), onPressed: () => clearImage()),
              backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
              title: Text('Add a Post'),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: () =>
                      _UploadImage(user.uid, user.username, user.photourl),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isLoading
                    ? LinearProgressIndicator()
                    : Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 70,
                        width: 70,
                        child: CircleAvatar(
                            backgroundImage: NetworkImage(user.photourl))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset.topCenter,
                                  image: MemoryImage(file!)))),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}

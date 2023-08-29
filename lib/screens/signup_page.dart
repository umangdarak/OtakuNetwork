import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otaku_connect/resources/firebase_auth.dart';
import 'package:otaku_connect/utils/imageselection.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _usernameController = new TextEditingController();
  final _bioController = new TextEditingController();
  bool _isloading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void a() {
    setState(() {
      _isloading = false;
    });
  }

  void signupUser() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: image!);
    a();
    if (res != 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Center(child: Text(res)),
          backgroundColor: ThemeData.dark().scaffoldBackgroundColor));
      Navigator.pop(context);
    }
  }

  Uint8List? image;

  void selectImage() async {
    Uint8List i = await pickImage(ImageSource.gallery);
    setState(() {
      image = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4 - 100,
            ),
            Stack(children: [
              image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(image!),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage('assets/images/grey.jpg'),
                    ),
              Positioned(
                bottom: -10,
                top: 80,
                child: IconButton(
                  onPressed: () {
                    selectImage();
                  },
                  icon: Icon(FontAwesomeIcons.image),
                ),
              )
            ]),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Enter your Email'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password'),
              ),
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Enter your Username'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Enter your Bio'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                signupUser();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: _isloading
                    ? Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      ))
                    : Center(
                        child: Text(
                        'Sign In',
                        style: TextStyle(fontSize: 20),
                      )),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

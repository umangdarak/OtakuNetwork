import 'package:flutter/material.dart';
import 'package:otaku_connect/resources/firebase_auth.dart';

class SignOut extends StatefulWidget {
  const SignOut({super.key});

  @override
  State<SignOut> createState() => _SignOutState();
}

class _SignOutState extends State<SignOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        child: Text('Signout'),
        onPressed: () {
          AuthMethods().signOut();
        },
      )),
    );
  }
}

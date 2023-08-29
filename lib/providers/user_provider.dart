import 'package:flutter/material.dart';
import 'package:otaku_connect/resources/firebase_auth.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get user => _user!;

  Future<void> fetchUserDetails() async {
    _user = await _authMethods.UserDetails();
    print(_user!.email);
    // Check if _user is not null before calling notifyListeners()
    if (_user != null) {
      notifyListeners();
    }
  }
}

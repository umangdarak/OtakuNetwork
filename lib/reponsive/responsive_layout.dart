import 'package:flutter/material.dart';
import 'package:otaku_connect/providers/user_provider.dart';
import 'package:otaku_connect/reponsive/dimension.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ResponsiveLayout extends StatefulWidget {
  Widget MobileLayout;
  Widget WebLayout;
  ResponsiveLayout(
      {super.key, required this.MobileLayout, required this.WebLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth > webscreensize) {
        return widget.WebLayout;
      }
      return widget.MobileLayout;
    }));
  }
}

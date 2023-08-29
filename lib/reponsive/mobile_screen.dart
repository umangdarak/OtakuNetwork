import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otaku_connect/screens/add_post.dart';

import '../screens/feed.dart';
import '../screens/search_screen.dart';
import '../screens/signout.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({super.key});

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  DividerThemeData d = const DividerThemeData();
  int _page = 0;
  late PageController _pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        children: const [Feed(), Search(), AddPost(), SignOut()],
      ),
      bottomNavigationBar: CupertinoTabBar(
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
        backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 3 ? Colors.white : Colors.grey,
              ),
              label: '',
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}

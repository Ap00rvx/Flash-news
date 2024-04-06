import 'package:bottom_nav_bar/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_project/Features/Chat/Screens/chatpage.dart';
import 'package:news_project/main.dart';
import 'package:news_project/Features/HomePage/Provider/news_provider.dart';
import 'package:news_project/Features/Boomarks/Screens/BookMarks.dart';
import 'package:news_project/Features/HomePage/Screens/homepage.dart';
import 'package:news_project/Features/Profile/profilepage.dart';
import 'package:news_project/Features/LoginPage/Screens/startpage.dart';
import 'package:provider/provider.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

class RootPage extends StatefulWidget {
  const RootPage({
    Key? key,
  }) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: _body(),
          bottomNavigationBar: _bottomNavBar(),
        );
      },
    );
  }

  Widget _body() => SizedBox.expand(
        child: IndexedStack(
          index: _currentIndex,
          children: const <Widget>[
            Body(),
            BookMarks(),
            Chatpage(),
            ProfilePage()
          ],
        ),
      );

  Widget _bottomNavBar() => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GNav(
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() => _currentIndex = index);
              setState(() {});
            },
            gap: 6,
            activeColor: Colors.orange,
            backgroundColor: Colors.white,
            // tabBackgroundColor: Colors.orange.shade100,
            color: Colors.black,
            tabs: [
              GButton(text: 'Home', icon: Icons.home),
              GButton(text: 'Bookmark', icon: Icons.bookmark),
              GButton(text: 'Message', icon: Icons.chat_bubble),
              GButton(text: 'Profile', icon: Icons.person),
            ],
          ),
        ),
      );
}

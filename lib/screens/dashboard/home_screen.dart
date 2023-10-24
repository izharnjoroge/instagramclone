import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/screens/landing/landing_page.dart';
import 'package:instagramclone/screens/post/post_story.dart';
import 'package:instagramclone/screens/profile/profile_page.dart';
import 'package:instagramclone/screens/search/search_stuff.dart';
import 'package:instagramclone/screens/stories/stories_page.dart';
import 'package:instagramclone/utils/colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigateToPage(int page) {
    setState(() {
      _page = page;
    });
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            _page = value;
          });
        },
        children: [
          const LandingPage(),
          const SearchPage(),
          const AddPost(),
          const StoriesPage(),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          )
        ],
      ),
      bottomNavigationBar:
          CupertinoTabBar(onTap: navigateToPage, currentIndex: _page, items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: 'Home',
            backgroundColor: mobileBackgroundColor),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search_off,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            label: 'search',
            backgroundColor: mobileBackgroundColor),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add_a_photo,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: 'post',
            backgroundColor: mobileBackgroundColor),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            label: 'followers',
            backgroundColor: mobileBackgroundColor),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person_3_outlined,
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            label: 'profile',
            backgroundColor: mobileBackgroundColor),
      ]),
    );
  }
}

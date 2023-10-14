import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/models/user_model.dart';
import 'package:instagramclone/providers/user_name_provider.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late UserModel userData;
  int _page = 0;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    UserModel user = context.watch<UserNameProvider>().getUser;
    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('${userData.userName}'),
      ),
      body: const Center(),
      bottomNavigationBar: CupertinoTabBar(items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: 'Home',
            backgroundColor: mobileBackgroundColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.search_off),
            label: 'search',
            backgroundColor: mobileBackgroundColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            label: 'post',
            backgroundColor: mobileBackgroundColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'folloers',
            backgroundColor: mobileBackgroundColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_3_outlined),
            label: 'profile',
            backgroundColor: mobileBackgroundColor),
      ]),
    );
  }
}

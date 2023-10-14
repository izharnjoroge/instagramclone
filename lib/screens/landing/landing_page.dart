import 'package:flutter/material.dart';
import 'package:instagramclone/models/user_model.dart';
import 'package:provider/provider.dart';

import '../../providers/user_name_provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late UserModel userData;
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
        title: Text(userData.userName),
      ),
    );
  }
}

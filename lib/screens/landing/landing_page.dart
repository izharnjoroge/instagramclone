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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<UserNameProvider>().getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(" Hello   ${user?.userName}" ?? 'Welcome '),
      ),
    );
  }
}

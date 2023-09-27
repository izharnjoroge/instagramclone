import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:instagramclone/screens/signup_screen.dart';
import 'package:instagramclone/screens/login_screen.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(20),
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: Colors.blue,
            height: 64,
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const LoginScreen());
                  },
                  child: const Text('Log In'),
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const SignUp());
                  },
                  child: const Text('Create an Account'),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}

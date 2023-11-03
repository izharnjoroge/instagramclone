import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:instagramclone/screens/auth/login_screen.dart';
import 'package:instagramclone/screens/auth/signup_screen.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Gap(250),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: Colors.black,
                    height: 64,
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * .05,
                        width: size.width - 100,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => const LoginScreen());
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  const Text(
                    'Switch Accounts',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Divider(
                      thickness: 2.0,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const SignUp());
                    },
                    child: RichText(
                        selectionColor: Colors.grey,
                        text: const TextSpan(children: [
                          TextSpan(
                              text: 'Dont have an account?  ',
                              style: TextStyle(color: Colors.blue)),
                          TextSpan(
                              text: ' Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                              ))
                        ])),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

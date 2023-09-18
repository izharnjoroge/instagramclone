import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:instagramclone/screens/login_screen.dart';
import 'package:instagramclone/utils/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    if (!value.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(20),
              // SvgPicture.asset(
              //   'assets/ic_instagram.png',
              //   color: Colors.blue,
              //   height: 64,
              // ),
              const Gap(20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                  hintText: 'Enter your User Name',
                ),
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please enter valid Name";
                  }
                  return null;
                },
              ),
              const Gap(20),
              TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val) {
                    validateEmail(_emailController.text);
                    return null;
                  }),
              const Gap(20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Enter your Bio',
                ),
                keyboardType: TextInputType.name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please enter valid Bio";
                  }
                  return null;
                },
              ),
              const Gap(20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (val) {
                  validatePassword(_passwordController.text);
                  return null;
                },
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * .2,
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        if (Form.of(context).validate()) {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          final name = _nameController.text;
                          final bio = _bioController.text;
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
              RichText(
                text: TextSpan(
                    style: const TextStyle(
                      color: textColor,
                    ),
                    children: [
                      const TextSpan(text: "Already have an account ?"),
                      TextSpan(
                          text: "Log In",
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => const LoginScreen());
                            })
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

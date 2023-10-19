import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:instagramclone/auth/auth.dart';
import 'package:instagramclone/models/user_model.dart';
import 'package:instagramclone/providers/user_name_provider.dart';
import 'package:instagramclone/screens/auth/signup_screen.dart';
import 'package:instagramclone/screens/dashboard/home_screen.dart';

import 'package:instagramclone/utils/colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  final Auth _auth = Auth();
  bool _isPasswordVisible = false;
  String responce = '';
  bool isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
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

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            : Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Gap(20),
                          SvgPicture.asset(
                            'assets/ic_instagram.svg',
                            color: Colors.blue,
                            height: 64,
                          ),
                          const Gap(20),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) {
                              validateEmail(_emailController.text);
                              return null;
                            },
                          ),
                          const Gap(20),
                          TextFormField(
                            controller: _passwordController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !_isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: _togglePasswordVisibility,
                              ),
                            ),
                            obscureText: _isPasswordVisible,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                height: size.height * .05,
                                width: 100,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    isLoading = true;

                                    if (_emailController.text.isEmpty ||
                                        _passwordController.text.isEmpty) {
                                      Get.snackbar(
                                          "Error", "Please fill all the fields",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          isDismissible: true,
                                          duration: const Duration(seconds: 3));
                                      isLoading = false;
                                    } else if (!_loginFormKey.currentState!
                                        .validate()) {
                                      Get.snackbar(
                                          "Error", "Please fill all the fields",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          isDismissible: true,
                                          duration: const Duration(seconds: 3));
                                      isLoading = false;
                                    } else {
                                      final email = _emailController.text;
                                      final password = _passwordController.text;
                                      responce =
                                          await Auth().logIn(email, password);

                                      if (responce == 'Success') {
                                        isLoading = false;
                                        Get.snackbar(responce, '',
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                            isDismissible: true,
                                            duration:
                                                const Duration(seconds: 3));
                                        UserModel user =
                                            await _auth.getUserData();

                                        context
                                            .read<UserNameProvider>()
                                            .isUser = user;
                                        Get.offAll(() => const MyHomePage());
                                      } else {
                                        isLoading = false;
                                        Get.snackbar(responce, '',
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            snackPosition: SnackPosition.BOTTOM,
                                            isDismissible: true,
                                            duration:
                                                const Duration(seconds: 3));
                                        Get.back();
                                      }
                                    }
                                  },
                                  child: const Text('Continue'),
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),
                          RichText(
                            text: TextSpan(
                                style: const TextStyle(
                                  color: textColor,
                                ),
                                children: [
                                  const TextSpan(
                                      text: "Dont have an account ?"),
                                  TextSpan(
                                      text: "Sign Up",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.to(() => const SignUp());
                                        })
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

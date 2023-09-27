import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:instagramclone/auth/auth.dart';
import 'package:instagramclone/screens/home_screen.dart';
import 'package:instagramclone/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: isLoading
            ? SizedBox(
                height: size.height * .2,
                width: 100,
                child: const CircularProgressIndicator(
                  color: Colors.blue,
                ),
              )
            : Container(
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              } else if ((!Form.of(context).validate())) {
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
                                responce = await Auth().logIn(email, password);

                                isLoading = false;
                                isLoading = false;
                                if (responce == 'Success') {
                                  Get.snackbar(responce, '',
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      isDismissible: true,
                                      duration: const Duration(seconds: 3));
                                  Get.to(() => MyHomePage(
                                        title: responce,
                                      ));
                                } else {
                                  Get.snackbar(responce, '',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                      isDismissible: true,
                                      duration: const Duration(seconds: 3));
                                }
                              }
                            },
                            child: const Text('Continue'),
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
                            const TextSpan(text: "Dont have an account ?"),
                            TextSpan(
                                text: "Sign Up",
                                style: const TextStyle(
                                    color: blueColor,
                                    fontWeight: FontWeight.bold),
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

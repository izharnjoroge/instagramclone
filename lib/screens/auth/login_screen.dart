import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:instagramclone/auth/auth.dart';
import 'package:instagramclone/models/user_model.dart';
import 'package:instagramclone/providers/user_name_provider.dart';
import 'package:instagramclone/screens/auth/signup_screen.dart';
import 'package:instagramclone/screens/dashboard/home_screen.dart';
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
            : SingleChildScrollView(
                child: Form(
                  key: _loginFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        const Gap(100),
                        SvgPicture.asset(
                          'assets/ic_instagram.svg',
                          color: Colors.black,
                          height: 64,
                        ),
                        const Gap(20),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Colors.black,
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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Gap(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * .05,
                              width: size.width - 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  if (_emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty) {
                                    Get.snackbar(
                                        "Error", "Please fill all the fields",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                        isDismissible: true,
                                        duration: const Duration(seconds: 3));
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else if (!_loginFormKey.currentState!
                                      .validate()) {
                                    Get.snackbar(
                                        "Error", "Please fill all the fields",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                        isDismissible: true,
                                        duration: const Duration(seconds: 3));
                                    setState(() {
                                      isLoading = false;
                                    });
                                  } else {
                                    final email = _emailController.text;
                                    final password = _passwordController.text;
                                    responce =
                                        await Auth().logIn(email, password);

                                    if (responce == 'Success') {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      UserModel user =
                                          await _auth.getUserData();
                                      context.read<UserNameProvider>().isUser =
                                          user;
                                      Get.snackbar(responce, '',
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          isDismissible: true,
                                          duration: const Duration(seconds: 3));

                                      Get.offAll(() => const MyHomePage());
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Get.snackbar(responce, '',
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          isDismissible: true,
                                          duration: const Duration(seconds: 3));
                                      Get.back();
                                    }
                                  }
                                },
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                      )
                                    : const Text('Continue'),
                              ),
                            ),
                          ],
                        ),
                        const Gap(50),
                        SizedBox(
                          height: size.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Log In With Facebook',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'OR',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
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
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: 'Sign Up',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 105, 103, 103),
                                          ))
                                    ])),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

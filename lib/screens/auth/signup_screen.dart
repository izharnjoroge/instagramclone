import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/auth/auth.dart';
import 'package:instagramclone/screens/auth/login_screen.dart';
import 'package:instagramclone/screens/dashboard/home_screen.dart';

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
  final _signUpFormKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _pickedFile;
  String responce = '';
  bool isLoading = false;
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

  void _getImageFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List photo = await pickedFile.readAsBytes();
      setState(() {
        _pickedFile = photo;
      });
    }
  }

  void _takePhoto() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      Uint8List photo = await pickedFile.readAsBytes();
      setState(() {
        _pickedFile = photo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Form(
              key: _signUpFormKey,
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
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey,
                        backgroundImage: _pickedFile != null
                            ? MemoryImage(_pickedFile!)
                            : null,
                        child: _pickedFile == null
                            ? const Icon(
                                Icons.person_outline,
                                size: 60,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.file_upload),
                          onPressed: _getImageFromGallery,
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: IconButton(
                          icon: const Icon(Icons.camera),
                          onPressed: _takePhoto,
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  TextFormField(
                    controller: _nameController,
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
                    controller: _bioController,
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
                  isLoading
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
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * .05,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  isLoading = true;

                                  if (_emailController.text.isEmpty ||
                                      _passwordController.text.isEmpty ||
                                      _nameController.text.isEmpty ||
                                      _bioController.text.isEmpty) {
                                    Get.snackbar(
                                        "Error", "Please fill all the fields",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                        isDismissible: true,
                                        duration: const Duration(seconds: 3));
                                    isLoading = false;
                                  } else if ((!_signUpFormKey.currentState!
                                      .validate())) {
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
                                    final name = _nameController.text;
                                    final bio = _bioController.text;
                                    final image = _pickedFile;

                                    responce = await Auth().signUp(
                                        email, password, name, bio, image);

                                    isLoading = false;
                                    if (responce == 'Welcome') {
                                      Get.snackbar(responce, '',
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                          isDismissible: true,
                                          duration: const Duration(seconds: 3));
                                      Get.offAll(() => const MyHomePage());
                                    } else {
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
                                child: const Text('Sign Up'),
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
                          const TextSpan(text: "Already have an account ?"),
                          TextSpan(
                              text: "Log In",
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
        ),
      ),
    );
  }
}

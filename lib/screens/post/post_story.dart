import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclone/auth/fireststore_methods.dart';
import 'package:instagramclone/providers/user_name_provider.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _pickedFile;
  final FireStoreMethods _methods = FireStoreMethods();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  _takePhoto();
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _getImageFromGallery();
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
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
        backgroundColor: mobileBackgroundColor,
        automaticallyImplyLeading: true,
        title: const Text('Posts'),
        actions: [
          TextButton(
              onPressed: () => _selectImage(context),
              child: const Text(
                'Add Post',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _pickedFile != null
                  ? Container(
                      height: size.height * .3,
                      width: size.width * .9,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: MemoryImage(_pickedFile!),
                      )),
                    )
                  : SizedBox(
                      height: size.height * .3,
                      width: size.width * .9,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                width: size.width * 0.3,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Write a caption...", border: InputBorder.none),
                  maxLines: 8,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width - 100,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.blue),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          if (_pickedFile == null &&
                              _descriptionController.text.isEmpty) {
                            Get.snackbar(
                                "Empty Fields", 'Cannot Post Empty Data',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                isDismissible: true,
                                duration: const Duration(seconds: 3));
                            Get.back();
                            setState(() {
                              _isLoading = false;
                            });
                          } else {
                            final description = _descriptionController.text;

                            final uid =
                                context.read<UserNameProvider>().getUser!.uid;

                            final userName = context
                                .read<UserNameProvider>()
                                .getUser!
                                .userName;
                            final profImage = context
                                    .read<UserNameProvider>()
                                    .getUser!
                                    .profUrl ??
                                "";
                            String responce = await _methods.uploadPost(
                                description,
                                _pickedFile!,
                                uid,
                                userName,
                                profImage);
                            if (responce == 'success') {
                              Get.snackbar(responce, '',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                  isDismissible: true,
                                  duration: const Duration(seconds: 3));
                              setState(() {
                                _isLoading = false;
                              });
                              setState(() {
                                _pickedFile = null;
                              });
                            } else {
                              Get.snackbar(responce, '',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.BOTTOM,
                                  isDismissible: true,
                                  duration: const Duration(seconds: 3));
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        },
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    backgroundColor: Colors.green),
                              )
                            : const Text("Post")),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

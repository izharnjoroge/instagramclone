import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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

  void _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
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

  void deleteImage() {
    setState(() {
      _pickedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => deleteImage(),
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.black,
            )),
        backgroundColor: mobileBackgroundColor,
        centerTitle: true,
        title: const Text(
          'Post Story',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () => _selectImage(context),
              icon: const Icon(
                Icons.select_all,
                color: Colors.black,
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
                      height: size.height * .5,
                      width: size.width * .9,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image: MemoryImage(_pickedFile!),
                      )),
                    )
                  : SizedBox(
                      height: size.height * .5,
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
              const Gap(10),
              SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.2,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      hintText: "Write a caption...",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black))),
                  maxLines: 8,
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width - 100,
                    height: 40,
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
                                _descriptionController.clear();
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

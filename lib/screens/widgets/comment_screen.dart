import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagramclone/auth/fireststore_methods.dart';
import 'package:instagramclone/models/user_model.dart';
import 'package:instagramclone/providers/user_name_provider.dart';
import 'package:instagramclone/screens/widgets/commet_card.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  @override
  void dispose() {
    super.dispose();
    commentEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<UserNameProvider>().getUser;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Comments',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.postId)
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                );
              case ConnectionState.active:
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CommentCard(
                        snap: snapshot.data!.docs[index].data(),
                      );
                    },
                  );
                } else {
                  return const Text("No Posts Yet");
                }
              case ConnectionState.none:
                return const Text("An Error Occurred");
              default:
                return const CircularProgressIndicator(
                  color: Colors.red,
                );
            }
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                user!.profUrl != ''
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user.profUrl.toString()),
                        radius: 18,
                      )
                    : const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 18,
                      ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: TextField(
                      controller: commentEditingController,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${user.userName}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (commentEditingController.text.isEmpty) {
                      Get.snackbar('Comment cannot be empty', '',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          isDismissible: true,
                          duration: const Duration(seconds: 3));
                    } else {
                      await FireStoreMethods().postComment(
                        widget.postId,
                        commentEditingController.text,
                        user.uid,
                        user.userName,
                        user.profUrl ?? '',
                      );
                      setState(() {
                        commentEditingController.clear();
                      });
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'Post',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:instagramclone/auth/fireststore_methods.dart';
import 'package:instagramclone/models/user_model.dart';
import 'package:instagramclone/screens/widgets/comment_screen.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/user_name_provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {}
    setState(() {});
  }

  void animate() {
    const Icon(Icons.thumb_up_alt_outlined)
        .animate()
        .fadeIn(duration: 600.ms)
        .then(delay: 200.ms)
        .slide()
        .tint(color: Colors.red);
  }

  deletePost(String postId) async {
    try {
      String message = await FireStoreMethods().deletePost(postId);
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<UserNameProvider>().getUser;
    Size size = MediaQuery.of(context).size;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  // backgroundImage: NetworkImage(
                  //   widget.snap['profImage'],
                  // ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => deletePost(widget.snap['postId']),
                    icon: const Icon(Icons.delete_forever))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                  widget.snap['postId'], user!.uid, widget.snap['likes']);
              animate();
            },
            child: SizedBox(
              height: size.height * 0.25,
              width: double.infinity,
              child: Image.network(
                widget.snap['postUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            children: [
              widget.snap['likes'].contains(user!.uid)
                  ? IconButton(
                      onPressed: () async {
                        await FireStoreMethods().likePost(widget.snap['postId'],
                            user.uid, widget.snap['likes']);
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ))
                  : IconButton(
                      onPressed: () async {
                        await FireStoreMethods().likePost(widget.snap['postId'],
                            user.uid, widget.snap['likes']);
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )),
              IconButton(
                  onPressed: () => Get.to(CommentScreen(
                        postId: widget.snap['postId'],
                      )),
                  icon: const Icon(Icons.comment)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.bookmark)))
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                  // onTap: () => Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => CommentsScreen(
                  //       postId: widget.snap['postId'].toString(),
                  //     ),
                  //   ),
                  // ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

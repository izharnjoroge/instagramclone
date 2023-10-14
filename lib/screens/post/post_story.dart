import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        automaticallyImplyLeading: true,
        title: const Text('Posts'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'Done',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(''),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                  hintText: "Write a caption...", border: InputBorder.none),
              maxLines: 8,
            ),
          ),
          SizedBox(
            height: 45.0,
            width: 45.0,
            child: AspectRatio(
              aspectRatio: 487 / 451,
              // child: Container(
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //     fit: BoxFit.fill,
              //     alignment: FractionalOffset.topCenter,
              //     image: MemoryImage(),
              //   )),
              // ),
            ),
          ),
        ],
      ),
    );
  }
}

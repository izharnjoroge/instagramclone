import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:instagramclone/models/user_model.dart';
import 'package:instagramclone/screens/widgets/post_card.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../../providers/user_name_provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user = context.read<UserNameProvider>().getUser;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            'assets/ic_instagram.svg',
            color: Colors.blue,
            height: 32,
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.messenger_outline,
                color: primaryColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostCard(
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
                  return const CircularProgressIndicator();
              }
            }));
  }
}

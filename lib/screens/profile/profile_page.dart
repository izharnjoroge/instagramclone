import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:instagramclone/auth/auth.dart';
import 'package:instagramclone/auth/fireststore_methods.dart';
import 'package:instagramclone/models/user_model.dart';
import 'package:instagramclone/responsive/mobile_screen_layout.dart';
import 'package:instagramclone/screens/widgets/follow_button.dart';
import 'package:instagramclone/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FireStoreMethods _fireStoreMethods = FireStoreMethods();
  UserModel? userData;
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('Users').doc(widget.uid).get();

      var postSnap = await _firestore
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      UserModel userDatas = UserModel.fromSnap(snap);
      setState(() {
        userData = userDatas;
        postLen = postSnap.docs.length;
      });

      print(userDatas.userName);
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SafeArea(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                userData!.userName,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        userData!.profUrl ?? '',
                      ),
                      radius: 60,
                      child: const Icon(
                        Icons.person_2_outlined,
                        size: 60,
                      ),
                    ),
                  ],
                ),
                const Gap(30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Change Profile Photo',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Gap(30),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildStatColumn(postLen, "posts"),
                    buildStatColumn(userData!.followers.length, "followers"),
                    buildStatColumn(userData!.following.length, "following"),
                  ],
                ),
                const Gap(30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _auth.currentUser!.uid == widget.uid
                        ? GestureDetector(
                            onTap: () async {
                              await Auth().logOut();
                              if (context.mounted) {
                                Get.offAll(() => const MobileScreenLayout());
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              width: 100,
                              height: 27,
                              child: const Text(
                                'Sign Out',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : isFollowing
                            ? GestureDetector(
                                onTap: () async {
                                  await _fireStoreMethods.followUser(
                                    _auth.currentUser!.uid,
                                    userData!.uid,
                                  );

                                  setState(() {
                                    isFollowing = false;
                                    followers--;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 27,
                                  child: const Text(
                                    'Unfollow',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await _fireStoreMethods.followUser(
                                    _auth.currentUser!.uid,
                                    userData!.uid,
                                  );

                                  setState(() {
                                    isFollowing = false;
                                    followers--;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 27,
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                  ],
                ),
              ],
            ),
          ));
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
// ListView(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           
//                           Expanded(
//                             flex: 1,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   mainAxisSize: MainAxisSize.max,
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     buildStatColumn(postLen, "posts"),
//                                     buildStatColumn(followers, "followers"),
//                                     buildStatColumn(following, "following"),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     FirebaseAuth.instance.currentUser!.uid ==
//                                             widget.uid
//                                         ? FollowButton(
//                                             text: 'Sign Out',
//                                             backgroundColor:
//                                                 mobileBackgroundColor,
//                                             textColor: primaryColor,
//                                             borderColor: Colors.grey,
//                                             function: () async {
//                                               await Auth().logOut();
//                                               if (context.mounted) {
//                                                 Get.offAll(() =>
//                                                     const MobileScreenLayout());
//                                               }
//                                             },
//                                           )
//                                         : isFollowing
//                                             ? FollowButton(
//                                                 text: 'Unfollow',
//                                                 backgroundColor: Colors.white,
//                                                 textColor: Colors.black,
//                                                 borderColor: Colors.grey,
//                                                 function: () async {
//                                                   await FireStoreMethods()
//                                                       .followUser(
//                                                     FirebaseAuth.instance
//                                                         .currentUser!.uid,
//                                                     userData!.uid,
//                                                   );

//                                                   setState(() {
//                                                     isFollowing = false;
//                                                     followers--;
//                                                   });
//                                                 },
//                                               )
//                                             : FollowButton(
//                                                 text: 'Follow',
//                                                 backgroundColor: Colors.blue,
//                                                 textColor: Colors.white,
//                                                 borderColor: Colors.blue,
//                                                 function: () async {
//                                                   await FireStoreMethods()
//                                                       .followUser(
//                                                     FirebaseAuth.instance
//                                                         .currentUser!.uid,
//                                                     userData!.uid,
//                                                   );

//                                                   setState(() {
//                                                     isFollowing = true;
//                                                     followers++;
//                                                   });
//                                                 },
//                                               )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         padding: const EdgeInsets.only(
//                           top: 15,
//                         ),
//                         child: Text(
//                           userData!.userName,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.centerLeft,
//                         padding: const EdgeInsets.only(
//                           top: 1,
//                         ),
//                         child: Text(
//                           userData!.bio,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Divider(),
//                 FutureBuilder(
//                   future: FirebaseFirestore.instance
//                       .collection('posts')
//                       .where('uid', isEqualTo: widget.uid)
//                       .get(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }

//                     return GridView.builder(
//                       shrinkWrap: true,
//                       itemCount: (snapshot.data! as dynamic).docs.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 3,
//                         crossAxisSpacing: 5,
//                         mainAxisSpacing: 1.5,
//                         childAspectRatio: 1,
//                       ),
//                       itemBuilder: (context, index) {
//                         DocumentSnapshot snap =
//                             (snapshot.data! as dynamic).docs[index];

//                         return SizedBox(
//                           child: Image(
//                             image: NetworkImage(snap['postUrl']),
//                             fit: BoxFit.cover,
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 )
//               ],
//             ),
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String userName;
  final String bio;
  final String email;
  String? profUrl;
  final List followers;
  final List following;

  UserModel({
    required this.uid,
    required this.userName,
    required this.bio,
    required this.email,
    this.profUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userName': userName,
      'bio': bio,
      'email': email,
      'profUrl': profUrl ?? '',
      'followers': followers,
      'following': following,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      userName: json['userName'],
      bio: json['bio'],
      email: json['email'],
      profUrl: json['profUrl'] ?? '',
      followers: List.from(json['followers']),
      following: List.from(json['following']),
    );
  }

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        uid: snapshot['uid'],
        userName: snapshot['userName'],
        profUrl: snapshot['profUrl'] ?? '',
        bio: snapshot['bio'],
        email: snapshot['email'],
        followers: snapshot['followers'],
        following: snapshot['following']);
  }
}

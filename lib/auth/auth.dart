import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramclone/auth/storage.dart';
import 'package:instagramclone/models/user_model.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserData() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('Users').doc(currentUser.uid).get();
    return UserModel.fromSnap(snap);
  }

  String profileUrl = '';
  Future<String> signUp(
    String email,
    String password,
    String name,
    String bio,
    Uint8List? file,
  ) async {
    String res = '';
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (file != null) {
        profileUrl = await Storage().uploadImage('profileImages', file, false);
      }
      UserModel model = UserModel(
          uid: credential.user!.uid,
          userName: name,
          bio: bio,
          email: email,
          followers: [],
          following: []);
      await _firestore
          .collection('Users')
          .doc(credential.user!.uid)
          .set(model.toJson());
      res = 'Welcome';
    } on FirebaseAuthException catch (err) {
      res = err.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> logIn(
    String email,
    String password,
  ) async {
    String res = '';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      res = 'Success';
    } on FirebaseAuthException catch (err) {
      res = err.toString();
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void logOut() async {
    await _auth.signOut();
  }
}

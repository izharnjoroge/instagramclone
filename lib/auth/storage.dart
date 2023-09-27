import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> uploadImage(
      String folderName, Uint8List profilePhoto, bool isPost) async {
    Reference reference =
        storage.ref().child(folderName).child(auth.currentUser!.uid);
    UploadTask uploadTask = reference.putData(profilePhoto);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

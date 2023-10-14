import 'package:flutter/material.dart';
import 'package:instagramclone/auth/auth.dart';
import 'package:instagramclone/models/user_model.dart';

class UserNameProvider extends ChangeNotifier {
  UserModel? _user;
  final Auth _auth = Auth();

  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _auth.getUserData();
    _user = user;
    notifyListeners();
  }
}

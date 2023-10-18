import 'package:flutter/material.dart';
import 'package:instagramclone/auth/auth.dart';
import 'package:instagramclone/models/user_model.dart';

class UserNameProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  set isUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}

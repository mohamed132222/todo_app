import 'package:flutter/material.dart';
import 'package:todo_app/model/my_user.dart';

class AuthProviderApp extends ChangeNotifier {
  MyUser? currentUser;

  void changeUser(MyUser user) {
    currentUser = user;
    notifyListeners();
  }
}

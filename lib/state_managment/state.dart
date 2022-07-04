import 'package:flutter/cupertino.dart';

class Reducer with ChangeNotifier {
  String userUID = '';
  List allUsersUID = [];

  void saveUserUID(id) {
    userUID = id;
    notifyListeners();
  }

  void saveAllUsersUID(arrayOfUsersUID) {
    allUsersUID = arrayOfUsersUID;
    notifyListeners();
  }

  List deleteUser(userUid) {
    allUsersUID.removeWhere((element) => element == userUid);
    notifyListeners();
    return allUsersUID;
  }
}

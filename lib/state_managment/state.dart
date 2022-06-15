import 'package:flutter/cupertino.dart';

class Reducer with ChangeNotifier {
  String userUID = '';

  void saveUserUID(id) {
    userUID = id;
    notifyListeners();
  }
}

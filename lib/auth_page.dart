import 'package:flutter/material.dart';
import 'package:flutter_firebase/login_page.dart';
import 'package:flutter_firebase/register_page.dart';
import 'package:flutter_firebase/state_managment/state.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(goToRegisterPage: toggleScreens);
    } else {
      return RegisterPage(goToLoginPage: toggleScreens);
    }
  }
}

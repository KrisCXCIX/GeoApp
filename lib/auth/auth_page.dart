import 'package:flutter/material.dart';
import 'package:flutter_firebase/auth/login_page.dart';
import 'package:flutter_firebase/state_managment/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

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

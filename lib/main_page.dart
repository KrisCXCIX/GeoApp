import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/auth_page.dart';
import 'package:flutter_firebase/state_managment/state.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Reducer state = Reducer();

  @override
  Widget build(BuildContext context) {
    final userUID = context.read<Reducer>().userUID;
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}

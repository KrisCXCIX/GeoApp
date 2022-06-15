import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/main_page.dart';
import 'package:flutter_firebase/state_managment/state.dart';
import 'package:provider/provider.dart';
import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Reducer(),
        child: const Expanded(
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: MainPage(),
                ))));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../state_managment/state.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback goToLoginPage;
  const RegisterPage({Key? key, required this.goToLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatpasswordController = TextEditingController();
  bool _isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _errorText = '';

  Future signUp(stateRead) async {
    if (_passwordController.text.trim() ==
        _repeatpasswordController.text.trim()) {
      setState(() {
        _isLoading = true;
      });
      final usersUIDs =
          await FirebaseFirestore.instance.collection('users').doc('uid').get();
      auth
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim())
          .then((value) => {
                FirebaseFirestore.instance.collection('users').doc('uid').set({
                  'usersUIDs': [
                    ...usersUIDs['usersUIDs'],
                    auth.currentUser?.uid
                  ]
                }),
                stateRead.saveUserUID(auth.currentUser?.uid),
                stateRead.saveAllUsersUID(usersUIDs['usersUIDs']),
              })
          .catchError(
              (error, stackTrace) => setState((() => _errorText = 'Error')));
    } else {
      setState(() {
        _isLoading = false;
        _errorText = "Passwords are not the same";
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _errorText = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello Again!',
                style: GoogleFonts.bebasNeue(fontSize: 50, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome back',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Icon(Icons.map_outlined, size: 150),
              Visibility(
                visible: _isLoading,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 1.5,
                ),
              ),
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _errorText == '' ? false : true,
                child: Text(
                  _errorText,
                  style: GoogleFonts.bebasNeue(fontSize: 20, color: Colors.red),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Email...'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password...',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _repeatpasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Repeat password...',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: GestureDetector(
                  onTap: () {
                    final stateRead = context.read<Reducer>();
                    signUp(stateRead);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        color: const Color(0xFF00695C),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: const Text(
                      'You are already a member?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.goToLoginPage,
                    child: const Text(
                      'Go Log In',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

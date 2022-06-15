import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/state_managment/state.dart';
import 'package:provider/provider.dart';

class GeoForm extends StatefulWidget {
  GeoForm({Key? key}) : super(key: key);

  @override
  State<GeoForm> createState() => _GeoFormState();
}

class _GeoFormState extends State<GeoForm> {
  final projectName = TextEditingController();
  final xCoordinates = TextEditingController();
  final yCoordinates = TextEditingController();

  Future createUser(uid) async {
    final project =
        FirebaseFirestore.instance.collection(uid).doc(projectName.text);

    final projectDetails = {'x': xCoordinates.text, 'y': yCoordinates.text};
    await project.set(projectDetails);
  }

  Future _signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextFormField(
            controller: projectName,
          ),
          TextFormField(
            controller: xCoordinates,
          ),
          TextFormField(
            controller: yCoordinates,
          ),
          TextButton(
            onPressed: () {
              final uid = context.read<Reducer>().userUID;
              createUser(uid);
            },
            child: const Text('Save data'),
          ),
          TextButton(
            onPressed: () {
              _signOut();
            },
            child: const Text('Logout'),
          )
        ],
      ),
    );
  }
}

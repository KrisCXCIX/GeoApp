import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/actions.dart';
import 'package:provider/provider.dart';

import '../state_managment/state.dart';

class Users extends StatefulWidget {
  final List projectOwners;
  final projectName;
  const Users(
      {Key? key, required this.projectOwners, required this.projectName})
      : super(key: key);

  @override
  State<Users> createState() => _Users();
}

class _Users extends State<Users> {
  List projectOwners = [];

  void _showDeleteUserProjectDialog(context, deleteUserUID) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Stack(
            children: <Widget>[
              AlertDialog(
                title: const Text('Delete project'),
                content: const Text(
                    'Are you sure that you want to delete this user?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => {
                      deleteProjectOwner(context,
                          context.read<Reducer>().userUID, deleteUserUID),
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future deleteProjectOwner(context, currentLogedUserUID, deleteUserUID) async {
    widget.projectOwners.remove(deleteUserUID);
    if (widget.projectOwners.length >= 2) {
      for (var i = 0; i < widget.projectOwners.length; i++) {
        FirebaseFirestore.instance
            .collection(widget.projectOwners[i])
            .doc(widget.projectName)
            .update({'projectOwners': widget.projectOwners});
      }
    } else {
      FirebaseFirestore.instance
          .collection(currentLogedUserUID)
          .doc(widget.projectName)
          .update({'projectOwners': widget.projectOwners});
    }

    FirebaseFirestore.instance
        .collection(deleteUserUID)
        .doc(widget.projectName)
        .delete();
    dismissDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: FirebaseFirestore.instance
            .collection(context.read<Reducer>().userUID)
            .snapshots()
            .map((snapshots) => snapshots.docs
                .map((doc) => {'projectOwners': doc.data()})
                .toList()),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: widget.projectOwners.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle_outlined,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          widget.projectOwners[index],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ),
                      widget.projectOwners[0] == context.read<Reducer>().userUID
                          ? Expanded(
                              flex: 0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.white, // Button color
                                    child: widget.projectOwners[index] !=
                                            context.read<Reducer>().userUID
                                        ? InkWell(
                                            splashColor: Colors
                                                .amber[800], // Splash color
                                            onTap: () {
                                              _showDeleteUserProjectDialog(
                                                  context,
                                                  widget.projectOwners[index]);
                                            },
                                            child: const SizedBox(
                                                width: 40,
                                                height: 40,
                                                child: Icon(Icons.delete)),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                );
              });
        });
  }
}

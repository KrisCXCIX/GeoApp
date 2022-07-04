import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/actions.dart';
import 'package:flutter_firebase/state_managment/state.dart';
import 'package:provider/provider.dart';

class ProjectDetails extends StatefulWidget {
  final String projectName;
  final data;

  const ProjectDetails(
      {Key? key, required this.projectName, required this.data})
      : super(key: key);

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final _userUIDController = TextEditingController();

  void shareProject(context) async {
    try {
      final usersUIDs =
          await FirebaseFirestore.instance.collection('users').doc('uid').get();
      bool isUIDCorrect =
          usersUIDs['usersUIDs'].contains(_userUIDController.text);
      final users = [...widget.data['projectOwners'], _userUIDController.text];
      if (isUIDCorrect) {
        FirebaseFirestore.instance
            .collection(_userUIDController.text)
            .doc(widget.projectName)
            .set({'projectName': widget.projectName});

        for (var i = 0; i < users.length; i++) {
          FirebaseFirestore.instance
              .collection(users[i])
              .doc(widget.projectName)
              .update({'projectOwners': users});
        }
        setState(() {
          widget.data['projectOwners'] = users;
        });
        _userUIDController.text = '';
        dismissDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "User has been added",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff4caf50),
        ));
      } else {
        dismissDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "User doesnt exist",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xffdd2c00),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Something went wrong",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xffdd2c00),
      ));
    }
  }

  void _showShareProjectDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Stack(
            children: <Widget>[
              SimpleDialog(
                title: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Add entitlements'),
                      RawMaterialButton(
                        onPressed: () {
                          dismissDialog(context);
                        },
                        elevation: 2.0,
                        fillColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.close,
                          size: 15.0,
                        ),
                      )
                    ],
                  ),
                ),
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100,
                              child: Center(
                                child: SizedBox(
                                  width: 200,
                                  child: TextField(
                                    controller: _userUIDController,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: 'Enter user UID',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 75,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      shareProject(context);
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    padding: const EdgeInsets.all(5.0),
                                    shape: const StadiumBorder(),
                                    child: const Icon(
                                      Icons.add_circle,
                                      size: 35.0,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  void _showDeleteProjectDialog(context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Stack(
            children: <Widget>[
              AlertDialog(
                title: const Text('Delete project'),
                content: const Text(
                    'Are you sure that you want to delete this project?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => deleteProject(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future deleteProject(context) async {
    try {
      if (widget.data['projectOwners'].length >= 2) {
        for (var i = 0; i < widget.data['projectOwners'].length; i++) {
          FirebaseFirestore.instance
              .collection(widget.data['projectOwners'][i])
              .doc(widget.projectName)
              .delete();
        }
      } else {
        FirebaseFirestore.instance
            .collection(widget.data['projectOwners'][0])
            .doc(widget.projectName)
            .delete();
      }
      dismissDialog(context);
      dismissDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project has been deleted")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something was wrong")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      body: SafeArea(
          child: Column(
        children: [
          const Text('Dane projektu'),
          widget.data['projectOwners'][0] == context.read<Reducer>().userUID
              ? RawMaterialButton(
                  onPressed: () {
                    _showShareProjectDialog(context);
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    size: 25.0,
                  ),
                )
              : const SizedBox.shrink(),
          widget.data['projectOwners'][0] == context.read<Reducer>().userUID
              ? RawMaterialButton(
                  onPressed: () {
                    _showDeleteProjectDialog(context);
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.delete,
                    size: 25.0,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      )),
    );
  }
}

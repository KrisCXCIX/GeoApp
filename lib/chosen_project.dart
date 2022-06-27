import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChosenProject extends StatefulWidget {
  final String projectName;
  final Object data;

  const ChosenProject(
      {Key? key, required String this.projectName, required Object this.data})
      : super(key: key);

  @override
  State<ChosenProject> createState() => _ChosenProjectState();
}

class _ChosenProjectState extends State<ChosenProject> {
  final _userUID = TextEditingController();

  Future createProject() async {
    final project = FirebaseFirestore.instance
        .collection(_userUID.text)
        .doc(widget.projectName);

    final projectDetails = {
      'projectName': widget.projectName,
    };
    await project.set(projectDetails);
    _userUID.text = '';
    _dismissDialog();
  }

  void _showShareProjectDialog() {
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
                          _dismissDialog();
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
                    height: 200,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 150,
                              child: Center(
                                child: SizedBox(
                                  width: 200,
                                  child: TextField(
                                    controller: _userUID,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: 'Enter user UID',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      createProject();
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

  _dismissDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.projectName)),
      body: SafeArea(
          child: Column(
        children: [
          const Text('Dane projektu'),
          RawMaterialButton(
            onPressed: () {
              _showShareProjectDialog();
            },
            elevation: 2.0,
            fillColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              size: 25.0,
            ),
          ),
        ],
      )),
    );
  }
}

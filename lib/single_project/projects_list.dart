import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/actions.dart';
import 'package:flutter_firebase/single_list_element.dart';
import 'package:flutter_firebase/state_managment/state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({Key? key}) : super(key: key);

  @override
  State<ProjectsList> createState() => _ProjectsList();
}

class _ProjectsList extends State<ProjectsList> {
  final _projectName = TextEditingController();

  Future createProject(context, String uid) async {
    try {
      final project =
          FirebaseFirestore.instance.collection(uid).doc(_projectName.text);

      final projectDetails = {
        'projectName': _projectName.text,
        'projectOwners': [uid],
      };
      await project.set(projectDetails);
      _projectName.text = '';
      dismissDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project has been added")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Something went wrong ")));
    }
  }

  void _showAddProjectDialog() {
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
                      const Text('Add new project'),
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
                                    controller: _projectName,
                                    decoration: const InputDecoration(
                                      border: UnderlineInputBorder(),
                                      hintText: 'Enter project name',
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
                                      createProject(context,
                                          context.read<Reducer>().userUID);
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

  Stream<List> getProjects(String uid) => FirebaseFirestore.instance
      .collection(uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => {'name': doc.id, 'data': doc.data()})
          .toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Projects',
              style: GoogleFonts.bebasNeue(fontSize: 25, color: Colors.white)),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFF263238),
          child: Column(
            children: [
              Flexible(
                child: StreamBuilder<List>(
                    stream: getProjects(context.read<Reducer>().userUID),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('smth wrong');
                      } else if (snapshot.hasData) {
                        final project = snapshot.data!;
                        return ListView.builder(
                            itemCount: project.length,
                            itemBuilder: (context, index) {
                              return SingleProject(
                                projectName: project[index]['name'],
                                projectData: project[index]['data'],
                              );
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: ClipOval(
                        child: Material(
                          color: Colors.white, // Button color
                          child: InkWell(
                            splashColor: Colors.amber[800], // Splash color
                            onTap: () {
                              _showAddProjectDialog();
                            },
                            child: const SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(Icons.add_home_work)),
                          ),
                        ),
                      )),
                ),
              )
            ],
          )),
    );
  }
}

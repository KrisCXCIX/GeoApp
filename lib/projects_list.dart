import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/single_project.dart';
import 'package:flutter_firebase/state_managment/state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({Key? key}) : super(key: key);

  @override
  State<ProjectsList> createState() => _ProjectsList();
}

class _ProjectsList extends State<ProjectsList> {
  final projectName = TextEditingController();
  final xCoordinates = TextEditingController();
  final yCoordinates = TextEditingController();
  bool shouldAddDialogBeVisible = false;

  // Future createUser(uid) async {
  //   final project =
  //       FirebaseFirestore.instance.collection(uid).doc(projectName.text);

  //   final projectDetails = {'x': xCoordinates.text, 'y': yCoordinates.text};
  //   await project.set(projectDetails);
  // }

  void _showMaterialDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Stack(
            children: <Widget>[
              SimpleDialog(
                title: const Center(child: Text('Dodawanie projekt')),
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: GestureDetector(
                                onTap: () {},
                                child: GestureDetector(
                                  child: Row(
                                    children: const [
                                      Text('Add'),
                                      Icon(Icons.add),
                                    ],
                                  ),
                                )),
                          ),
                          GestureDetector(
                              onTap: () {
                                _dismissDialog();
                              },
                              child: GestureDetector(
                                  child: Row(
                                children: const [
                                  Text('Clsoe'),
                                  Icon(Icons.close),
                                ],
                              ))),
                        ],
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

  Stream<List> getProjects(uid) => FirebaseFirestore.instance
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
              // Visibility(
              //   visible: shouldAddDialogBeVisible,
              //   child: SimpleDialog(
              //     title: const Text('GeeksforGeeks'),
              //     children: <Widget>[
              //       SimpleDialogOption(
              //         onPressed: () {},
              //         child: const Text('Option 1'),
              //       ),
              //       SimpleDialogOption(
              //         onPressed: () {},
              //         child: const Text('Option 2'),
              //       ),
              //     ],
              //   ),
              // ),
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
                            splashColor: Colors.red, // Splash color
                            onTap: () {
                              _showMaterialDialog();
                              setState(() {
                                shouldAddDialogBeVisible =
                                    !shouldAddDialogBeVisible;
                              });
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



// TextButton(
//             onPressed: () {
//               _signOut();
//             },
//             child: const Text('Logout'),
//           )

// import 'dart:ffi';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_firebase/state_managment/state.dart';
// import 'package:provider/provider.dart';

// class GeoForm extends StatefulWidget {
//   GeoForm({Key? key}) : super(key: key);

//   @override
//   State<GeoForm> createState() => _GeoFormState();
// }

// class _GeoFormState extends State<GeoForm> {
//   final projectName = TextEditingController();
//   final xCoordinates = TextEditingController();
//   final yCoordinates = TextEditingController();
//   final List projects = [];

//   Future createUser(uid) async {
//     final project =
//         FirebaseFirestore.instance.collection(uid).doc(projectName.text);

//     final projectDetails = {'x': xCoordinates.text, 'y': yCoordinates.text};
//     await project.set(projectDetails);
//   }

//   Future getProjects() async {
//     final project = FirebaseFirestore.instance.collection;
//   }

//   Future _signOut() async {
//     return FirebaseAuth.instance.signOut();
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Container(
//   //       child: CustomScrollView(
//   //     slivers: <Widget>[
//   //       const SliverAppBar(
//   //         pinned: true,
//   //         flexibleSpace: FlexibleSpaceBar(
//   //           title: Text('Projects'),
//   //         ),
//   //       ),
//   //       SliverFixedExtentList(
//   //         itemExtent: 50.0,
//   //         delegate: SliverChildBuilderDelegate(
//   //           (BuildContext context, int index) {
//   //             return Container(
//   //               alignment: Alignment.center,
//   //               color: Colors.lightBlue[100 * (index % 9)],
//   //               child: Text('List Item $index'),
//   //             );
//   //           },
//   //         ),
//   //       ),
//   //     ],
//   //   ));
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           TextFormField(
//             controller: projectName,
//           ),
//           TextFormField(
//             controller: xCoordinates,
//           ),
//           TextFormField(
//             controller: yCoordinates,
//           ),
//           TextButton(
//             onPressed: () {
//               final uid = context.read<Reducer>().userUID;
//               createUser(uid);
//             },
//             child: const Text('Save data'),
//           ),
//           TextButton(
//             onPressed: () {
//               _signOut();
//             },
//             child: const Text('Logout'),
//           )
//         ],
//       ),
//     );
//   }
// }

//  
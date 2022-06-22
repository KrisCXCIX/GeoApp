import 'package:flutter/material.dart';
import 'package:flutter_firebase/chosen_project.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleProject extends StatelessWidget {
  final String projectName;
  final Object projectData;

  SingleProject({required this.projectName, required this.projectData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChosenProject(
                        projectName: projectName, data: projectData)),
              );
            },
            child: Container(
              margin:
                  const EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(width: 2.0, color: Color(0xFF00695C)))),
              child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 50),
                  child: Text(
                    projectName,
                    style: GoogleFonts.bebasNeue(
                        fontSize: 30, color: Colors.white),
                  )),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChosenProject(
                      projectName: projectName, data: projectData)),
            );
          },
          child: RawMaterialButton(
            onPressed: () {},
            elevation: 2.0,
            fillColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              size: 25.0,
            ),
          ),
        ),
      ],
    );
  }
}

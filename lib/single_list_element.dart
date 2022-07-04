import 'package:flutter/material.dart';
import 'package:flutter_firebase/single_project/chosen_project.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleProject extends StatefulWidget {
  final String projectName;
  final Object projectData;

  const SingleProject(
      {Key? key, required this.projectName, required this.projectData})
      : super(key: key);

  @override
  State<SingleProject> createState() => _SingleProjectState();
}

class _SingleProjectState extends State<SingleProject> {
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
                        projectName: widget.projectName,
                        data: widget.projectData)),
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
                    widget.projectName,
                    style: GoogleFonts.bebasNeue(
                        fontSize: 30, color: Colors.white),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

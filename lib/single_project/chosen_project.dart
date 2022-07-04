import 'package:flutter/material.dart';
import 'package:flutter_firebase/single_project/project_details.dart';
import 'package:flutter_firebase/single_project/users.dart';
import 'package:google_fonts/google_fonts.dart';

class ChosenProject extends StatefulWidget {
  final String projectName;
  final data;

  const ChosenProject({Key? key, required this.projectName, required this.data})
      : super(key: key);

  @override
  State<ChosenProject> createState() => _ChosenProjectState();
}

class _ChosenProjectState extends State<ChosenProject> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF263238),
      appBar: AppBar(
          title: Text(widget.projectName,
              style: GoogleFonts.bebasNeue(fontSize: 25, color: Colors.white))),
      body: _selectedIndex == 0
          ? ProjectDetails(projectName: widget.projectName, data: widget.data)
          : Users(
              projectOwners: widget.data['projectOwners'],
              projectName: widget.projectName,
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Users',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

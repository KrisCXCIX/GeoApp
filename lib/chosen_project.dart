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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.projectName)),
      body: SafeArea(child: Text('Dane projektu')),
    );
  }
}

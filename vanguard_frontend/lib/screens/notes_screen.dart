import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  final int scoutID;

  const NotesScreen({super.key, required this.scoutID});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: Text('Notes Screen'),
        ),
      ),
    );
  }
}

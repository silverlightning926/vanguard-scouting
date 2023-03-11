import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vanguard_frontend/managers/network_manager.dart';
import 'package:vanguard_frontend/screens/competition_select_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    NetworkManager.getCompetitions().then(
      (value) => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompetitionSelectScreen(
              competitions: value,
            ),
          ),
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Center(
          child: SpinKitFadingCube(
            color: Colors.white,
            size: 50.0,
          ),
        ),
      ),
    );
  }
}

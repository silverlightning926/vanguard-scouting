import 'package:flutter/material.dart';
import 'package:vanguard_frontend/screens/loading_screen.dart';
import 'package:vanguard_frontend/screens/scout_screen.dart';

import '../managers/network_manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<bool> _value;

  @override
  void initState() {
    super.initState();
    _value = NetworkManager.isAlive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: _value,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                return const ScoutScreen();
              } else {
                return const LoadingScreen();
              }
            },
          ),
        ),
      ),
    );
  }
}

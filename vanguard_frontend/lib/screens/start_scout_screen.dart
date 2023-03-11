import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vanguard_frontend/managers/network_manager.dart';
import 'package:vanguard_frontend/screens/scout_screen.dart';
import 'package:vanguard_frontend/serialized/robot.dart';

class StartScoutScreen extends StatefulWidget {
  const StartScoutScreen({super.key, required this.robot});

  final Robot robot;

  @override
  State<StartScoutScreen> createState() => _StartScoutScreenState();
}

class _StartScoutScreenState extends State<StartScoutScreen> {
  final List<bool> _isSelected = <bool>[false, false, false];

  @override
  void initState() {
    super.initState();
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              "Vanguard",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.robot.name!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.robot.number!,
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  ToggleButtons(
                    direction: Axis.vertical,
                    isSelected: _isSelected,
                    children: const [Text('None'), Text('Cone'), Text('Cube')],
                    onPressed: (index) {
                      setState(() {
                        for (int i = 0; i < _isSelected.length; i++) {
                          if (i == index) {
                            _isSelected[i] = true;
                          } else {
                            _isSelected[i] = false;
                          }
                        }
                      });
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  context.loaderOverlay.show();

                  String preload = 'NULL';
                  if (_isSelected[1]) {
                    preload = 'CN';
                  } else if (_isSelected[2]) {
                    preload = 'CB';
                  }

                  NetworkManager.startMatch(
                          widget.robot.robotinmatchid!, preload)
                      .then((value) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScoutScreen(),
                              ),
                            ),
                          });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Start Match'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

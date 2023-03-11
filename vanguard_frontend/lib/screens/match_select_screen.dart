import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vanguard_frontend/managers/network_manager.dart';
import 'package:vanguard_frontend/screens/start_scout_screen.dart';
import 'package:vanguard_frontend/serialized/match.dart';
import 'package:vanguard_frontend/serialized/robot.dart';

class MatchSelectScreen extends StatefulWidget {
  const MatchSelectScreen({super.key, required this.matches});

  final List<Match> matches;

  @override
  State<MatchSelectScreen> createState() => _MatchSelectScreenState();
}

class _MatchSelectScreenState extends State<MatchSelectScreen> {
  late Match _selectedMatch = widget.matches.first;
  String _selectedAllianceStation = 'R1';

  @override
  void initState() {
    context.loaderOverlay.hide();
    super.initState();
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select Match",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              DropdownButton(
                value: _selectedMatch,
                items: widget.matches.map<DropdownMenuItem<Match>>(
                  (value) {
                    return DropdownMenuItem<Match>(
                      value: value,
                      child: Text(
                        '${value.matchtypeid} ${value.number}',
                      ),
                    );
                  },
                ).toList(),
                onChanged: (newValue) {
                  setState(
                    () {
                      _selectedMatch = newValue as Match;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Select Alliance Station",
                style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
              DropdownButton(
                items: const [
                  DropdownMenuItem(
                    value: 'R1',
                    child: Text('Red 1'),
                  ),
                  DropdownMenuItem(
                    value: 'R2',
                    child: Text('Red 2'),
                  ),
                  DropdownMenuItem(
                    value: 'R3',
                    child: Text('Red 3'),
                  ),
                  DropdownMenuItem(
                    value: 'B1',
                    child: Text('Blue 1'),
                  ),
                  DropdownMenuItem(
                    value: 'B2',
                    child: Text('Blue 2'),
                  ),
                  DropdownMenuItem(
                    value: 'B3',
                    child: Text('Blue 3'),
                  ),
                ],
                value: _selectedAllianceStation,
                onChanged: (newValue) {
                  setState(
                    () {
                      _selectedAllianceStation = newValue as String;
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  context.loaderOverlay.show();
                  NetworkManager.getRobot(
                    _selectedMatch.tbakey!,
                    _selectedAllianceStation,
                  ).then(
                    (value) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StartScoutScreen(
                            robot: value,
                          ),
                        ),
                      ),
                    },
                  );
                },
                child: const Text('Select'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

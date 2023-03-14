import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vanguard_frontend/managers/network_manager.dart';
import 'package:vanguard_frontend/screens/analytics_team_select_screen.dart';
import 'package:vanguard_frontend/screens/match_select_screen.dart';
import 'package:vanguard_frontend/serialized/competition.dart';

class CompetitionSelectScreen extends StatefulWidget {
  const CompetitionSelectScreen({Key? key, required this.competitions})
      : super(key: key);

  @override
  State<CompetitionSelectScreen> createState() =>
      _CompetitionSelectScreenState();

  final List<Competition> competitions;
}

class _CompetitionSelectScreenState extends State<CompetitionSelectScreen> {
  late Competition _selectedCompetition = widget.competitions.first;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
          body: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  onPressed: () {
                    context.loaderOverlay.show();
                    NetworkManager.getStats().then(
                      (value) => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnalyticsTeamSelectScreen(
                              robots: value,
                            ),
                          ),
                        ),
                      },
                    );
                  },
                  iconSize: 35,
                  color: Colors.white,
                  icon: const Icon(
                    Icons.line_axis_rounded,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Select Competition",
                      style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButton(
                      value: _selectedCompetition,
                      items: widget.competitions
                          .map<DropdownMenuItem<Competition>>(
                        (value) {
                          return DropdownMenuItem<Competition>(
                            value: value,
                            child: Text(
                              '${value.name} - ${DateTime.parse('${value.startdate}').year}',
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: (newValue) {
                        setState(
                          () {
                            _selectedCompetition = newValue as Competition;
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
                        NetworkManager.getMatches(_selectedCompetition.tbakey!)
                            .then(
                          (value) => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MatchSelectScreen(
                                  matches: value,
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
            ],
          ),
        ),
      ),
    );
  }
}

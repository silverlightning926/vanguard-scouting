import 'package:flutter/material.dart';
import 'package:vanguard_frontend/serialized/robot.dart';
import 'package:vanguard_frontend/serialized/team_stats.dart';

import 'analytics_screen.dart';

class AnalyticsTeamSelectScreen extends StatelessWidget {
  final List<TeamStats> robots;

  const AnalyticsTeamSelectScreen({super.key, required this.robots});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Vanguard",
          ),
        ),
        body: ListView.builder(
          itemCount: robots.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: Border.all(
                color: Colors.white,
              ),
              title: Text(robots[index].teamName!),
              subtitle: Text(robots[index].teamNumber!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnalyticsScreen(
                      teamStats: robots[index],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

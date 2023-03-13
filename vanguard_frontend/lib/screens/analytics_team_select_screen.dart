import 'package:flutter/material.dart';
import 'package:vanguard_frontend/serialized/robot.dart';

class AnalyticsTeamSelectScreen extends StatelessWidget {
  final List<Robot> robots;

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
              title: Text(robots[index].name!),
              subtitle: Text(robots[index].number!),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vanguard_frontend/serialized/robot.dart';

class AnalyticsTeamSelectScreen extends StatefulWidget {
  final List<Robot> robots;

  const AnalyticsTeamSelectScreen({super.key, required this.robots});

  @override
  State<AnalyticsTeamSelectScreen> createState() =>
      _AnalyticsTeamSelectScreenState();
}

class _AnalyticsTeamSelectScreenState extends State<AnalyticsTeamSelectScreen> {
  String searchValue = "";

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
          itemCount: widget.robots.length,
          itemBuilder: (context, index) {
            return ListTile(
              shape: Border.all(
                color: Colors.white,
              ),
              title: Text(widget.robots[index].name!),
              subtitle: Text(widget.robots[index].number!),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}

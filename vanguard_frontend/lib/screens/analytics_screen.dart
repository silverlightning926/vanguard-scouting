import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vanguard_frontend/serialized/team_stats.dart';

class AnalyticsScreen extends StatelessWidget {
  final TeamStats teamStats;

  const AnalyticsScreen({super.key, required this.teamStats});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Vanguard",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                teamStats.teamName!,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                teamStats.teamNumber!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Average Low Cones: ${teamStats.aVGLowCones}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        "Average Middle Cones: ${teamStats.aVGMiddleCones}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        "Average High Cones: ${teamStats.aVGHighCones}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Average Low Cube: ${teamStats.aVGLowCubes}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        "Average Middle Cube: ${teamStats.aVGMiddleCubes}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        "Average High Cube: ${teamStats.aVGHighCubes}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

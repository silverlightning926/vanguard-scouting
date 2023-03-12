import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ScoutScreen extends StatefulWidget {
  const ScoutScreen({Key? key}) : super(key: key);

  @override
  State<ScoutScreen> createState() => _ScoutScreenState();
}

class _ScoutScreenState extends State<ScoutScreen> {
  bool _inTeleop = false;
  late int _countdownTime;

  final List<Widget> _autoNonGamePieceScoring = <Widget>[
    const Text("None"),
    const Text("Mobility"),
    const Text("Dock"),
    const Text("Engage"),
  ];
  final List<bool> _autoSelected = <bool>[true, false, false, false];

  final List<Widget> _teleNonGamePieceScoring = <Widget>[
    const Text("None"),
    const Text("Park"),
    const Text("Dock"),
    const Text("Engage"),
  ];
  final List<bool> _teleSelected = <bool>[true, false, false, false];

  @override
  void initState() {
    super.initState();
    _countdownTime = DateTime.now().millisecondsSinceEpoch +
        1000 * 15; // 15 seconds for auto period
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CountdownTimer(
                  onEnd: () {
                    setState(() {
                      _countdownTime = DateTime.now().millisecondsSinceEpoch +
                          1000 * 150; // 150 seconds for teleop period
                      _inTeleop = true;
                    });
                  },
                  endTime: _countdownTime,
                  widgetBuilder: (_, time) {
                    if (time == null) {
                      return const Text('Match Ended');
                    }
                    return Text(
                      '${!_inTeleop ? 'Auto' : ' TeleOp'}: ${time.min ?? 0}:${time.sec ?? 0}',
                      style: const TextStyle(fontSize: 30),
                    );
                  },
                ),
                ToggleButtons(
                  isSelected: !_inTeleop ? _autoSelected : _teleSelected,
                  onPressed: (index) {
                    setState(() {
                      for (int i = 0;
                          i <
                              (!_inTeleop
                                  ? _autoSelected.length
                                  : _teleSelected.length);
                          i++) {
                        if (i == index) {
                          !_inTeleop
                              ? _autoSelected[i] = true
                              : _teleSelected[i] = true;
                        } else {
                          !_inTeleop
                              ? _autoSelected[i] = false
                              : _teleSelected[i] = false;
                        }
                      }
                    });
                  },
                  children: !_inTeleop
                      ? _autoNonGamePieceScoring
                      : _teleNonGamePieceScoring,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("End Match"),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.yellow,
                        side: const BorderSide(color: Colors.yellow),
                      ),
                      child: const Text("Ground Substation Pickup"),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.yellow,
                        side: const BorderSide(color: Colors.yellow),
                      ),
                      child: const Text("Single Substation Pickup"),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.yellow,
                        side: const BorderSide(color: Colors.yellow),
                      ),
                      child: const Text("Double Substation Pickup"),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        side: const BorderSide(color: Colors.purple),
                      ),
                      child: const Text("Ground Substation Pickup"),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        side: const BorderSide(color: Colors.purple),
                      ),
                      child: const Text("Single Substation Pickup"),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple,
                        side: const BorderSide(color: Colors.purple),
                      ),
                      child: const Text("Double Substation Pickup"),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        ConeColumn(),
                        CubeColumn(),
                        ConeColumn(),
                        ConeColumn(),
                        CubeColumn(),
                        ConeColumn(),
                        ConeColumn(),
                        CubeColumn(),
                        ConeColumn(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Disable"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Disconnect"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Fall Over"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Foul"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Tech Foul"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Disable"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConeColumn extends StatefulWidget {
  const ConeColumn({
    Key? key,
  }) : super(key: key);

  @override
  State<ConeColumn> createState() => _ConeColumnState();
}

class _ConeColumnState extends State<ConeColumn> {
  final List<bool> _selected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ToggleButtons(
        color: Colors.yellow,
        borderColor: Colors.yellow,
        selectedColor: Colors.white,
        splashColor: Colors.yellow,
        selectedBorderColor: Colors.yellow,
        fillColor: Colors.yellow,
        direction: Axis.vertical,
        isSelected: _selected,
        onPressed: (index) {
          setState(() {
            _selected[index] = !_selected[index];
          });
        },
        children: const [
          Text('High'),
          Text('Middle'),
          Text('Low'),
        ],
      ),
    );
  }
}

class CubeColumn extends StatefulWidget {
  const CubeColumn({
    Key? key,
  }) : super(key: key);

  @override
  State<CubeColumn> createState() => _CubeColumnState();
}

class _CubeColumnState extends State<CubeColumn> {
  final List<bool> _selected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ToggleButtons(
        color: Colors.purple,
        borderColor: Colors.purple,
        selectedColor: Colors.white,
        splashColor: Colors.purple,
        selectedBorderColor: Colors.purple,
        fillColor: Colors.purple,
        direction: Axis.vertical,
        isSelected: _selected,
        onPressed: (index) {
          setState(() {
            _selected[index] = !_selected[index];
          });
        },
        children: const [
          Text('High'),
          Text('Middle'),
          Text('Low'),
        ],
      ),
    );
  }
}

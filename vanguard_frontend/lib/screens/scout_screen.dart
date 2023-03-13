import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:vanguard_frontend/managers/network_manager.dart';
import 'package:vanguard_frontend/screens/notes_screen.dart';
import 'package:vanguard_frontend/serialized/robot.dart';

class ScoutScreen extends StatefulWidget {
  final int scoutID;
  final Robot robot;

  const ScoutScreen({Key? key, required this.scoutID, required this.robot})
      : super(key: key);

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
        1000 * 18; // 18 seconds for auto period
    context.loaderOverlay.hide();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.robot.number!,
                    style: const TextStyle(
                      fontSize: 35,
                    ),
                  ),
                  CountdownTimer(
                    onEnd: () {
                      setState(() {
                        String scoringType = '';

                        if (!_inTeleop) {
                          if (_autoSelected[1]) {
                            scoringType = 'MB';
                          } else if (_autoSelected[2]) {
                            scoringType = 'DK';
                          } else if (_autoSelected[3]) {
                            scoringType = 'EG';
                          }

                          NetworkManager.scoreNonGamePiece(
                            widget.scoutID,
                            (!_inTeleop ? 'A' : 'T'),
                            scoringType,
                          );
                          _inTeleop = true;
                          _countdownTime =
                              DateTime.now().millisecondsSinceEpoch +
                                  1000 * 117; // 2 minutes for teleop period
                        } else {
                          if (_teleSelected[1]) {
                            scoringType = 'PK';
                          } else if (_teleSelected[2]) {
                            scoringType = 'DK';
                          } else if (_teleSelected[3]) {
                            scoringType = 'EG';
                          }

                          NetworkManager.scoreNonGamePiece(
                            widget.scoutID,
                            (!_inTeleop ? 'A' : 'T'),
                            scoringType,
                          );
                        }
                      });
                    },
                    endTime: _countdownTime,
                    widgetBuilder: (_, time) {
                      if (time == null) {
                        return const Text('Match Ended');
                      }
                      return Text(
                        '${!_inTeleop ? 'Auto' : ' TeleOp'}: ${Duration(minutes: (time.min ?? 0), seconds: (time.sec ?? 0)).inSeconds}',
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
                    onPressed: () {
                      context.loaderOverlay.show();
                      NetworkManager.endMatch(widget.scoutID).then(
                        (value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotesScreen(
                                scoutID: widget.scoutID,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text("End Match"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          NetworkManager.pickupGamePiece(
                            widget.scoutID,
                            (!_inTeleop ? 'A' : 'T'),
                            'CN',
                            'G',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.yellow,
                          side: const BorderSide(color: Colors.yellow),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Ground Pickup"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          NetworkManager.pickupGamePiece(
                            widget.scoutID,
                            (!_inTeleop ? 'A' : 'T'),
                            'CN',
                            'SS',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.yellow,
                          side: const BorderSide(color: Colors.yellow),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Single Pickup"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          NetworkManager.pickupGamePiece(
                            widget.scoutID,
                            (!_inTeleop ? 'A' : 'T'),
                            'CN',
                            'DS',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.yellow,
                          side: const BorderSide(color: Colors.yellow),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Double Pickup"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          NetworkManager.pickupGamePiece(
                            widget.scoutID,
                            (!_inTeleop ? 'A' : 'T'),
                            'CB',
                            'G',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Ground Pickup"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          NetworkManager.pickupGamePiece(
                            widget.scoutID,
                            (!_inTeleop ? 'A' : 'T'),
                            'CB',
                            'SS',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Single Pickup"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          NetworkManager.pickupGamePiece(
                            widget.scoutID,
                            (!_inTeleop ? 'A' : 'T'),
                            'CB',
                            'DS',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("Double Pickup"),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConeColumn(
                            locationID: '1',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                          CubeColumn(
                            locationID: '2',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                          ConeColumn(
                            locationID: '3',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                          ConeColumn(
                            locationID: '4',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                          CubeColumn(
                            locationID: '5',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                          ConeColumn(
                            locationID: '6',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                          ConeColumn(
                            locationID: '7',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                          CubeColumn(
                            locationID: '8',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                          ConeColumn(
                            locationID: '9',
                            matchPeriod: (!_inTeleop ? 'A' : 'T'),
                            scoutID: widget.scoutID,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              NetworkManager.addFault(
                                widget.scoutID,
                                (!_inTeleop ? 'A' : 'T'),
                                'DC',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Disconnect"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              NetworkManager.addFault(
                                widget.scoutID,
                                (!_inTeleop ? 'A' : 'T'),
                                'FA',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Fall Over"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              NetworkManager.addFault(
                                widget.scoutID,
                                (!_inTeleop ? 'A' : 'T'),
                                'DA',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Disable"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              NetworkManager.addFault(
                                widget.scoutID,
                                (!_inTeleop ? 'A' : 'T'),
                                'FL',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Foul"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              NetworkManager.addFault(
                                widget.scoutID,
                                (!_inTeleop ? 'A' : 'T'),
                                'TF',
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            child: const Text("Tech Foul"),
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
      ),
    );
  }
}

class ConeColumn extends StatefulWidget {
  final String locationID;
  final String matchPeriod;
  final int scoutID;

  const ConeColumn({
    Key? key,
    required this.locationID,
    required this.matchPeriod,
    required this.scoutID,
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
            if (!_selected[index]) {
              String locationID = "";

              switch (index) {
                case 0:
                  locationID = "H";
                  break;
                case 1:
                  locationID = "M";
                  break;
                case 2:
                  locationID = "L";
                  break;
              }

              locationID += widget.locationID;

              _selected[index] = true;
              NetworkManager.scoreGamePiece(
                widget.scoutID,
                widget.matchPeriod,
                "CN",
                locationID,
              );
            }
          });
        },
        children: [
          Text('H${widget.locationID}'),
          Text('M${widget.locationID}'),
          Text('L${widget.locationID}'),
        ],
      ),
    );
  }
}

class CubeColumn extends StatefulWidget {
  final String locationID;
  final String matchPeriod;
  final int scoutID;

  const CubeColumn({
    Key? key,
    required this.locationID,
    required this.matchPeriod,
    required this.scoutID,
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
            if (!_selected[index]) {
              String locationID = "";

              switch (index) {
                case 0:
                  locationID = "H";
                  break;
                case 1:
                  locationID = "M";
                  break;
                case 2:
                  locationID = "L";
                  break;
              }

              locationID += widget.locationID;

              _selected[index] = true;
              NetworkManager.scoreGamePiece(
                widget.scoutID,
                widget.matchPeriod,
                "CB",
                locationID,
              );
            }
          });
        },
        children: [
          Text('H${widget.locationID}'),
          Text('M${widget.locationID}'),
          Text('L${widget.locationID}'),
        ],
      ),
    );
  }
}

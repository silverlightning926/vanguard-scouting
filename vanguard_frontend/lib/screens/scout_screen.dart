import 'package:flutter/material.dart';

class ScoutScreen extends StatefulWidget {
  const ScoutScreen({Key? key}) : super(key: key);

  @override
  State<ScoutScreen> createState() => _ScoutScreenState();
}

class _ScoutScreenState extends State<ScoutScreen> {
  final List<bool> _selected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Start Match'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '2:30',
                style: TextStyle(
                  fontSize: 35,
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('End Match'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Ground Pickup"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Shelf Pickup"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Ground Pickup"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Shelf Pickup"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              "0:11",
              style: TextStyle(fontSize: 35),
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              children: const [
                ConeColumn(),
                SizedBox(
                  width: 10,
                ),
                CubeColumn(),
                SizedBox(
                  width: 10,
                ),
                ConeColumn(),
                SizedBox(
                  width: 10,
                ),
                ConeColumn(),
                SizedBox(
                  width: 10,
                ),
                CubeColumn(),
                SizedBox(
                  width: 10,
                ),
                ConeColumn(),
                SizedBox(
                  width: 10,
                ),
                ConeColumn(),
                SizedBox(
                  width: 10,
                ),
                CubeColumn(),
                SizedBox(
                  width: 10,
                ),
                ConeColumn(),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: ToggleButtons(
            isSelected: _selected,
            onPressed: (index) {
              setState(() {
                for (int i = 0; i < _selected.length; i++) {
                  _selected[i] = i == index;
                }
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Nothing'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Attempted'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Balanced'),
              ),
            ],
          ),
        ),
      ],
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
    return ToggleButtons(
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
    return ToggleButtons(
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
    );
  }
}

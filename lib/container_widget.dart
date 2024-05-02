import 'package:flutter/material.dart';
import 'package:flutter_application_1/rust_ffi.dart';
import './bouncing_balls.dart';

class ContainerWidget extends StatefulWidget {
  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  double _ballCount = 100;
  bool _useRust = false;
  final List<Color> _ballColors = [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.black];
  final List<Color> _ballColorsRust = [Colors.brown, Colors.orange, Colors.purple, Colors.pink, Colors.grey];

  void _toggleRustUsage() {
    setState(() {
      _useRust = !_useRust;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            children: List.generate(
              _ballColors.length,
              (index) => Positioned.fill(
                child: BouncingBalls(
                  key: UniqueKey(), // Important: Ensures the widget rebuilds when key changes
                  ballCount: _ballCount.toInt(),
                  ballColors: _ballColors,
                  ballColorsRust: _ballColorsRust,
                  useRust: _useRust,
                ),
              ),
            ),
          ),
        ),
        Slider(
          value: _ballCount,
          min: 100,
          max: 5000,
          divisions: 49,
          label: '$_ballCount',
          onChanged: (double newValue) {
            setState(() {
              _ballCount = newValue;
            });
          },
        ),
        SwitchListTile(
          title: Text("Use Rust for computation"),
          value: _useRust,
          onChanged: (bool value) {
            _toggleRustUsage();
          },
        ),
      ],
    );
  }
}

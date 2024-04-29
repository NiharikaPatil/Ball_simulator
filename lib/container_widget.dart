import 'package:flutter/material.dart';
import 'package:flutter_application_1/rust_ffi.dart';
import './bouncing_balls.dart';

class ContainerWidget extends StatefulWidget {
  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  double _ballCount = 10;
  final List<Color> _ballColors = [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.black]; // Define colors for layers

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Stack( // Use Stack widget to layer the bouncing balls
            children: List.generate(
              _ballColors.length,
              (index) => Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  child: BouncingBalls(
                    ballCount: _ballCount.toInt(),
                    ballColors: List.generate(_ballCount.toInt(), (i) => _ballColors[index]),
                  ),
                ),
              ),
            ),
          ),
        ),
        Slider(
          value: _ballCount,
          min: 10,
          max: 5000,
          onChanged: (double newValue) {
            setState(() {
              _ballCount = newValue;
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            print_aline();
            executeRustFunctionality();
          },
          child: Text('Rust'),
        ),
      ],
    );
  }
}

//have a large virtual screen but show a part of it on emulator
import 'package:flutter/material.dart';
import 'package:flutter_application_1/rust_ffi.dart';
import './bouncing_balls.dart';

class ContainerWidget extends StatefulWidget {
  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  double _ballCount = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            color: Colors.grey, 
            child: BouncingBalls(ballCount: _ballCount.toInt()),
          ),
        ),
        Slider(
          value: _ballCount,
          min: 10,
          max: 3000,
          onChanged: (double newValue) {
            setState(() {
              _ballCount = newValue; //everytime the slider value changes, new value for ball count is set
            });
          },
        ),
        ElevatedButton(
          onPressed: () {
            //the code to rust implementation will be added here
          },
          child: Text('Rust'),
        ),
      ],
    );
  }
}


//have a large virtual screen but show a part of it on emulator
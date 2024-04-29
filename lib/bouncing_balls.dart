import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class BouncingBalls extends StatefulWidget {
  final int ballCount;
  final List<Color> ballColors;

  BouncingBalls({required this.ballCount, required this.ballColors});

  @override
  _BouncingBallsState createState() => _BouncingBallsState();
}

class _BouncingBallsState extends State<BouncingBalls> {
  late List<Ball> _balls;
  late double _containerWidth;
  late double _containerHeight;

  @override
  void initState() {
    super.initState();
    _initializeBalls();
    startTimer();
  }

  @override
  void didUpdateWidget(BouncingBalls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ballCount != oldWidget.ballCount) {
      _initializeBalls();
    }
  }


void _initializeBalls() {
  _balls = List.generate(widget.ballCount, (index) {
    return Ball(color: widget.ballColors[index % widget.ballColors.length]);
  });
}



  void startTimer() {
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      for (int i = 0; i < _balls.length; i++) {
        _balls[i].move(_containerWidth, _containerHeight, _balls);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _containerWidth = constraints.maxWidth;
        _containerHeight = constraints.maxHeight;
        return CustomPaint(
          painter: BallsPainter(_balls),
          size: Size.infinite,
        );
      },
    );
  }
}

class Ball {
  late double x;
  late double y;
  late double dx;
  late double dy;
  final double radius = 5.0;
  final Random random = Random();
  late Color color;

  Ball({required this.color}) {
    x = random.nextDouble() * 400; //set a random value between o.o to 1.0 and then increase it by multiplying with 400
    y = random.nextDouble() * 400;
    dx = (random.nextDouble() * 4) - 2; //sets velocity between -2 to +2, we can change the velocity on the basis of your need
    dy = (random.nextDouble() * 4) - 2;
  }

  void move(double containerWidth, double containerHeight, List<Ball> balls) {
    x += dx; 
    y += dy;
    if (x <= 10 || x >= containerWidth-10) { //check the left and right boundary if the ball has hit it, subtracted 10 to give illusion of ball hitting headfirst
      dx = -dx; //for changing direction
    }
    if (y <= 10 || y >= containerHeight-10) { //same as above condition but for top and bottom
      dy = -dy;
    }
    for (var ball in balls) {
      if (ball != this) { //checks for self collision
        double dist = sqrt(pow(x - ball.x, 2) + pow(y - ball.y, 2)); //calculation of distance between two balls that are in vicinity to check for collision
        if (dist <= radius * 2) { // Balls are colliding
          double tempDx = dx;
          double tempDy = dy;
          dx = ball.dx;
          dy = ball.dy;
          ball.dx = tempDx;
          ball.dy = tempDy;
          break; // Exit loop after handling collision with one ball
        }
      }
    }
  }
}

void print_aline (){
  print("This is for the rust button");
}

class BallsPainter extends CustomPainter {
  final List<Ball> balls;

  BallsPainter(this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    for (var ball in balls) {
      canvas.drawCircle(
        Offset(ball.x, ball.y),
        ball.radius,
        Paint()..color = ball.color, // Use the color property of each Ball
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//run it in profile mode - test it in this mode

///real time display of the intricacies like time, performance on the screen
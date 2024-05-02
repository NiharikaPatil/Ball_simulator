import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'ball.dart'; // Ensure this file defines the Ball struct
import 'rust_ffi.dart'; // Contains FFI bindings

class BouncingBalls extends StatefulWidget {
  final int ballCount;
  final List<Color> ballColors;
  final List<Color> ballColorsRust;
  final bool useRust;

  BouncingBalls({
    required this.ballCount,
    required this.ballColors,
    required this.ballColorsRust,
    required this.useRust,
    Key? key,
  }) : super(key: key);

  @override
  _BouncingBallsState createState() => _BouncingBallsState();
}

class _BouncingBallsState extends State<BouncingBalls> with SingleTickerProviderStateMixin {
  late List<BallPainter> _balls;
  late AnimationController _controller;
  ffi.Pointer<Balls>? ballsPtr;
  late RustFFI rustFFI;

  @override
  void initState() {
    super.initState();
    rustFFI = RustFFI();
    _balls = List.generate(widget.ballCount, (index) => BallPainter(
      x: Random().nextDouble() * 2280, // Assuming some initial positions
      y: Random().nextDouble() * 400,
      dx: (Random().nextDouble() * 4.0) - 2.0,
      dy: (Random().nextDouble() * 4.0) - 2.0,
      color: widget.ballColors[index % widget.ballColors.length], // Default color or modify as needed
    ));
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..addListener(_updateBalls)
      ..repeat();
    if (widget.useRust) {
      ballsPtr = rustFFI.initializeBalls(widget.ballCount, widget.ballColorsRust.length);
    }
  }

  void _updateBalls() {
    if (widget.useRust && ballsPtr != null) {
      rustFFI.updateBallPositions(ballsPtr!, context.size!.width, context.size!.height);
      fetchBallsFromRust();
    } else {
      moveDartBalls();
    }
  }

  void fetchBallsFromRust() {
    Balls balls = ballsPtr!.ref;
    final ffi.Pointer<Ball> ballPointer = balls.ptr;
    setState(() {
      _balls = List.generate(balls.count, (index) {
        Ball ball = ballPointer.elementAt(index).ref;
        return BallPainter(
          x: ball.x,
          y: ball.y,
          dx: ball.dx,
          dy: ball.dy,
          color: widget.ballColorsRust[ball.colorIndex % widget.ballColorsRust.length],
        );
      });
    });
  }

  void moveDartBalls() {
    setState(() {
      for (var ball in _balls) {
        ball.move(context.size!.width, context.size!.height, _balls);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BallsPainter(_balls),
      size: Size.infinite,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    if (ballsPtr != null) {
      rustFFI.disposeBalls(ballsPtr!);
    }
    super.dispose();
  }
}

class BallPainter {
  double x, y, dx, dy;
  Color color;
  final double radius = 5.0;


  BallPainter({
    required this.x,
    required this.y,
    required this.dx,
    required this.dy,
    required this.color,
  });

  void move(double containerWidth, double containerHeight, List<BallPainter> balls) {
    x += dx;
    y += dy;
    if (x <= 10 || x >= containerWidth - 10) dx = -dx;
    if (y <= 10 || y >= containerHeight - 10) dy = -dy;
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

class BallsPainter extends CustomPainter {
  final List<BallPainter> balls;

  BallsPainter(this.balls);

  @override
  void paint(Canvas canvas, Size size) {
    for (var ball in balls) {
      Paint paint = Paint()..color = ball.color;
      canvas.drawCircle(Offset(ball.x, ball.y), 5.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

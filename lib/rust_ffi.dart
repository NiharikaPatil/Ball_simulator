import 'dart:ffi';
import 'dart:io' show Platform;
import 'package:ffi/ffi.dart';
import 'ball.dart';  // Ensure this contains the structure for Ball

final class Balls extends Struct {
  external Pointer<Ball> ptr;
  @Uint64()
  external int count;
}

typedef CreateBallsC = Pointer<Balls> Function(Uint64, Int32);
typedef CreateBallsDart = Pointer<Balls> Function(int, int);

typedef MoveBallsC = Void Function(Pointer<Balls>, Double, Double);
typedef MoveBallsDart = void Function(Pointer<Balls>, double, double);

typedef FreeBallsC = Void Function(Pointer<Balls>);
typedef FreeBallsDart = void Function(Pointer<Balls>);

class RustFFI {
  late final DynamicLibrary rustLib;
  late final CreateBallsDart createBalls;
  late final MoveBallsDart moveBalls;
  late final FreeBallsDart freeBalls;

  RustFFI() {
    rustLib = DynamicLibrary.open('librust_integration.so');
    createBalls = rustLib.lookupFunction<CreateBallsC, CreateBallsDart>('create_balls');
    moveBalls = rustLib.lookupFunction<MoveBallsC, MoveBallsDart>('move_balls');
    freeBalls = rustLib.lookupFunction<FreeBallsC, FreeBallsDart>('free_balls');
  }

  Pointer<Balls> initializeBalls(int ballCount, int colorCount) {
    return createBalls(ballCount, colorCount);
  }

  void updateBallPositions(Pointer<Balls> ballsPtr, double width, double height) {
    moveBalls(ballsPtr, width, height);
  }

  void disposeBalls(Pointer<Balls> ballsPtr) {
    freeBalls(ballsPtr);
  }
}

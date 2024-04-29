
import 'dart:ffi'; // Import dart:ffi library
import 'dart:io' show Platform; // Import Platform for platform-specific dynamic library loading
import 'package:ffi/ffi.dart';

final class Ball extends Struct {
  @Double()
  external double x;
  @Double()
  external double y;
  @Double()
  external double dx;
  @Double()
  external double dy;
}

typedef MoveBallsC = Void Function(Pointer<Ball>, IntPtr, Double, Double);
typedef MoveBallsDart = void Function(Pointer<Ball>, int, double, double);

typedef CreateBallsC = Pointer<Ball> Function(IntPtr);
typedef CreateBallsDart = Pointer<Ball> Function(int);

typedef FreeBallsC = Void Function(Pointer<Ball>);
typedef FreeBallsDart = void Function(Pointer<Ball>);

typedef GetBallC = Pointer<Ball> Function(Pointer<Ball>, IntPtr);
typedef GetBallDart = Pointer<Ball> Function(Pointer<Ball>, int);

typedef GetBallCountC = IntPtr Function(Pointer<Ball>);
typedef GetBallCountDart = int Function(Pointer<Ball>);

final DynamicLibrary rustLib = Platform.isAndroid
    ? DynamicLibrary.open('/Users/niharika/Documents/Test_app/flutter_application_1/rust_integration/target/release/librust_integration.dylib') // Android dynamic library
    : DynamicLibrary.process(); // iOS dynamic library

final MoveBallsDart moveBalls = rustLib.lookupFunction<MoveBallsC, MoveBallsDart>('move_balls');
final CreateBallsDart createBalls = rustLib.lookupFunction<CreateBallsC, CreateBallsDart>('create_balls');
final FreeBallsDart freeBalls = rustLib.lookupFunction<FreeBallsC, FreeBallsDart>('free_balls');
final GetBallDart getBall = rustLib.lookupFunction<GetBallC, GetBallDart>('get_ball');
final GetBallCountDart getBallCount = rustLib.lookupFunction<GetBallCountC, GetBallCountDart>('get_ball_count');

void executeRustFunctionality() {
  print("In the rust_ffi");
  Pointer<Ball> ballsPtr = createBalls(10); // Create 10 balls
  moveBalls(ballsPtr, 10, 400.0, 400.0); // Move balls
  print(getBallCount(ballsPtr)); // Print number of balls
  freeBalls(ballsPtr); // Free memory
  print("In the rust_ffi");
}

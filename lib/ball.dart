// Dart - lib/ball.dart
import 'package:ffi/ffi.dart';
import 'dart:ffi';

final class Ball extends Struct {
  @Double()
  external double x;
  @Double()
  external double y;
  @Double()
  external double dx;
  @Double()
  external double dy;
  @Int32()
  external int colorIndex; // Make sure this is defined in your Rust struct as well.
}

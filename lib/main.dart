import 'package:flutter/material.dart';
import './container_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showPerformanceOverlay = false;

  void _togglePerformanceOverlay() {
    setState(() {
      _showPerformanceOverlay = !_showPerformanceOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bouncing Balls',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.assessment),
              onPressed: _togglePerformanceOverlay,
            )
          ],
        ),
        body: ContainerWidget(),
      ),
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: _showPerformanceOverlay,
    );
  }
}

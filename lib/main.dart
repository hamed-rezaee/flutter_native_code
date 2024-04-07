import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: Scaffold(body: HomePage()),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const MethodChannel _methodChannel =
      MethodChannel('com.example.flutter_native_code/method_channel');
  static const EventChannel _eventChannel =
      EventChannel('com.example.flutter_native_code/pressure_channel');

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: _isSensorAvailable(),
                initialData: false,
                builder: (context, snapshot) =>
                    Text('Sensor Available: ${snapshot.data}'),
              ),
              const SizedBox(height: 16),
              StreamBuilder(
                stream: _getSensorPressure(),
                builder: (context, snapshot) =>
                    Text('Sensor Pressure: ${snapshot.data} (hPa)'),
              ),
            ],
          ),
        ),
      );

  Future _isSensorAvailable() =>
      _methodChannel.invokeMethod('isSensorAvailable');

  Stream _getSensorPressure() => _eventChannel.receiveBroadcastStream();
}
